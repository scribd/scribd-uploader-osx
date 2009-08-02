/*!
 @class SUFileListViewDelegate
 @abstract This class receives and handles drag-and-drop events from the file
 list view.
 */

@interface SUFileListViewDelegate : NSObject {
	@private
		IBOutlet SUUploadHelper *uploader;
		IBOutlet SUDatabaseHelper *db;
}

@end
