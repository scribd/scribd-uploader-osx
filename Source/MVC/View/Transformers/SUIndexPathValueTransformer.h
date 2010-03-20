/*!
 @brief Converts between SUCategory objects and their index paths.
 @details Because this value transformer is meant to work with selections, it
 actually converts between arrays of each object.
 
 This object must be initialized with a managed object context to search for
 categories in.
 @ingroup transformers
 */

@interface SUIndexPathValueTransformer : NSValueTransformer {
	@private
		NSManagedObjectContext *managedObjectContext;
}

#pragma mark Properties

/*!
 @brief The managed object context to search for categories in.
 */

@property (retain) NSManagedObjectContext *managedObjectContext;

@end
