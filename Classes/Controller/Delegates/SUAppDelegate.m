#import "SUAppDelegate.h"

@interface SUAppDelegate (Private)

/*
 Tells the SUScribdAPI to load the categories from the server, then marks the
 current date as the last category load time.
 */

- (void) loadCategories:(id)unused;

@end

@implementation SUAppDelegate

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
	[NSValueTransformer setValueTransformer:[[[SUFileStatusButtonImageValueTransformer alloc] init] autorelease] forName:@"SUFileStatusButtonImage"];
	[NSValueTransformer setValueTransformer:[[[SUUnarchiveErrorValueTransformer alloc] init] autorelease] forName:@"SUUnarchiveError"];
	[NSValueTransformer setValueTransformer:[[[SULogInButtonTitleValueTransformer alloc] init] autorelease] forName:@"SULogInButtonTitle"];
	[NSValueTransformer setValueTransformer:[[[SULoginLabelValueTransformer alloc] init] autorelease] forName:@"SULoginLabel"];
	[NSValueTransformer setValueTransformer:[[[SUDelimitedStringValueTransformer alloc] init] autorelease] forName:@"SUDelimitTags"];
	[NSValueTransformer setValueTransformer:[[[SUIndexPathValueTransformer alloc] init] autorelease] forName:@"SUIndexPath"];
}

/*
 Registers drag-and-drop types for the upload list, configures Growl, and
 reloads categories if necessary.
 */

- (void) awakeFromNib {
	[[NSValueTransformer valueTransformerForName:@"SUIndexPath"] setValue:db.managedObjectContext forKey:@"managedObjectContext"];
	
	NSArray *acceptedTypes = [[NSArray alloc] initWithObject:NSFilenamesPboardType];
	[uploadTable registerForDraggedTypes:acceptedTypes];
	[acceptedTypes release];
	[uploadTable setVerticalMotionCanBeginDrag:NO];
	
	// configure Growl (necessary because of a bug in growl)
	[GrowlApplicationBridge setGrowlDelegate:@""];
	
	NSSortDescriptor *sortDescriptor = [[NSSortDescriptor alloc] initWithKey:@"position" ascending:YES];
	NSArray *sortDescriptors = [[NSArray alloc] initWithObject:sortDescriptor];
	[sortDescriptor release];
	[categoriesController setSortDescriptors:sortDescriptors];
	[sortDescriptors release];
	
	NSDate *lastCheckTime = [[NSUserDefaults standardUserDefaults] objectForKey:SUDefaultKeyLastCategoryLoad];
	if (!lastCheckTime || -[lastCheckTime timeIntervalSinceNow] >= SUTimeBetweenCategoryLoads || [SUCategory countInManagedObjectContext:db.managedObjectContext] == 0) {
		[NSThread detachNewThreadSelector:@selector(loadCategories:) toTarget:self withObject:NULL];
	}
	
	[[SUSessionHelper sessionHelper] setupForLaunch];
}

/*
 Returns the NSUndoManager for the application. In this case, the manager
 returned is that of the managed object context for the application.
 */

- (NSUndoManager *) windowWillReturnUndoManager:(NSWindow *)window {
	return [db.managedObjectContext undoManager];
}

- (IBAction) saveAction:(id)sender {
	NSError *error = NULL;
	if (![db.managedObjectContext save:&error]) {
		[[NSApplication sharedApplication] presentError:error];
	}
}

- (IBAction) viewAllDocumentsAction:(id)sender {
	NSURL *URL = [[NSURL alloc] initWithString:[[[NSBundle mainBundle] infoDictionary] objectForKey:SUMyDocsURLInfoKey]];
	[[NSWorkspace sharedWorkspace] openURL:URL];
	[URL release];
}

- (IBAction) uploadAllAction:(id)sender {
	if ([[SUSessionHelper sessionHelper] sessionStored])
		[uploader uploadFiles];
	else
		[[NSApplication sharedApplication] beginSheet:loginSheet modalForWindow:window modalDelegate:loginSheetDelegate didEndSelector:@selector(sheetDidEnd:returnCode:contextInfo:) contextInfo:@"all"];
}

- (IBAction) displayPreferences:(id)sender {
	[[SUPreferencesWindowController sharedPrefsWindowController] showWindow:sender];
}

/*
 Disables the Upload button if there are no files to upload or if an upload is
 in progress.
 */

- (BOOL) validateToolbarItem:(NSToolbarItem *)item {
	if ([item action] == @selector(uploadAllAction:)) {
		NSError *error = NULL;
		return (![uploader isUploading] && [SUDocument numberOfUploadableInManagedObjectContext:db.managedObjectContext error:&error] > 0);
	}
	else return YES;
}

- (IBAction) loginAction:(id)sender {
	[[NSApplication sharedApplication] beginSheet:loginSheet modalForWindow:window modalDelegate:loginSheetDelegate didEndSelector:@selector(sheetDidEnd:returnCode:contextInfo:) contextInfo:@"login"];
}

- (IBAction) addFile:(id)sender {
	NSOpenPanel *openPanel = [NSOpenPanel openPanel];
	
	[openPanel setAllowsMultipleSelection:YES];
	[openPanel setPrompt:@"Add"];
	[openPanel beginSheetForDirectory:NULL file:NULL types:[SUDocument scribdFileTypes] modalForWindow:window modalDelegate:self didEndSelector:@selector(openPanelDidEnd:returnCode:contextInfo:) contextInfo:NULL];
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
		NSArray *filesToAdd = [panel filenames];
		for (NSString *path in filesToAdd) {
			SUDocument *existingDocument = NULL;
			if (existingDocument = [SUDocument findByPath:path inManagedObjectContext:db.managedObjectContext])
				[db.managedObjectContext deleteObject:existingDocument];
			NSManagedObject *file = [NSEntityDescription insertNewObjectForEntityForName:@"Document" inManagedObjectContext:db.managedObjectContext];
			[file setValue:[path stringByStandardizingPath] forKey:@"path"];
		}
	}
}

@end

@implementation SUAppDelegate (Private)

- (void) loadCategories:(id)unused {
	NSAutoreleasePool *pool = [[NSAutoreleasePool alloc] init];
	[[SUScribdAPI sharedAPI] loadCategoriesIntoManagedObjectContext:db.managedObjectContext];
	[[NSUserDefaults standardUserDefaults] setObject:[NSDate date] forKey:SUDefaultKeyLastCategoryLoad];
	[pool release];
}

@end
