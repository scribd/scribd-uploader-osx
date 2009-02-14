#import "SUUploadErrorController.h"

@implementation SUUploadErrorController

#pragma mark Displaying an error

- (void) displayError:(NSArray *)errors atIndex:(NSNumber *)index {
	NSError *error = [errors objectAtIndex:[index unsignedIntValue]];
	if ([error isEqualTo:[NSNull null]]) {
		// go to the file
		SUDocument *doc = [documentController.arrangedObjects objectAtIndex:[index unsignedIntegerValue]];
		if (doc.uploaded) [[NSWorkspace sharedWorkspace] openURL:doc.scribdURL];
	}
	else {
		// display the error
		NSAlert *alert = [[NSAlert alloc] init];
		[alert setAlertStyle:NSWarningAlertStyle]; //TODO warning or critical depending on error type
		[alert setMessageText:[error localizedDescription]];
		[alert setInformativeText:[error localizedRecoverySuggestion]];
		[alert addButtonWithTitle:@"OK"];
		
		NSString *action = NULL;
		NSString *anchor = @"upload_failed";
		if (action = [[error userInfo] objectForKey:SUActionErrorKey])
			anchor = [[[NSString alloc] initWithFormat:@"%@_%d", [action lowercaseString], [error code]] autorelease];
		[alert setShowsHelp:YES];
		[alert setHelpAnchor:anchor];
		
		[alert beginSheetModalForWindow:window modalDelegate:self didEndSelector:@selector(alertDidEnd:returnCode:contextInfo:) contextInfo:NULL];		
	}
}

#pragma mark Delegate responders

/*
 Called when an alert is closed; releases the alert.
 */

- (void) alertDidEnd:(NSAlert *)alert returnCode:(int)returnCode contextInfo:(void *)contextInfo {
	[alert release];
}

@end
