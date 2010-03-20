@class SUDatabaseHelper;

/*!
 @brief Performs a scan on a set of directory paths, searching each for
 uploadable documents and adding those documents to the managed object context.
 
 This class's properties are also used as bindings for the file scan progress
 sheet. It is also a delegate for actions of that sheet.
 @ingroup helpers
 */

@interface SUDirectoryScanner : NSObject {
	@protected
		SUDeferredOperationQueue *operationQueue, *pendingQueue;
		BOOL isScanning;
	@private
		IBOutlet SUDatabaseHelper *db;
}

#pragma mark Setting up the directory scanner
/** @name Setting up the directory scanner */
//@{

/*!
 @brief Queues a directory to be scanned.
 @param path The path to the directory.
 @details This directory will be scanned upon the next call to
 @link SUDirectoryScanner::beginScanning beginScanning @endlink.
 */

- (void) addDirectoryPath:(NSString *)path;

//@}

#pragma mark Scanning
/** @name Scanning */
//@{

/*!
 @brief @c YES if a scan operation is currently in progress; @c NO otherwise.
 */

@property (assign) BOOL isScanning;

/*!
 @brief Displays the scan progress sheet and begins scanning all queued
 directories for uploadable files. Adds qualifying files to the file list.
 @details This method plus
 @link SUDirectoryScanner::addDirectoryPath: addDirectoryPath: @endlink are
 non-blocking and thread-safe: Any calls made to @c addDirectoryPath: while a
 scan is in progress are placed in a separate queue to be used during the next
 scan.
 
 Only one scan can be run at a time.
 */

- (void) beginScanning;

/*!
 @brief Cancels the current scan.
 @param sender The object that initiated the action (unused).
 */

- (IBAction) cancelScanning:(id)sender;

//@}
@end
