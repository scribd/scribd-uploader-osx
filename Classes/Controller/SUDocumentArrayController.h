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

#pragma mark Actions

/*!
 @method viewOnWebsite:
 @abstract Opens the selected document's web page on Scribd.com in the default
 browser.
 @param sender The object that initiated the action.
 */

- (IBAction) viewOnWebsite:(id)sender;

/*!
 @method editOnWebsite:
 @abstract Opens the selected document's bulk-edit web page on Scribd.com in the
 default browser.
 @param sender The object that initiated the action.
 */

- (IBAction) editOnWebsite:(id)sender;

@end
