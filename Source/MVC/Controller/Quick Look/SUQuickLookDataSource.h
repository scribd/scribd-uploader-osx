/*!
 @class SUQuickLookDataSource
 @abstract Implements the
 @link //apple_ref/occ/intf/QLPreviewPanelDataSource QLPreviewPanelDataSource @/link
 protocol. Acts as a link between the Quick Look window and the controller whose
 arranged objects are the source of the Quick Look data.
 */

@interface SUQuickLookDataSource : NSObject <QLPreviewPanelDataSource> {
	@private IBOutlet NSArrayController *files;
}

@end
