/*!
 @class SUCollectionView
 @abstract A subclass of
 @link //apple_ref/occ/cl/NSScrollView NSCollectionView @/link adds a key-event
 support, Quick Look support, and drag-and-drop support.
 @discussion This class adds key-event and Quick Look support. If the spacebar
 is pressed, this class tells the
 @link SUQuickLookDelegate SUQuickLookDelegate @/link to toggle the Quick Look
 preview pane. The quickLook outlet must be connected for this to work.
 
 If the up or down arrows are selected, the selection is changed according to
 keyboard selection navigation standards.
 
 This class adds drag-and-drop support. You must connect a delegate that
 responds to drag-and-drop methods.
 */

@interface SUCollectionView : NSCollectionView {
	@protected
		IBOutlet id delegate;
	@private
		IBOutlet SUQuickLookDelegate *quickLook;
		NSMutableDictionary *itemRects;
}

#pragma mark Querying information about collection view items

/*!
 @method rectOfObject:
 @abstract Given an object that exists in the collection backing this collection
 view, returns the rect of its corresponding view item in the local coordinate
 system.
 @param object The object in the collection.
 @result The rect of the collection item view.
 */

- (NSRect) rectOfObject:(id)object;

/*!
 @method rectAtIndex:
 @abstract Given an index in the collection backing this collection view,
 returns the rect of its corresponding view item in the local coordinate system.
 @param object The index in the collection.
 @result The rect of the collection item view.
 */

- (NSRect) rectAtIndex:(NSUInteger)index;

@end
