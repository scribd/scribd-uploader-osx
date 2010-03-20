/*!
 @brief The delegate for the main file list window.
 @details This class manages some Undo and toolbar events, and configures the
 Quick Look preview panel when the window gains and relinquishes control of the
 Quick Look system.
 @ingroup delegates
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
