#import "SUUploadCompleteSheetDelegate.h"

@implementation SUUploadCompleteSheetDelegate

- (IBAction) editOnWebsite:(id)sender {
	NSString *URLFormat = [[NSDictionary dictionaryWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"ScribdAPI" ofType:@"plist"]] objectForKey:@"EditURL"];
	NSError *error = NULL;
	NSArray *docs = [SUDocument completedDocumentsInManagedObjectContext:db.managedObjectContext error:&error];
	if (error) {
		NSAlert *alert = [[NSAlert alloc] init];
		[alert setAlertStyle:NSCriticalAlertStyle];
		[alert setMessageText:@"I couldn’t take you to the Scribd.com website to edit your documents."];
		[alert setInformativeText:@"You can still edit your documents on the Scribd.com website. To learn how, close this alert and click the “?” button."];
		[alert setShowsHelp:YES];
		[alert setHelpAnchor:@"edit_on_website"];
		[alert addButtonWithTitle:@"OK"];
		[alert runModal];
		[alert release];
	}
	else {
		NSMutableArray *docIDs = [[NSMutableArray alloc] initWithCapacity:[docs count]];
		for (SUDocument *doc in docs) [docIDs addObject:doc.scribdID];
		NSString *URL = [NSString stringWithFormat:URLFormat, [docIDs componentsJoinedByString:@","]];
		[[NSWorkspace sharedWorkspace] openURL:[NSURL URLWithString:URL]];
		[docIDs release];
		[self close:self];
	}
}

- (IBAction) close:(id)sender {
	[[NSApplication sharedApplication] endSheet:sheet];
	[sheet orderOut:sender];
}

- (IBAction) showHelp:(id)sender {
	[[NSHelpManager sharedHelpManager] openHelpAnchor:@"after_upload" inBook:@"Scribd Uploader Help"];
}

/*
 Called when the sheet is closed; does nothing for now.
 */

- (void) sheetDidEnd:(NSWindow *)endingSheet returnCode:(int)returnCode contextInfo:(void *)contextInfo {
	
}

@end
