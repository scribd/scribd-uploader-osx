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
	SUMultipleValuesToggleValueTransformer *privateDescriptionTransformer = [[SUMultipleValuesToggleValueTransformer alloc] init];
	privateDescriptionTransformer.trueValue = NSLocalizedString(@"{0} will only be visible to you or people you choose.", NULL);
	privateDescriptionTransformer.falseValue = NSLocalizedString(@"{0} will be visible to everyone once {1} uploaded.", NULL);
	privateDescriptionTransformer.mixedValue = NSLocalizedString(@"Check this box to make these documents unavailable to other people.", NULL);
	privateDescriptionTransformer.emptyValue = NSLocalizedString(@"Check this box to make a document unavailable to other people.", NULL);
	NSArray *singulars = [[NSArray alloc] initWithObjects:NSLocalizedString(@"This document", NULL), NSLocalizedString(@"it is", @"document"), NULL];
	NSArray *plurals = [[NSArray alloc] initWithObjects:NSLocalizedString(@"These documents", NULL), NSLocalizedString(@"they are", @"document"), NULL];
	privateDescriptionTransformer.singularInsertions = singulars;
	privateDescriptionTransformer.pluralInsertions = plurals;
	[singulars release];
	[plurals release];
	[NSValueTransformer setValueTransformer:[privateDescriptionTransformer autorelease] forName:@"SUPrivateDescription"];
	
	[NSValueTransformer setValueTransformer:[[[SUToggleValueTransformer alloc] initWithTrueValue:NSLocalizedString(@"Your document is private, so no one will be able to discover it.", NULL)
																					  falseValue:NSLocalizedString(@"To make your document more discoverable, add more information above.", NULL)] autorelease]
									forName:@"SUDiscoverabilityDescription"];
	[NSValueTransformer setValueTransformer:[[[SUSingleSelectionOnlyValueTransformer alloc] init] autorelease] forName:@"SUSingleSelectionOnly"];
	[NSValueTransformer setValueTransformer:[[[SUUnarchiveErrorValueTransformer alloc] init] autorelease] forName:@"SUUnarchiveError"];
	[NSValueTransformer setValueTransformer:[[[SUToggleValueTransformer alloc] initWithTrueValue:NSLocalizedString(@"Switch Users", @"command")
																					  falseValue:NSLocalizedString(@"Log In", @"command")] autorelease] forName:@"SULogInButtonTitle"];
	[NSValueTransformer setValueTransformer:[[[SULoginLabelValueTransformer alloc] init] autorelease] forName:@"SULoginLabel"];
	[NSValueTransformer setValueTransformer:[[[SUDelimitedStringValueTransformer alloc] init] autorelease] forName:@"SUDelimitTags"];
	[NSValueTransformer setValueTransformer:[[[SUIndexPathValueTransformer alloc] init] autorelease] forName:@"SUIndexPath"];
	[NSValueTransformer setValueTransformer:[[[SUToggleValueTransformer alloc] initWithTrueValue:@"After Upload" falseValue:@"Before Upload"] autorelease] forName:@"SUMetadataTab"];
	
	NSImage *successImage = [[NSImage alloc] initByReferencingFile:[[NSBundle mainBundle] pathForResource:@"Go" ofType:@"png"]];
	NSImage *cautionImage = [[NSImage alloc] initByReferencingFile:[[NSBundle mainBundle] pathForResource:@"Caution" ofType:@"png"]];
	NSImage *errorImage = [[NSImage alloc] initByReferencingFile:[[NSBundle mainBundle] pathForResource:@"Error" ofType:@"png"]];
	NSDictionary *imageMappings = [[NSDictionary alloc] initWithObjectsAndKeys:
								   successImage, @"Success",
								   cautionImage, @"Caution",
								   errorImage, @"Error",
								   NULL];
	[successImage release];
	[cautionImage release];
	[errorImage release];
	[NSValueTransformer setValueTransformer:[[[SUMappingValueTransformer alloc] initWithDictionary:imageMappings] autorelease] forName:@"SUFileStatusButtonImage"];
	[imageMappings release];
	
	successImage = [[NSImage alloc] initByReferencingFile:[[NSBundle mainBundle] pathForResource:@"Go Clicked" ofType:@"png"]];
	cautionImage = [[NSImage alloc] initByReferencingFile:[[NSBundle mainBundle] pathForResource:@"Caution Clicked" ofType:@"png"]];
	errorImage = [[NSImage alloc] initByReferencingFile:[[NSBundle mainBundle] pathForResource:@"Error Clicked" ofType:@"png"]];
	imageMappings = [[NSDictionary alloc] initWithObjectsAndKeys:
					 successImage, @"Success",
					 cautionImage, @"Caution",
					 errorImage, @"Error",
					 NULL];
	[successImage release];
	[cautionImage release];
	[errorImage release];
	[NSValueTransformer setValueTransformer:[[[SUMappingValueTransformer alloc] initWithDictionary:imageMappings] autorelease] forName:@"SUFileStatusButtonAlternateImage"];
	[imageMappings release];
	
	NSDictionary *statusButtonToolTips = [[NSDictionary alloc] initWithObjectsAndKeys:
										  NSLocalizedString(@"Click this button to view your document on Scribd.com.", NULL), @"Success",
										  NSLocalizedString(@"Click this button to learn more about why your document could not be uploaded.", NULL), @"Error",
										  NSLocalizedString(@"Click this button to learn more about why your document could not have its metadata assigned.", NULL), @"Caution",
										  NULL];
	[NSValueTransformer setValueTransformer:[[[SUMappingValueTransformer alloc] initWithDictionary:statusButtonToolTips] autorelease] forName:@"SUStatusButtonToolTip"];
	[statusButtonToolTips release];
	
	SUHumanizeDimensionValueTransformer *timeValueTransformer = [[SUHumanizeDimensionValueTransformer alloc] initWithRootUnit:NSLocalizedString(@"second", @"unit of time")];
	[timeValueTransformer addUnitWithName:NSLocalizedString(@"minute", @"unit of time") sizeInRootUnits:60];
	[timeValueTransformer addUnitWithName:NSLocalizedString(@"hour", @"unit of time") sizeInRootUnits:60*60];
	[timeValueTransformer addUnitWithName:NSLocalizedString(@"day", @"unit of time") sizeInRootUnits:60*60*24];
	[NSValueTransformer setValueTransformer:[timeValueTransformer autorelease] forName:@"SUHumanizeSeconds"];
	
	SUHumanizeDimensionValueTransformer *informationValueTransformer = [[SUHumanizeDimensionValueTransformer alloc] initWithRootUnit:NSLocalizedString(@"byte", @"unit of data")];
	[informationValueTransformer addUnitWithName:NSLocalizedString(@"KB", @"kilobyte") sizeInRootUnits:1024];
	[informationValueTransformer addUnitWithName:NSLocalizedString(@"MB", @"megabyte") sizeInRootUnits:1024*1024];
	[informationValueTransformer addUnitWithName:NSLocalizedString(@"GB", @"gigabyte") sizeInRootUnits:1024*1024*1024];
	[NSValueTransformer setValueTransformer:[informationValueTransformer autorelease] forName:@"SUHumanizeBytes"];
}

