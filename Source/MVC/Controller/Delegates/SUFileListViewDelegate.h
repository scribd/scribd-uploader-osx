/*!
 @brief This class receives and handles drag-and-drop events from the file
 list view.
 @details This class adds files dragged into the file list to the managed object
 context. It prevents files from being dragged out of the list.
 @ingroup delegates
 */

@interface SUFileListViewDelegate : NSObject {
	@private
		IBOutlet SUUploadHelper *uploader;
		IBOutlet SUDatabaseHelper *db;
}

@end
