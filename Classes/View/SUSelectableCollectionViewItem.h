/*!
 @class SUSelectableCollectionViewItem
 @abstract A subclass of
 @link //apple_ref/occ/cl/NSCollectionViewItem NSCollectionViewItem @/link that
 colors an @link //apple_ref/occ/cl/NSBox NSBox @/link with a highlight when
 it's selected.
 @discussion Instances of this class must connect the selectionBox outlet to the
 NSBox that is to be colored. This is typically either the root view. The box
 should have its transparent attribute bound to the representedObject.selected
 key path, with the NSNegateBoolean transformer.
 */

@interface SUSelectableCollectionViewItem : NSCollectionViewItem {
	IBOutlet NSBox *selectionBox;
}

@end
