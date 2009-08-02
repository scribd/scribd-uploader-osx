/*!
 @class SUDirectoryScanOperation
 @abstract An operation that scans a directory for files that can be added to
 the file list, and adds them.
 */

@interface SUDirectoryScanOperation : NSOperation {
	NSString *path;
	NSManagedObjectContext *managedObjectContext;
}

#pragma mark Properties

/*!
 @property path
 @abstract The path to the directory that will be searched.
 */

@property (retain) NSString *path;

/*!
 @property managedObjectContext
 @abstract The managed object context into which new Document entries will be
 added.
 */

@property (retain) NSManagedObjectContext *managedObjectContext;

#pragma mark Initializing and deallocating

/*!
 @method initWithPath:inManagedObjectContext:
 @abstract The designated initializer supplies a new path and managed object
 context.
 @param directoryPath The directory to search.
 @param context The managed object context to insert found documents into.
 @result The initialized instance.
 */

- (id) initWithPath:(NSString *)directoryPath inManagedObjectContext:(NSManagedObjectContext *)context;

@end
