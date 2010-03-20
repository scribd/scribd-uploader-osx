/*!
 @brief Delegate class for the Quick Look preview panel, implementing the
 @c QLPreviewPanelDelegate protocol.
 @details These methods modify the behavior of the Quick Look preview panel. In
 particular, the methods inform Quick Look as to how the panel should appear
 when in a transition state, and that events given to the preview panel should
 be passed to the parent window.
 @ingroup quickLook
 */

@interface SUQuickLookDelegate : NSObject <QLPreviewPanelDelegate> {
	@private
		IBOutlet NSCollectionView *fileListView;
		IBOutlet NSScrollView *scrollView;
		IBOutlet NSArrayController *controller;
}

@end
