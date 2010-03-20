/*!
 @category SUCategory(Finders)
 @abstract Methods for loading @link SUCategory SUCategory @/link records.
 */

@interface SUCategory (Finders)

#pragma mark Finding categories

/*!
 @method categoryAtIndexPath:inManagedObjectContext:
 @abstract Searches for a category at the given index path, starting from the
 root.
 @param path The index path to search down.
 @param managedObjectContext The managed object context.
 @result The category located at the index path, or NULL if nothing was found.
 */

+ (SUCategory *) categoryAtIndexPath:(NSIndexPath *)path inManagedObjectContext:(NSManagedObjectContext *)managedObjectContext;

/*!
 @method categoryAtIndexPath:inManagedObjectContext:
 @abstract Searches for a category at the given index path, relative to this
 category.
 @param path The index path to search down.
 @param managedObjectContext The managed object context.
 @result The category located at the index path relative to the receiver, or
 NULL if nothing was found.
 */ 

- (SUCategory *) categoryAtIndexPath:(NSIndexPath *)path inManagedObjectContext:(NSManagedObjectContext *)managedObjectContext;

/*!
 @method count
 @abstract Returns the number of categories in a managed object context.
 @param managedObjectContext The managed object context.
 @result The number of category records.
 */

+ (NSUInteger) countInManagedObjectContext:(NSManagedObjectContext *)managedObjectContext;

@end
