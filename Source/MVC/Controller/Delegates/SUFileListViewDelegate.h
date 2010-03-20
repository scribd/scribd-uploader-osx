/*!
 @class SUFileListViewDelegate
 @abstract This class receives and handles drag-and-drop events from the file
 list view, and acts as the Quick Look controller.
 */

@interface SUFileListViewDelegate : NSObject {
	@private
		IBOutlet SUUploadHelper *uploader;
		IBOutlet SUDatabaseHelper *db;
}

@end
