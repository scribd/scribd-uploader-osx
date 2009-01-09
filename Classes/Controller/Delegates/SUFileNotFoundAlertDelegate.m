#import "SUFileNotFoundAlertDelegate.h"

@implementation SUFileNotFoundAlertDelegate

- (void) showAlertFor:(int)deletedFiles singleFileName:(NSString *)filename {
	NSAlert *alert = [[NSAlert alloc] init];
	[alert setAlertStyle:NSWarningAlertStyle];
	[alert addButtonWithTitle:@"OK"];
	if (deletedFiles == 1) {
		[alert setMessageText:[NSString stringWithFormat:@"The file “%@” could not be found.", filename]];
		[alert setInformativeText:@"It has been removed from the list."];
	}
	else {
		[alert setMessageText:[NSString stringWithFormat:@"%d files could not be found.", deletedFiles]];
		[alert setInformativeText:@"These files have been removed from the list."];
	}
	[alert setShowsHelp:YES];
	[alert setHelpAnchor:@"file_moved"];
	
	[alert beginSheetModalForWindow:window modalDelegate:self didEndSelector:@selector(filesNotFoundAlertDidEnd:returnCode:contextInfo:) contextInfo:NULL];
	//TODO this does not display directly under the window
}

/*
 Handles the dismissal of the alert by releasing the object.
 */

- (void) filesNotFoundAlertDidEnd:(NSAlert *)alert returnCode:(int)returnCode contextInfo:(void *)contextInfo {
	[alert release];
};

@end
