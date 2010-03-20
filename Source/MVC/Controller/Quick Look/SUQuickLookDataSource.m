#import "SUQuickLookDataSource.h"

@implementation SUQuickLookDataSource

#pragma mark Quick Look

/*
 The number of items in the controller is the same as the number of Quick Look
 items.
 */

- (NSInteger) numberOfPreviewItemsInPreviewPanel:(QLPreviewPanel *)panel {
	return [[files selectionIndexes] count];
}

/*
 Each SUDocument implements QLPreviewItem, so we just return the SUDocument at
 the given index.
 */

- (id <QLPreviewItem>) previewPanel:(QLPreviewPanel *)panel previewItemAtIndex:(NSInteger)index {
	return [[files selectedObjects] objectAtIndex:index];
}

@end
