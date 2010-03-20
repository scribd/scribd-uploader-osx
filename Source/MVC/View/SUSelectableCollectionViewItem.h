/*!
 @brief A subclass of @c NSCollectionViewItem that colors an @c NSBox with a
 highlight when it's selected.
 @details Instances of this class must connect the selectionBox outlet to the
 @c NSBox that is to be colored. This is typically the root view of the view
 prototype. The box should have its transparent attribute bound to the
 @c representedObject.selected key path, with the @c NSNegateBoolean
 transformer.
 @ingroup view
 */

@interface SUSelectableCollectionViewItem : NSCollectionViewItem {
	@protected
		IBOutlet NSBox *selectionBox;
}

@end
