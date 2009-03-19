/*!
 @class SUKeyResponseCollectionView
 @abstract A simple subclass of
 @link //apple_ref/occ/cl/NSScrollView NSScrollView @/link that checks key-down
 events for different keys.
 
 @discussion If the spacebar is pressed, this class tells the
 @link SUQuickLookDelegate SUQuickLookDelegate @/link to toggle the Quick Look
 preview pane. The quickLook outlet must be connected for this to work.
 
 If the up or down arrows are selected, the selection is changed according to
 keyboard selection navigation standards.
 */

@interface SUKeyResponseCollectionView : SUDroppableCollectionView {
	IBOutlet SUQuickLookDelegate *quickLook;
}

@end
