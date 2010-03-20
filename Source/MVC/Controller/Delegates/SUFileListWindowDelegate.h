/*!
 @class SUAppDelegate
 @discussion This is the delegate object for the main file list window. Manages
 Quick Look features.
 */

@interface SUFileListWindowDelegate : NSObject {
	@private
		IBOutlet id <QLPreviewPanelDataSource> quickLookDataSource;
		IBOutlet id <QLPreviewPanelDelegate> quickLookDelegate;
		IBOutlet SUDatabaseHelper *db;
		IBOutlet SUUploadHelper *uploader;
		IBOutlet SUCollectionView *fileListView;
		QLPreviewPanel *quickLookPanel;
}

@end
