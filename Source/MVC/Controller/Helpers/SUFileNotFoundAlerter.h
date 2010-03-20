/*!
 @brief This class displays an alert when the upload list contains files that
 no longer exist, and acts as the delegate for that alert.
 @details This alert may be ready before the file list is, so to prevent the
 alert sheet from not having a window to attach to, this class observes the file
 list and waits for it to be ready for the sheet.
 @ingroup helpers
 */

@interface SUFileNotFoundAlerter : NSObject {
	@private
		IBOutlet NSWindow *window;
}

#pragma mark Showing the alert
/** @name Showing the alert */
//@{

/*!
 @brief Displays an alert warning the users that files were removed from the
 list.
 @param deletedFiles The number of files that were removed from the list.
 @param filename If only one file was deleted, this parameter should contain the
 name of the deleted file.
 @todo Potential race condition if the window is made visible during the
 @c addObserver: call.
 */

- (void) showAlertFor:(NSUInteger)deletedFiles singleFileName:(NSString *)filename;

//@}
@end
