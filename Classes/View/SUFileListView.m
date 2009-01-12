#import "SUFileListView.h"

@implementation SUFileListView

/*
 Listens for spacebar presses and toggles the Quick Look pane.
 */

- (void) keyDown:(NSEvent *)event {
	if ([[event characters] isEqualToString:@" "]) {
		[quickLook toggleDisplay];
	}
}

@end
