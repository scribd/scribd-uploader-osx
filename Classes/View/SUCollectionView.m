#import "SUCollectionView.h"

@implementation SUCollectionView

#pragma mark Initializing and deallocating

- (void) awakeFromNib {
	itemRects = [[NSMutableDictionary alloc] init];
	if ([delegate respondsToSelector:@selector(dragTypesForCollectionView:)]) {
		NSMethodSignature *sig = [[delegate class] instanceMethodSignatureForSelector:@selector(dragTypesForCollectionView:)];
		NSInvocation *invoc = [NSInvocation invocationWithMethodSignature:sig];
		[invoc setTarget:delegate];
		[invoc setSelector:@selector(dragTypesForCollectionView:)];
		[invoc setArgument:&self atIndex:2];
		[invoc invoke];
		id result;
		[invoc getReturnValue:&result];
		[self registerForDraggedTypes:result];
	}
}

- (void) dealloc {
	[itemRects release];
	[super dealloc];
}

#pragma mark Modifying the Collection View Item

- (NSCollectionViewItem *) newItemForRepresentedObject:(id)object {
	NSCollectionViewItem *item = [super newItemForRepresentedObject:object];
	[itemRects setObject:[item view] forKey:[NSNumber numberWithUnsignedInteger:[[self content] indexOfObject:object]]];
	return item;
}

#pragma mark Querying information about collection view items

- (NSRect) rectOfObject:(id)object {
	return [self rectAtIndex:[[self content] indexOfObject:object]];
}

- (NSRect) rectAtIndex:(NSUInteger)index {
	NSRect rect = [[itemRects objectForKey:[NSNumber numberWithUnsignedInteger:index]] frame];
	rect = [self convertRectToBase:rect];
	return rect;
}

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

#pragma mark Drag and drop

- (NSDragOperation) draggingEntered:(id<NSDraggingInfo>)sender {
	if ([delegate respondsToSelector:@selector(collectionView:willBeginDrag:)]) {
		NSMethodSignature *sig = [[delegate class] instanceMethodSignatureForSelector:@selector(collectionView:willBeginDrag:)];
		NSInvocation *invoc = [NSInvocation invocationWithMethodSignature:sig];
		[invoc setTarget:delegate];
		[invoc setSelector:@selector(collectionView:willBeginDrag:)];
		[invoc setArgument:&self atIndex:2];
		[invoc setArgument:&sender atIndex:3];
		[invoc invoke];
		BOOL result;
		[invoc getReturnValue:&result];
		return result;
	}
	else return NSDragOperationNone;
}

- (BOOL) prepareForDragOperation:(id<NSDraggingInfo>)sender {
	if ([delegate respondsToSelector:@selector(collectionView:shouldAcceptDrag:)]) {
		NSMethodSignature *sig = [[delegate class] instanceMethodSignatureForSelector:@selector(collectionView:shouldAcceptDrag:)];
		NSInvocation *invoc = [NSInvocation invocationWithMethodSignature:sig];
		[invoc setSelector:@selector(collectionView:shouldAcceptDrag:)];
		[invoc setArgument:&self atIndex:2];
		[invoc setArgument:&sender atIndex:3];
		[invoc invoke];
		BOOL result;
		[invoc getReturnValue:&result];
		return result;
	}
	else return YES;
}

- (BOOL) performDragOperation:(id<NSDraggingInfo>)sender {
	if ([delegate respondsToSelector:@selector(collectionView:willAcceptDrag:)]) {
		NSMethodSignature *sig = [[delegate class] instanceMethodSignatureForSelector:@selector(collectionView:willAcceptDrag:)];
		NSInvocation *invoc = [NSInvocation invocationWithMethodSignature:sig];
		[invoc setTarget:delegate];
		[invoc setSelector:@selector(collectionView:willAcceptDrag:)];
		[invoc setArgument:&self atIndex:2];
		[invoc setArgument:&sender atIndex:3];
		[invoc invoke];
		BOOL result;
		[invoc getReturnValue:&result];
		return result;
	}
	else return NO;
}

- (void) concludeDragOperation:(id<NSDraggingInfo>)sender {
	if ([delegate respondsToSelector:@selector(collectionView:didAcceptDrag:)]) {
		NSMethodSignature *sig = [[delegate class] instanceMethodSignatureForSelector:@selector(collectionView:didAcceptDrag:)];
		NSInvocation *invoc = [NSInvocation invocationWithMethodSignature:sig];
		[invoc setTarget:delegate];
		[invoc setSelector:@selector(collectionView:didAcceptDrag:)];
		[invoc setArgument:&self atIndex:2];
		[invoc setArgument:&sender atIndex:3];
		[invoc invoke];
	}
}

@end
