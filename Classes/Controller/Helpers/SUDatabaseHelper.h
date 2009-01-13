/*!
 @class SUDatabaseHelper
 @abstract Convenience methods for working with the Core Data objects of this
 application.
 */

@interface SUDatabaseHelper : NSObject {
	IBOutlet SUFileNotFoundAlertDelegate *fileNotFoundAlertDelegate;
	NSPersistentStoreCoordinator *persistentStoreCoordinator;
	NSManagedObjectModel *managedObjectModel;
	NSManagedObjectContext *managedObjectContext;
}

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

@end
