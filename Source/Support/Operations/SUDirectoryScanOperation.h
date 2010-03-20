/*!
 @brief An operation that scans a directory for files that can be added to the
 file list, and adds them.
 @ingroup operations
 */

@interface SUDirectoryScanOperation : NSOperation {
	@protected
		NSString *path;
	@private
		NSManagedObjectContext *managedObjectContext;
}

#pragma mark Properties

/*!
 @brief The path to the directory that will be searched.
 */

@property (retain) NSString *path;

/*!
 @brief The managed object context into which new Document entries will be
 added.
 */

@property (retain) NSManagedObjectContext *managedObjectContext;

#pragma mark Initializing and deallocating
/** @name Initializing and deallocating */
//@{

/*!
 @brief The designated initializer supplies a new path and managed object
 context.
 @param directoryPath The directory to search.
 @param context The managed object context to insert found documents into.
 @result The initialized instance.
 */

- (id) initWithPath:(NSString *)directoryPath inManagedObjectContext:(NSManagedObjectContext *)context;

//@}
@end
