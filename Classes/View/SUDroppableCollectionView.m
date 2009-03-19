#import "SUDroppableCollectionView.h"

@implementation SUDroppableCollectionView

- (void) awakeFromNib {
	if ([delegate respondsToSelector:@selector(dragTypesForCollectionView:)])
		[self registerForDraggedTypes:[delegate dragTypesForCollectionView:self]];
}

- (NSDragOperation) draggingEntered:(id<NSDraggingInfo>)sender {
	if ([delegate respondsToSelector:@selector(collectionView:willBeginDrag:)])
		return [delegate collectionView:self willBeginDrag:sender];
	else return NSDragOperationNone;
}

- (BOOL) prepareForDragOperation:(id<NSDraggingInfo>)sender {
	if ([delegate respondsToSelector:@selector(collectionView:shouldAcceptDrag:)])
		return [delegate collectionView:self shouldAcceptDrag:sender];
	else return YES;
}

- (BOOL) performDragOperation:(id<NSDraggingInfo>)sender {
	if ([delegate respondsToSelector:@selector(collectionView:willAcceptDrag:)])
		return [delegate collectionView:self willAcceptDrag:sender];
	else return NO;
}

- (void) concludeDragOperation:(id<NSDraggingInfo>)sender {
	if ([delegate respondsToSelector:@selector(collectionView:didAcceptDrag:)])
		[delegate collectionView:self didAcceptDrag:sender];
}

@end
