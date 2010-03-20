#import "SUFileListWindowDelegate.h"

@implementation SUFileListWindowDelegate

#pragma mark Delegate responders

/*
 Returns the NSUndoManager for the application. In this case, the manager
 returned is that of the managed object context for the application.
 */

- (NSUndoManager *) windowWillReturnUndoManager:(NSWindow *)window {
	return [db.managedObjectContext undoManager];
}

/*
 Disables the Upload button if there are no files to upload or if an upload is
 in progress.
 */

- (BOOL) validateToolbarItem:(NSToolbarItem *)item {
	if ([item action] == @selector(uploadAll:)) {
		NSError *error = NULL;
		return (![uploader isUploading] && [SUDocument numberOfUploadableInManagedObjectContext:db.managedObjectContext error:&error] > 0);
	}
	else return YES;
}

#pragma mark Quick Look

/*
 The file list view supports the Quick Look window.
 */

- (BOOL) acceptsPreviewPanelControl:(QLPreviewPanel *)panel {
	return YES;
}

/*
 Configures the Quick Look panel once the file list view becomes key.
 */

- (void) beginPreviewPanelControl:(QLPreviewPanel *)panel {
	quickLookPanel = [panel retain];
	[QLPreviewPanel sharedPreviewPanel].dataSource = quickLookDataSource;
	[QLPreviewPanel sharedPreviewPanel].delegate = quickLookDelegate;
	[fileListView addObserver:self forKeyPath:@"selectionIndexes" options:NSKeyValueObservingOptionNew context:NULL];
}

/*
 Resets the Quick Look panel once the file list view relinquishes key.
 */

- (void) endPreviewPanelControl:(QLPreviewPanel *)panel {
	[fileListView removeObserver:self forKeyPath:@"selectionIndexes"];
	[quickLookPanel release];
	quickLookPanel = NULL;
}

#pragma mark KVO

/*
 Called when the document controller's selection changes.
 */

- (void) observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary *)change context:(void *)context {
    if ([keyPath isEqualToString:@"selectionIndexes"]) {
		if (!quickLookPanel) return;
		NSIndexSet *indexes = [change objectForKey:NSKeyValueChangeNewKey];
		quickLookPanel.currentPreviewItemIndex = 0;
		[quickLookPanel reloadData];
	}
	else [super observeValueForKeyPath:keyPath ofObject:object change:change context:context];
}


@end
