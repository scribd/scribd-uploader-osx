/*!
 @class SUQuickLookDelegate
 @abstract Delegate class implementing the
 @link //apple_ref/occ/intf/QLPreviewPanelDelegate QLPreviewPanelDelegate @/link
 protocol. Modifies the behavior of the Quick Look window.
 */

@interface SUQuickLookDelegate : NSObject <QLPreviewPanelDelegate> {
	@private
		IBOutlet NSCollectionView *fileListView;
		IBOutlet NSScrollView *scrollView;
		IBOutlet NSArrayController *controller;
}

@end
