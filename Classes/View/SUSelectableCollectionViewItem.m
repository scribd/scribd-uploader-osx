#import "SUSelectableCollectionViewItem.h"

@implementation SUSelectableCollectionViewItem

#pragma mark Initializing and deallocating

/*
 Colors the selection NSBox to the selected-control system color.
 */

- (void) awakeFromNib {
	[selectionBox setFillColor:[NSColor selectedControlColor]];
}

@end
