/*!
 @class SUDirectoryScanner
 @abstract Performs a scan on a set of directory paths, searching each for
 uploadable documents and adding those documents to the managed object context.
 
 This class's properties are also used as bindings for the file scan progress
 sheet. It is also a receiver for actions of that sheet.
 */

@interface SUDirectoryScanner : NSObject {
	IBOutlet SUDatabaseHelper *db;
	SUDeferredOperationQueue *operationQueue, *pendingQueue;
	BOOL isScanning;
}

/*!
 @property isScanning
 @abstract YES if a scan operation is currently in progress; NO otherwise.
 */

@property (assign) BOOL isScanning;

/*!
 @method addDirectoryPath:
 @abstract Queues a directory to be scanned.
 @param path The path to the directory.
 @discussion This directory will be scanned upon the next call to
 @link beginScanning beginScanning @/link.
 */

- (void) addDirectoryPath:(NSString *)path;

/*!
 @method beginScanning
 @abstract Displays the scan progress sheet and begins scanning all queued
 directories for uploadable files. Adds qualifying files to the file list.
 @discussion This method plus @link addDirectoryPath: addDirectoryPath: @/link
 are non-blocking and thread-safe: Any calls made to addDirectoryPath: while a
 scan is in progress are placed in a separate queue to be used during the next
 scan.
 
 Only one scan can be run at a time.
 */

- (void) beginScanning;

/*!
 @method cancelScanning:
 @abstract Cancels the current scan.
 @param sender The object that initiated the action.
 */

- (IBAction) cancelScanning:(id)sender;

@end
