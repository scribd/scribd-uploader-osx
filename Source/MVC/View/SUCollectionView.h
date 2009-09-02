/*!
 @class SUCollectionView
 @abstract A subclass of
 @link //apple_ref/occ/cl/NSCollectionView NSCollectionView @/link that adds
 Quick Look support.
 @discussion This class adds key-event and Quick Look support. If the spacebar
 is pressed, this class tells the delegate to toggle the Quick Look preview
 pane. The quickLook outlet must be connected for this to work. The delegate
 must implement the toggleDisplay method.
 */

@interface SUCollectionView : NSCollectionView {
	@private
		IBOutlet SUQuickLookDelegate *quickLook;
}

@end
