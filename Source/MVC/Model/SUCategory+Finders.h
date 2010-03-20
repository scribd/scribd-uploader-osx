/*!
 @brief Methods for loading SUCategory records.
 @todo The @@see sections of this file aren't working properly.
 @ingroup model
 */

@interface SUCategory (Finders)

#pragma mark Finding categories
/** @name Finding categories */
//@{

/*!
 @brief Searches for a category at the given index path, starting from the root.
 @param path The index path to search down.
 @param managedObjectContext The managed object context.
 @result The category located at the index path, or @c NULL if nothing was
 found.
 @see SUCategory::indexPath
 @see SUCategory(Finders)::categoryAtIndexPath:inManagedObjectContext:
 */

+ (SUCategory *) categoryAtIndexPath:(NSIndexPath *)path inManagedObjectContext:(NSManagedObjectContext *)managedObjectContext;

/*!
 @brief Searches for a category at the given index path, relative to this
 category.
 @param path The index path to search down.
 @param managedObjectContext The managed object context.
 @result The category located at the index path relative to the receiver, or
 @c NULL if nothing was found.
 @see SUCategory::indexPath
 @see SUCategory(Finders)::categoryAtIndexPath:inManagedObjectContext:
 */

- (SUCategory *) categoryAtIndexPath:(NSIndexPath *)path inManagedObjectContext:(NSManagedObjectContext *)managedObjectContext;

/*!
 @brief Returns the number of categories in a managed object context.
 @param managedObjectContext The managed object context.
 @result The number of category records.
 */

+ (NSUInteger) countInManagedObjectContext:(NSManagedObjectContext *)managedObjectContext;

//@}
@end
