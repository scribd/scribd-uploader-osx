#import "SUCollectionView.h"

@implementation SUCollectionView

#pragma mark Initialization and deallocation

/*
 Configures drag-and-drop and some collection view preferences that can't be set
 in Interface Builder.
 */

- (void) awakeFromNib {
	[self registerForDraggedTypes:[NSArray arrayWithObject:NSFilenamesPboardType]];
	[self setBackgroundColors:[NSColor controlAlternatingRowBackgroundColors]]; //TODO set this in the xib
}

/*
 Responds to the space key by toggling the Quick Look panel, and the backspace
 key by deleting the selected item.
 */

- (void) keyDown:(NSEvent *)event {
	BOOL handled = NO;
	
	if ([[event charactersIgnoringModifiers] isEqualToString:@" "]) {
		[(SUAppDelegate *)[NSApp delegate] toggleQuickLookPanel:self];
		handled = YES;
	}
	else if ([[event characters] characterAtIndex:0] == (unichar)(127)) { // backspace
		[[[NSApplication sharedApplication] mainMenu] performKeyEquivalent:event];
		handled = YES;
	}
	
	if (!handled) [super keyDown:event];
}

@end
