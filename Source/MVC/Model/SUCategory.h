/*!
 @brief Core data entity (named @c Category) that represents a category or
 subcategory a @c Document can be placed into on Scribd.
 @details Categories are organized in a tree structure, with child nodes each
 having a parent ID and the parent having a @c NULL parent ID. Categories are
 also instantiated with a position parameter which determines its ordering in a
 list of other categories at the same level in the tree.
 
 This subclass of @c NSManagedObject gives a category the ability to return its
 @link SUCategory::indexPath index path @endlink, used by the front end to
 locate a selected category in a tree.
 
 Categories are stored by Scribd.com and loaded from an API method at first
 launch. Categories are then periodically reloaded from the server.
 @ingroup model
 */

@interface SUCategory : NSManagedObject {
	@protected
		NSIndexPath *indexPath;
}

#pragma mark Attributes
/** @name Attributes */
//@{

/*!
 @brief The category's display name.
 @details This attribute is required and must be unique in the scope of a
 parent.
 */

@property (copy) NSString *name;

/*!
 @brief The category's position in the display order.
 @details This attribute is required. The display order is provided by
 Scribd.com, and is typically by name.
 */

@property (copy) NSNumber *position;

//@}

#pragma mark Relationships
/** @name Relationships */
//@{

/*!
 @brief The supercategory for this category. @c NULL if this is a root category.
 */

@property (copy) SUCategory *parent;

/*!
 @brief The subcategories underneath this category.
 */

@property (copy) NSSet *children;

//@}

#pragma mark Locating a category
/** @name Locating a category */
//@{

/*!
 @brief Returns an index path that locates this node in the category tree, when
 ordered by position.
 */

@property (readonly) NSIndexPath *indexPath;

//@}
@end
