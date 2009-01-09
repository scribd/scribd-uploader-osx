#import "SUAppDelegate.h"

@implementation SUAppDelegate

/*
 Registers value transformers.
 */

+ (void) initialize {
	[NSValueTransformer setValueTransformer:[[[SUPrivateDescriptionValueTransformer alloc] init] autorelease]
									forName:@"SUPrivateDescription"];
	[NSValueTransformer setValueTransformer:[[SUFileStatusColorValueTransformer alloc] init] forName:@"SUFileStatusColor"];	
	[NSValueTransformer setValueTransformer:[[SUFileStatusButtonImageValueTransformer alloc] init] forName:@"SUFileStatusButtonImage"];
	[NSValueTransformer setValueTransformer:[[SUUnarchiveErrorValueTransformer alloc] init] forName:@"SUUnarchiveError"];
	[NSValueTransformer setValueTransformer:[[SULogInButtonTitleValueTransformer alloc] init] forName:@"SULogInButtonTitle"];
	[NSValueTransformer setValueTransformer:[[SULoginLabelValueTransformer alloc] init] forName:@"SULoginLabel"];
}

/*
 Copies the text of the About.rtf file into the text view of the About
 dialog, and registers drag-and-drop types for the upload list.
 */

- (void) awakeFromNib {
	[aboutText readRTFDFromFile:[[NSBundle mainBundle] pathForResource:@"About" ofType:@"rtf"]];
	[uploadTable registerForDraggedTypes:[NSArray arrayWithObject:NSFilenamesPboardType]];
	[uploadTable setVerticalMotionCanBeginDrag:NO];
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

- (IBAction) uploadSelectionAction:(id)sender {
	if ([[SUSessionHelper sessionHelper] sessionStored])
		[uploader uploadFiles];
	else
		[[NSApplication sharedApplication] beginSheet:loginSheet modalForWindow:window modalDelegate:loginSheetDelegate didEndSelector:@selector(sheetDidEnd:returnCode:contextInfo:) contextInfo:@"selection"];
}

- (IBAction) uploadAllAction:(id)sender {
	if ([[SUSessionHelper sessionHelper] sessionStored])
		[uploader uploadFiles];
	else
		[[NSApplication sharedApplication] beginSheet:loginSheet modalForWindow:window modalDelegate:loginSheetDelegate didEndSelector:@selector(sheetDidEnd:returnCode:contextInfo:) contextInfo:@"all"];
}

- (IBAction) loginAction:(id)sender {
	[[NSApplication sharedApplication] beginSheet:loginSheet modalForWindow:window modalDelegate:loginSheetDelegate didEndSelector:@selector(sheetDidEnd:returnCode:contextInfo:) contextInfo:@"login"];
}

- (IBAction) addFile:(id)sender {
	NSOpenPanel *openPanel = [NSOpenPanel openPanel];
	
	[openPanel setAllowsMultipleSelection:YES];
	[openPanel setPrompt:@"Add"];
	[openPanel beginSheetForDirectory:NULL file:NULL types:[[SUDocumentHelper documentManager] scribdFileTypes] modalForWindow:window modalDelegate:self didEndSelector:@selector(openPanelDidEnd:returnCode:contextInfo:) contextInfo:NULL];
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
			if (existingDocument = [[SUDocumentHelper documentManager] findDocumentByPath:path inManagedObjectContext:db.managedObjectContext])
				[db.managedObjectContext deleteObject:existingDocument];
			NSManagedObject *file = [NSEntityDescription insertNewObjectForEntityForName:@"Document" inManagedObjectContext:db.managedObjectContext];
			[file setValue:[path stringByStandardizingPath] forKey:@"path"];
		}
	}
}

@end
