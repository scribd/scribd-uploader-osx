#import "SUKeyResponseCollectionView.h"

@implementation SUKeyResponseCollectionView

#pragma mark Event responders

/*
 Listens for various key events and handles them appropriately. Responds to
 space bar pressed by toggling the Quick Look pane. Responds to arrow keys by
 changing the selection. All other events are passed to the main menu in the
 event that they are keyboard equivalents.
 */

- (void) keyDown:(NSEvent *)event {
	BOOL handled = NO; // assume we don't handle it; if we do, we'll set this to yes
	
	// if it's a space bar, show the quick look pane
	if ([[event characters] isEqualToString:@" "]) {
		[quickLook toggleDisplay];
		handled = YES;
	}
	
	// otherwise, we'll look at the characters and decide what to do
	unichar *characters = malloc(sizeof(unichar)*[[event characters] length]);
	[[event charactersIgnoringModifiers] getCharacters:characters];
	
	// make a new mutable selection from the current selection, to modify as necessary
	NSMutableIndexSet *indexes = [[NSMutableIndexSet alloc] initWithIndexSet:[self selectionIndexes]];
	NSUInteger lastItem = [[self content] count] - 1; // the highest possible selection index
	
	NSUInteger charIndex;
	for (charIndex = 0; charIndex != [[event characters] length]; charIndex++) {
		switch (characters[charIndex]) {
			case NSUpArrowFunctionKey:
				// if we aren't selecting anything when we press the up arrow, select the last item in the list
				if ([indexes count] == 0) [indexes addIndex:lastItem];
				else {
					// if we are holding the shift key increase the selection's lower bound by one if possible
					if (([event modifierFlags] & NSShiftKeyMask) || ([event modifierFlags] & NSCommandKeyMask)) {
						if ([indexes firstIndex] > 0) [indexes addIndex:([indexes firstIndex] - 1)];
					}
					// if not, set the selection to the previous item
					else {
						NSUInteger index = ([indexes firstIndex] == 0 ? 0 : [indexes firstIndex] - 1);
						// if we have the first item selected as part of a group, and we hit the up arrow, select only the first item
						[indexes removeAllIndexes];
						[indexes addIndex:index];
					}
				}
				handled = YES;
				break;
			case NSDownArrowFunctionKey:
				// if we aren't selecting anything when we press the down arrow, select the first item in the list
				if ([indexes count] == 0) [indexes addIndex:0];
				else {
					// if we are holding the shift key increase the selection's upper bound by one if possible
					if (([event modifierFlags] & NSShiftKeyMask) || ([event modifierFlags] & NSCommandKeyMask)) {
						if ([indexes firstIndex] < lastItem) [indexes addIndex:([indexes lastIndex] + 1)];
					}
					// if not, set the selection to the next item
					else {
						NSUInteger index = ([indexes lastIndex] == lastItem ? lastItem : [indexes lastIndex] + 1);
						// if we have the last item selected as part of a group, and we hit the down arrow, select only the last item
						[indexes removeAllIndexes];
						[indexes addIndex:index];
					}
				}
				handled = YES;
				break;
		}
	}
	
	// set our new selection and clean up
	[self setSelectionIndexes:indexes];
	[indexes release];
	free(characters);
	
	// if we didn't handle the key event, assume it's a menu item's key equivalent
	if (!handled) [[[NSApplication sharedApplication] mainMenu] performKeyEquivalent:event];
}

@end
