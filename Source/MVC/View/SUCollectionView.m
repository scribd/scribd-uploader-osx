#import "SUCollectionView.h"

@implementation SUCollectionView

- (void) awakeFromNib {
	[self registerForDraggedTypes:[NSArray arrayWithObject:NSFilenamesPboardType]];
	[self setBackgroundColors:[NSColor controlAlternatingRowBackgroundColors]]; //TODO set this in the xib
}

- (void) keyDown:(NSEvent *)event {
	BOOL handled = NO;
	
	if ([[event characters] isEqualToString:@" "]) { // space
		[quickLook toggleDisplay];
		handled = YES;
	}
	else if ([[event characters] characterAtIndex:0] == (unichar)(127)) { // backspace
		[[[NSApplication sharedApplication] mainMenu] performKeyEquivalent:event];
		handled = YES;
	}
	
	if (!handled) [super keyDown:event];
}

@end