/*
 Performs a variety of application startup tasks.
 */

- (void) awakeFromNib {
	// make sure we're running at least 10.6
	NSUInteger major, minor, bugfix;
	[[NSApplication sharedApplication] getSystemVersionMajor:&major minor:&minor bugfix:&bugfix];
	if (major != 10 || minor < 6) {
		NSAlert *alert = [[NSAlert alloc] init];
		[alert setMessageText:NSLocalizedString(@"Scribd Uploader requires Mac OS X version 10.6.0 or later in order to run.", NULL)];
		[alert setInformativeText:NSLocalizedString(@"Mac OS X 10.6, code-named Snow Leopard, is available for purchase at www.apple.com.", NULL)];
		[alert setAlertStyle:NSCriticalAlertStyle];
		[alert addButtonWithTitle:NSLocalizedString(@"Quit", @"command")];
		[alert runModal];
		[alert release];
		[[NSApplication sharedApplication] terminate:self];
	}
	
	// make sure we can make our application support folder
	BOOL directory = NO;
	if ([[NSFileManager defaultManager] fileExistsAtPath:db.applicationSupportFolder isDirectory:&directory] && !directory) {
		NSAlert *alert = [[NSAlert alloc] init];
		[alert setMessageText:NSLocalizedString(@"There is a file named “Scribd Uploader” in your Home > Library > Application Support folder that must be moved before Scribd Uploader can be launched.", NULL)];
		[alert setInformativeText:NSLocalizedString(@"Scribd Uploader creates a folder in your Application Support directory to store your file list.", NULL)];
		[alert setAlertStyle:NSCriticalAlertStyle];
		[alert addButtonWithTitle:NSLocalizedString(@"Quit", @"command")];
		[alert runModal];
		[alert release];
		[[NSApplication sharedApplication] terminate:self];
	}
	
	// create a value transformer that requires an initialized DB
	[[NSValueTransformer valueTransformerForName:@"SUIndexPath"] setValue:db.managedObjectContext forKey:@"managedObjectContext"];
	
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
	[[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(scanningStarted:) name:SUScanningDidBeginNotification object:NULL];
	[[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(scanningDone:) name:SUScanningDidCompleteNotification object:NULL];
	
	// remove docs that have been moved or deleted since last launch
	NSString *fileName = NULL;
	NSUInteger fileCount = [db purgeNonexistentDocuments:&fileName];
	if (fileCount) [fileNotFoundDelegate showAlertFor:fileCount singleFileName:fileName];
	
	// do other persistent-store housekeeping
	[db purgeCompletedDocuments];
	[db resetProgresses];
	
	// check the application directory
	[[TMMoveToApplicationsFolder applicationMover] checkApplicationFolder];
	
	// add uncountable abbreviations
	[[TMInflector inflector] addUncountableWords:@"kb", @"mb", @"gb", NULL];
}

#pragma mark Delegate responders

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
				if (errorResult == YES) reply = NSTerminateCancel;
				else {
					int alertReturn = NSRunAlertPanel(NULL,
													  NSLocalizedString(@"Could not save changes while quitting. Quit anyway?", NULL),
													  NSLocalizedString(@"Quit anyway", @"command"),
													  NSLocalizedString(@"Cancel", @"command"),
													  NULL);
					if (alertReturn == NSAlertAlternateReturn) reply = NSTerminateCancel;
				}
			}
		}
		else reply = NSTerminateCancel;
	}
	
	return reply;
}

