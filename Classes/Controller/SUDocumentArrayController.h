/*!
 @class SUDocumentArrayController
 @abstract A subclass of
 @link //apple_ref/occ/cl/NSarrayController NSArrayController @/link that
 includes delegates for drag-and-drop.
 */

@interface SUDocumentArrayController : NSArrayController {
	IBOutlet SUDatabaseHelper *db;
	IBOutlet SUUploadHelper *uploader;
}

@end
