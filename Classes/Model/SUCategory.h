/*!
 @class SUCategory
 @abstract Core data entity (named Category) that represents a category or
 subcategory a Document can be placed into on Scribd.
 @discussion Categories are organized in a tree structure, with child nodes each
 having a parent ID and the parent having a NULL parent ID. Categories are also
 instantiated with a position parameter which determines its ordering in a list
 of other categories at the same level in the tree.
 
 This subclass gives a Category the ability to return its
 @link indexPath index path @/link, used by the front end to locate a selected
 category in a tree.
 
 Categories are stored by Scribd.com and loaded from an API method at first
 launch. Categories are then periodically reloaded from the server.
 */

@interface SUCategory : NSManagedObject {
	NSIndexPath *indexPath;
}

#pragma mark First-order properties

/*!
 @property name
 @abstract The category's display name.
 @discussion Must be unique in the scope of a parent.
 */

@property (copy) NSString *name;

/*!
 @property position
 @abstract The category's position in the display order.
 @discussion The display order is provided by Scribd.com, and is typically by
 name.
 */

@property (copy) NSNumber *position;

#pragma mark Relationships

/*!
 @property parent
 @abstract The supercategory for this category. NULL if this is a root category.
 */

@property (copy) SUCategory *parent;

/*!
 @property children
 @abstract The subcategories underneath this category.
 */

@property (copy) NSSet *children;

#pragma mark Derived properties

/*!
 @property indexPath
 @abstract Returns an index path that locates this node in the category tree,
 when ordered by position.
 */

@property (readonly) NSIndexPath *indexPath;

@end
