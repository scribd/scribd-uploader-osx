#import "SUFileListViewDelegate.h"

@implementation SUFileListViewDelegate

#pragma mark Drag and drop

/*
 Accepts only files for drag-and-drop operations with a generic drag type;
 otherwise rejects the drag.
 */

- (NSDragOperation) collectionView:(NSCollectionView *)collectionView validateDrop:(id<NSDraggingInfo>)drag proposedIndex:(NSInteger *)proposedDropIndex dropOperation:(NSCollectionViewDropOperation *)proposedDropOperation {
	if (uploader.isUploading) return NSDragOperationNone;
	*proposedDropOperation = NSCollectionViewDropBefore; // make it appear as if the file will be added, not replaced
	return NSDragOperationGeneric;
}

/*
 Adds the dragged files to the managed object context.
 */

- (BOOL) collectionView:(NSCollectionView *)collectionView acceptDrop:(id<NSDraggingInfo>)drag index:(NSInteger)index dropOperation:(NSCollectionViewDropOperation)dropOperation {
	NSArray *files = [[drag draggingPasteboard] readObjectsForClasses:[NSArray arrayWithObject:[NSURL class]] options:NULL];
	return [db addFiles:[files map:^(id value) { return (id)[value path]; }]] > 0;
}

/*
 Denies any item of the collection view from being dragged out of the collection view.
 */

- (BOOL) collectionView:(NSCollectionView *)collectionView canDragItemsAtIndexes:(NSIndexSet *)indexes withEvent:(NSEvent *)event {
	return NO;
}

@end
