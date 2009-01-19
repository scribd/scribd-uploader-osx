#import "SUUploadErrorController.h"

@implementation SUUploadErrorController

- (void) displayError:(NSArray *)errors atIndex:(NSNumber *)index {
	NSError *error = [errors objectAtIndex:[index unsignedIntValue]];
	if ([error isEqualTo:[NSNull null]]) return;
	NSAlert *alert = [[NSAlert alloc] init];
	[alert setAlertStyle:NSWarningAlertStyle]; //TODO warning or critical depending on error type
	[alert setMessageText:[error localizedDescription]];
	[alert setInformativeText:[error localizedRecoverySuggestion]];
	[alert addButtonWithTitle:@"OK"];
	
	NSString *action = NULL;
	NSString *anchor = @"upload_failed";
	if (action = [[error userInfo] objectForKey:SUActionErrorKey]) {
		anchor = [NSString stringWithFormat:@"%@_%d", [action lowercaseString], [error code]];
	}
	[alert setShowsHelp:YES];
	[alert setHelpAnchor:anchor];
	
	[alert beginSheetModalForWindow:window modalDelegate:self didEndSelector:@selector(alertDidEnd:returnCode:contextInfo:) contextInfo:NULL];
}

/*
 Called when an alert is closed; releases the alert.
 */

- (void) alertDidEnd:(NSAlert *)alert returnCode:(int)returnCode contextInfo:(void *)contextInfo {
	[alert release];
}

@end
