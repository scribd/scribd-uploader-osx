/*!
 @class SUDatabaseHelper
 @abstract Convenience methods for working with the Core Data objects of this
 application.
 */

@interface SUDatabaseHelper : NSObject {
	NSPersistentStoreCoordinator *persistentStoreCoordinator;
	NSManagedObjectModel *managedObjectModel;
	NSManagedObjectContext *managedObjectContext;
	IBOutlet SUDirectoryScanner *directoryScanner;
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

/*!
 @property applicationSupportFolder
 @abstract The support folder for the application, used to store the Core Data
 store file.
 @discussion This code uses a folder named "Scribd Uploader" for the content,
 either in the NSApplicationSupportDirectory location or (if the former cannot
 be found), the system's temporary directory.
 */

@property (readonly) NSString *applicationSupportFolder;

#pragma mark Adding files

/*!
 @method addFiles:
 @abstract Creates new Document records for each given file path.
 @param files An array of file paths, as strings.
 @result The number of files added and directories scanned.
 @discussion If any directories are included in the list, adds them to the
 @link SUDirectoryScanner directory scanner @/link and then begins a directory
 scan.
 */

- (NSUInteger) addFiles:(NSArray *)files;

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

/*!
 @method purgeCompletedDocuments
 @abstract Removes documents from the list that have been successfully uploaded.
 */

- (void) purgeCompletedDocuments;

/*!
 @method resetProgresses
 @abstract Resets the progress to zero of any document whose upload was aborted
 partway through.
 */

- (void) resetProgresses;

@end
