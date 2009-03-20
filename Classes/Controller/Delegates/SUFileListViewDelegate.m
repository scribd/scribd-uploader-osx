#import "SUFileListViewDelegate.h"

@implementation SUFileListViewDelegate

/*
 The view accepts files for drag-and-drop operations.
 */

- (NSArray *) dragTypesForCollectionView:(SUCollectionView *)view {
	return [NSArray arrayWithObject:NSFilenamesPboardType];
}

/*
 Accepts only files for drag-and-drop operations with a generic drag type;
 otherwise rejects the drag.
 */

- (NSDragOperation) collectionView:(SUCollectionView *)view willBeginDrag:(id<NSDraggingInfo>)drag {
	if (!uploader.isUploading && [[[drag draggingPasteboard] types] containsObject:NSFilenamesPboardType])
		return NSDragOperationGeneric;
	else return NSDragOperationNone;
}

/*
 Adds the dragged files to the managed object context.
 */

- (BOOL) collectionView:(SUCollectionView *)view willAcceptDrag:(id<NSDraggingInfo>)drag {
	NSArray *files = [[drag draggingPasteboard] propertyListForType:NSFilenamesPboardType];
	return [db addFiles:files] > 0;
}

@end
