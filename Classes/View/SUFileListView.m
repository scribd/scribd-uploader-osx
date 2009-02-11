#import "SUFileListView.h"

@implementation SUFileListView

#pragma mark Event responders

/*
 Listens for spacebar presses and toggles the Quick Look pane.
 */

- (void) keyDown:(NSEvent *)event {
	if ([[event characters] isEqualToString:@" "]) {
		[quickLook toggleDisplay];
	}
	[super keyDown:event];
}

@end