#pragma mark Actions

- (IBAction) saveFileList:(id)sender {
	NSError *error = NULL;
	if (![db.managedObjectContext save:&error]) {
		[[NSApplication sharedApplication] presentError:error];
	}
}

- (IBAction) uploadAll:(id)sender {
	if ([[SUSessionHelper sessionHelper] sessionStored])
		[uploader uploadFiles];
	else
		[[NSApplication sharedApplication] beginSheet:loginSheet modalForWindow:window modalDelegate:loginSheetDelegate didEndSelector:@selector(sheetDidEnd:returnCode:contextInfo:) contextInfo:@"upload"];
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
	[openPanel setPrompt:NSLocalizedString(@"Add", @"command, as in append")];
	[openPanel setAllowedFileTypes:[SUDocument scribdFileTypes]];
	void (^handler)(NSInteger) = ^(NSInteger returnCode) {
		if (returnCode == NSOKButton) [db addFiles:[openPanel filenames]];
	};
	[openPanel beginSheetModalForWindow:window completionHandler:handler];
}

- (IBAction) addAllFiles:(id)sender {
	[[NSApplication sharedApplication] activateIgnoringOtherApps:YES];
	[window makeKeyAndOrderFront:self];
	
	NSOpenPanel *openPanel = [NSOpenPanel openPanel];
	[openPanel setAllowsMultipleSelection:YES];
	[openPanel setPrompt:NSLocalizedString(@"Scan", @"command")];
	[openPanel setMessage:NSLocalizedString(@"Choose a directory to scan for documents:", NULL)];
	[openPanel setCanChooseFiles:NO];
	[openPanel setCanChooseDirectories:YES];
	void (^handler)(NSInteger) = ^(NSInteger returnCode) {
		if (returnCode == NSOKButton) [db addFiles:[openPanel filenames]];
	};
	[openPanel beginSheetModalForWindow:window completionHandler:handler];
}

- (IBAction) toggleQuickLookPanel:(id)sender {
	if ([QLPreviewPanel sharedPreviewPanelExists] && [[QLPreviewPanel sharedPreviewPanel] isVisible]) {
		[[QLPreviewPanel sharedPreviewPanel] orderOut:sender];
		[quickLookMenuItem setTitle:NSLocalizedString(@"Open Quick Look Panel", NULL)];
	}
	else {
		[[QLPreviewPanel sharedPreviewPanel] makeKeyAndOrderFront:sender];
		[quickLookMenuItem setTitle:NSLocalizedString(@"Close Quick Look Panel", NULL)];
	}
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
	@synchronized(directoryScanner) {
		[[NSApplication sharedApplication] endSheet:directoryScanSheet];
	}
}

@end
