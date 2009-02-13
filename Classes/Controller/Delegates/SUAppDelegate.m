#import "SUAppDelegate.h"

@interface SUAppDelegate (Private)

#pragma mark Helpers

/*
 Tells the SUScribdAPI to load the categories from the server, then marks the
 current date as the last category load time.
 */

- (void) loadCategories:(id)context;

#pragma mark Notifications

/*
 Responds to the scanning-started notification by opening the sheet.
 */

- (void) scanningStarted:(id)context;

/*
 Responds to the scanning-complete notification by closing the sheet.
 */

- (void) scanningDone:(id)context;

@end

#pragma mark -

@implementation SUAppDelegate

#pragma mark Initializing and deallocating

/*
 Registers value transformers.
 */

+ (void) initialize {
	[NSValueTransformer setValueTransformer:[[[SUPrivateDescriptionValueTransformer alloc] init] autorelease]
									forName:@"SUPrivateDescription"];
	[NSValueTransformer setValueTransformer:[[[SUDiscoverabilityDescriptionValueTransformer alloc] init] autorelease]
									forName:@"SUDiscoverabilityDescription"];
	[NSValueTransformer setValueTransformer:[[[SUSingleSelectionOnlyValueTransformer alloc] init] autorelease] forName:@"SUSingleSelectionOnly"];
	[NSValueTransformer setValueTransformer:[[[SUFileStatusColorValueTransformer alloc] init] autorelease] forName:@"SUFileStatusColor"];
	[NSValueTransformer setValueTransformer:[[[SUUnarchiveErrorValueTransformer alloc] init] autorelease] forName:@"SUUnarchiveError"];
	[NSValueTransformer setValueTransformer:[[[SULogInButtonTitleValueTransformer alloc] init] autorelease] forName:@"SULogInButtonTitle"];
	[NSValueTransformer setValueTransformer:[[[SULoginLabelValueTransformer alloc] init] autorelease] forName:@"SULoginLabel"];
	[NSValueTransformer setValueTransformer:[[[SUDelimitedStringValueTransformer alloc] init] autorelease] forName:@"SUDelimitTags"];
	[NSValueTransformer setValueTransformer:[[[SUIndexPathValueTransformer alloc] init] autorelease] forName:@"SUIndexPath"];
	[NSValueTransformer setValueTransformer:[[[SUMetadataTabValueTransformer alloc] init] autorelease] forName:@"SUMetadataTab"];
}

/*
 Performs a variety of application startup tasks.
 */

