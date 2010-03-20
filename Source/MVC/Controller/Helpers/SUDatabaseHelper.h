/*!
 @brief Convenience methods and propertires for working with the Core Data
 objects in this application's managed object context.
 @ingroup helpers
 */

@interface SUDatabaseHelper : NSObject {
	@private
		NSPersistentStoreCoordinator *persistentStoreCoordinator;
		NSManagedObjectModel *managedObjectModel;
		NSManagedObjectContext *managedObjectContext;
		IBOutlet SUDirectoryScanner *directoryScanner;
}

#pragma mark Core Data
/** @name Core Data */
//@{

/*!
 @brief This application's object-relational schema.
 @details Lazily loaded upon first access.
 */

@property (readonly) NSManagedObjectModel *managedObjectModel;

/*!
 @brief The in-memory workspace in which the application performs unsaved work.
 @details Lazily loaded upon first access.
 */

@property (readonly) NSManagedObjectContext *managedObjectContext;

/*!
 @brief The interface this application uses to write changes to a persistent
 store.
 @details Lazily loaded upon first access.
 */

@property (readonly) NSPersistentStoreCoordinator *persistentStoreCoordinator;

/*!
 @brief The support folder for the application, used to store the Core Data
 store file.
 @details This code uses a folder named @c Scribd Uploader for the content,
 either in the @c NSApplicationSupportDirectory location or (if the former
 cannot be found), the system's temporary directory.
 */

@property (readonly) NSString *applicationSupportFolder;

//@}

#pragma mark Adding files
/** @name Adding files */
//@{

/*!
 @brief Creates new @c Document records for each given file path.
 @param files An array of file paths, as strings.
 @result The number of files added and directories scanned.
 @details If any directories are included in the list, adds them to the
 @link SUDirectoryScanner directory scanner @endlink and then begins a directory
 scan.
 */

- (NSUInteger) addFiles:(NSArray *)files;

//@}

#pragma mark Housekeeping
/** @name Housekeeping */
//@{

/*!
 @brief Removes documents from the queue that no longer exist at their recorded
 paths.
 @param singleFileName Will contain a pointer to a string with the name of a
 file removed. This is useful if only one file is removed and you wish to refer
 to it by name.
 @result The number of documents that were removed.
 */

- (NSUInteger) purgeNonexistentDocuments:(NSString **)singleFileName;

/*!
 @brief Removes documents from the list that have been successfully uploaded.
 */

- (void) purgeCompletedDocuments;

/*!
 @brief Resets the progress to zero of any document whose upload was aborted
 partway through.
 */

- (void) resetProgresses;

//@}
@end
