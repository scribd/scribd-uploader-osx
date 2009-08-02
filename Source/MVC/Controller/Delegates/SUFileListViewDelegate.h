/*!
 @class SUFileListViewDelegate
 @abstract Drag-and-drop delegate for the file list.
 */

@interface SUFileListViewDelegate : NSObject {
	IBOutlet SUUploadHelper *uploader;
	IBOutlet SUDatabaseHelper *db;
}

@end