- (void) awakeFromNib {
	// make sure we're running at least 10.5
	NSUInteger major, minor, bugfix;
	[[NSApplication sharedApplication] getSystemVersionMajor:&major minor:&minor bugfix:&bugfix];
	if (major != 10 || minor < 5) {
		NSAlert *alert = [[NSAlert alloc] init];
		[alert setMessageText:@"Scribd Uploader requires Mac OS X version 10.5.0 or later in order to run."];
		[alert setInformativeText:@"Mac OS X 10.5, code-named Tiger, is available for purchase at www.apple.com."];
		[alert setAlertStyle:NSCriticalAlertStyle];
		[alert addButtonWithTitle:@"Quit"];
		[alert runModal];
		[alert release];
		[[NSApplication sharedApplication] terminate:self];
	}
	
	// make sure we can make our application support folder
	BOOL directory = NO;
	if ([[NSFileManager defaultManager] fileExistsAtPath:db.applicationSupportFolder isDirectory:&directory] && !directory) {
		NSAlert *alert = [[NSAlert alloc] init];
		[alert setMessageText:@"There is a file named “Scribd Uploader” in your Home > Library > Application Support folder that must be moved before Scribd Uploader can be launched."];
		[alert setInformativeText:@"Scribd Uploader creates a folder in your Application Support directory to store your file list."];
		[alert setAlertStyle:NSCriticalAlertStyle];
		[alert addButtonWithTitle:@"Quit"];
		[alert runModal];
		[alert release];
		[[NSApplication sharedApplication] terminate:self];
	}
	
	// create a value transformer that requires an initialized DB
	[[NSValueTransformer valueTransformerForName:@"SUIndexPath"] setValue:db.managedObjectContext forKey:@"managedObjectContext"];
	
	// configure valid types for drag and drop
	NSArray *acceptedTypes = [[NSArray alloc] initWithObject:NSFilenamesPboardType];
	[uploadTable registerForDraggedTypes:acceptedTypes];
	[acceptedTypes release];
	[uploadTable setVerticalMotionCanBeginDrag:NO];
	
	// configure Growl (necessary because of a bug in growl)
	[GrowlApplicationBridge setGrowlDelegate:@""];
	
	// configure categories controller sorting
	NSSortDescriptor *sortDescriptor = [[NSSortDescriptor alloc] initWithKey:@"position" ascending:YES];
	NSArray *sortDescriptors = [[NSArray alloc] initWithObject:sortDescriptor];
	[sortDescriptor release];
	[categoriesController setSortDescriptors:sortDescriptors];
	[sortDescriptors release];
	
	// load categories from website if enough time has passed
	NSDate *lastCheckTime = [[NSUserDefaults standardUserDefaults] objectForKey:SUDefaultKeyLastCategoryLoad];
	if (!lastCheckTime || -[lastCheckTime timeIntervalSinceNow] >= SUTimeBetweenCategoryLoads || [SUCategory countInManagedObjectContext:db.managedObjectContext] == 0) {
		[NSThread detachNewThreadSelector:@selector(loadCategories:) toTarget:self withObject:NULL];
	}
	
	// set up the session helper
	[[SUSessionHelper sessionHelper] setupForLaunch];
	
	// register for scanning notifications
	[[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(scanningStarted:) name:SUScanningStartedNotification object:NULL];
	[[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(scanningDone:) name:SUScanningDoneNotification object:NULL];
	
	// remove docs that have been moved or deleted since last launch
	NSString *fileName = NULL;
	NSUInteger fileCount = [db purgeNonexistentDocuments:&fileName];
	if (fileCount) [fileNotFoundDelegate showAlertFor:fileCount singleFileName:fileName];
	
	// do other persistent-store housekeeping
	[db purgeCompletedDocuments];
	[db resetProgresses];
}

#pragma mark Delegate responders

/*
 Returns the NSUndoManager for the application. In this case, the manager
 returned is that of the managed object context for the application.
 */

- (NSUndoManager *) windowWillReturnUndoManager:(NSWindow *)window {
	return [db.managedObjectContext undoManager];
}

/*
 Disables the Upload button if there are no files to upload or if an upload is
 in progress.
 */

- (BOOL) validateToolbarItem:(NSToolbarItem *)item {
	if ([item action] == @selector(uploadAll:)) {
		NSError *error = NULL;
		return (![uploader isUploading] && [SUDocument numberOfUploadableInManagedObjectContext:db.managedObjectContext error:&error] > 0);
	}
	else return YES;
}

/*
 Implementation of the applicationShouldTerminate: method, used here to
 handle the saving of changes in the application managed object context
 before the application terminates.
 */

- (NSApplicationTerminateReply) applicationShouldTerminate:(NSApplication *)sender {
	NSError *error = NULL;
	int reply = NSTerminateNow;
	
	if (db.managedObjectContext != NULL) {
		if ([db.managedObjectContext commitEditing]) {
			if ([db.managedObjectContext hasChanges] && ![db.managedObjectContext save:&error]) {
				
				// This error handling simply presents error information in a panel with an
				// "Ok" button, which does not include any attempt at error recovery (meaning,
				// attempting to fix the error.) As a result, this implementation will
				// present the information to the user and then follow up with a panel asking
				// if the user wishes to "Quit Anyway", without saving the changes.
				
				// Typically, this process should be altered to include application-specific
				// recovery steps.
				
				BOOL errorResult = [[NSApplication sharedApplication] presentError:error];
				
				if (errorResult == YES) {
					reply = NSTerminateCancel;
				} 
				
				else {
					
					int alertReturn = NSRunAlertPanel(NULL, @"Could not save changes while quitting. Quit anyway?" , @"Quit anyway", @"Cancel", NULL);
					if (alertReturn == NSAlertAlternateReturn) {
						reply = NSTerminateCancel;
					}
				}
			}
		}
		
		else {
			reply = NSTerminateCancel;
		}
	}
	
	return reply;
}

/*
 Called when the Open panel is closed. Adds files to the managed object context.
 */

- (void) openPanelDidEnd:(NSOpenPanel *)panel returnCode:(int)returnCode contextInfo:(void *)contextInfo {
	if (returnCode == NSOKButton) {
		BOOL willScan = NO;
		NSArray *filesToAdd = [panel filenames];
		for (NSString *path in filesToAdd) {
			BOOL dir = NO;
			if ([[NSFileManager defaultManager] fileExistsAtPath:path isDirectory:&dir]) {
				if (dir) {
					[directoryScanner addDirectoryPath:path];
					willScan = YES;
				}
				else [SUDocument createFromPath:path inManagedObjectContext:db.managedObjectContext];
			}
		}
		if (willScan) [directoryScanner beginScanning];
	}
}

#pragma mark Actions

- (IBAction) saveFileList:(id)sender {
	NSError *error = NULL;
	if (![db.managedObjectContext save:&error]) {
		[[NSApplication sharedApplication] presentError:error];
	}
}

- (IBAction) viewAllDocuments:(id)sender {
	NSURL *URL = [[NSURL alloc] initWithString:[[[NSBundle mainBundle] infoDictionary] objectForKey:SUMyDocsURLInfoKey]];
	[[NSWorkspace sharedWorkspace] openURL:URL];
	[URL release];
}

- (IBAction) uploadAll:(id)sender {
	if ([[SUSessionHelper sessionHelper] sessionStored])
		[uploader uploadFiles];
	else
		[[NSApplication sharedApplication] beginSheet:loginSheet modalForWindow:window modalDelegate:loginSheetDelegate didEndSelector:@selector(sheetDidEnd:returnCode:contextInfo:) contextInfo:@"all"];
}

- (IBAction) displayPreferences:(id)sender {
	[[SUPreferencesWindowController sharedPrefsWindowController] showWindow:sender];
}

- (IBAction) showLoginSheet:(id)sender {
	[[NSApplication sharedApplication] beginSheet:loginSheet modalForWindow:window modalDelegate:loginSheetDelegate didEndSelector:@selector(sheetDidEnd:returnCode:contextInfo:) contextInfo:@"login"];
}

- (IBAction) addFile:(id)sender {
	[[NSApplication sharedApplication] activateIgnoringOtherApps:YES];
	[window makeKeyAndOrderFront:self];
	
	NSOpenPanel *openPanel = [NSOpenPanel openPanel];
	[openPanel setAllowsMultipleSelection:YES];
	[openPanel setPrompt:@"Add"];
	[openPanel beginSheetForDirectory:NULL file:NULL types:[SUDocument scribdFileTypes] modalForWindow:window modalDelegate:self didEndSelector:@selector(openPanelDidEnd:returnCode:contextInfo:) contextInfo:NULL];
}

- (IBAction) addAllFiles:(id)sender {
	[[NSApplication sharedApplication] activateIgnoringOtherApps:YES];
	[window makeKeyAndOrderFront:self];
	
	NSOpenPanel *openPanel = [NSOpenPanel openPanel];
	[openPanel setAllowsMultipleSelection:YES];
	[openPanel setPrompt:@"Scan"];
	[openPanel setMessage:@"Choose a directory to scan for documents:"];
	[openPanel setCanChooseFiles:NO];
	[openPanel setCanChooseDirectories:YES];
	[openPanel beginSheetForDirectory:NULL file:NULL types:NULL modalForWindow:window modalDelegate:self didEndSelector:@selector(openPanelDidEnd:returnCode:contextInfo:) contextInfo:NULL];
}

@end

#pragma mark -

@implementation SUAppDelegate (Private)

#pragma mark Helpers

- (void) loadCategories:(id)context {
	NSAutoreleasePool *pool = [[NSAutoreleasePool alloc] init];
	[[SUScribdAPI sharedAPI] loadCategoriesIntoManagedObjectContext:db.managedObjectContext];
	[[NSUserDefaults standardUserDefaults] setObject:[NSDate date] forKey:SUDefaultKeyLastCategoryLoad];
	[pool release];
}

#pragma mark Notifications

- (void) scanningStarted:(id)context {
	if ([context isKindOfClass:[NSNotification class]]) [NSThread detachNewThreadSelector:@selector(scanningStarted:) toTarget:self withObject:NULL];
	else {
		NSAutoreleasePool *pool = [[NSAutoreleasePool alloc] init];
		while ([window attachedSheet]); // wait for the open panel to disappear, otherwise strange things happen
		@synchronized(directoryScanner) {
			// to prevent the sheet from hanging there, we perform these tasks in a critical block
			if (!directoryScanner.isScanning) return;
			[[NSApplication sharedApplication] beginSheet:directoryScanSheet modalForWindow:window modalDelegate:directoryScanner didEndSelector:@selector(sheetDidEnd:returnCode:contextInfo:) contextInfo:NULL];
		}
		[pool release];
	}
}

- (void) scanningDone:(id)context {
	[[NSApplication sharedApplication] endSheet:directoryScanSheet];
}

@end
