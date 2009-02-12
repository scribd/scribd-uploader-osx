/*!
 @class SUDatabaseHelper
 @abstract Convenience methods for working with the Core Data objects of this
 application.
 */

@interface SUDatabaseHelper : NSObject {
	NSPersistentStoreCoordinator *persistentStoreCoordinator;
	NSManagedObjectModel *managedObjectModel;
	NSManagedObjectContext *managedObjectContext;
}

#pragma mark Properties

/*!
 @property managedObjectModel
 @abstract This application's object-relational schema.
 @discussion Lazily loaded upon first access.
 */

@property (readonly) NSManagedObjectModel *managedObjectModel;

/*!
 @property managedObjectContext
 @abstract The in-memory workspace in which the application performs unsaved
 work.
 @discussion Lazily loaded upon first access.
 */

@property (readonly) NSManagedObjectContext *managedObjectContext;

/*!
 @property persistentStoreCoordinator
 @abstract The interface this application uses to write changes to a persistent
 store.
 @discussion Lazily loaded upon first access.
 */

@property (readonly) NSPersistentStoreCoordinator *persistentStoreCoordinator;

#pragma mark Housekeeping

/*!
 @method purgeNonexistentDocuments:
 @abstract Removes documents from the queue that no longer exist at their
 recorded paths.
 @param singleFileName Will contain a pointer to a string with the name of a
 file removed. This is useful if only one file is removed and you wish to refer
 to it by name.
 @result The number of documents that were removed.
 */

- (NSUInteger) purgeNonexistentDocuments:(NSString **)singleFileName;

@end
