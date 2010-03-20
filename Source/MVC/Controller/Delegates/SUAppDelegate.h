/*!
 @brief The application delegate and responder for menu events.
 @details This object receives menu bar events and delegates them to the
 appropriate handlers. It also maintains references to the Core Data handlers
 (the persistent store coordinator, managed object model, and managed object
 context), manages the application startup, and is the delegate for the
 application.
 @ingroup delegates
 */

@interface SUAppDelegate : NSObject {
	@private
		IBOutlet NSWindow *window, *loginSheet, *directoryScanSheet;
		IBOutlet SULoginSheetDelegate *loginSheetDelegate;
		IBOutlet SUFileNotFoundAlerter *fileNotFoundDelegate;
		IBOutlet SUDatabaseHelper *db;
		IBOutlet SUUploadHelper *uploader;
		IBOutlet NSTreeController *categoriesController;
		IBOutlet SUDirectoryScanner *directoryScanner;
		IBOutlet NSMenuItem *quickLookMenuItem;
}

#pragma mark Actions
/** @name Actions */
//@{

/*!
 @brief Performs the save action for the application, which is to send the
 @c save: message to the application's managed object context.
 @details Any encountered errors are presented to the user.
 @param sender The object that initiated the action (unused).
 */

- (IBAction) saveFileList:(id)sender;

/*!
 @brief Uploads every SUDocument to Scribd.
 @details Any encountered errors are presented to the user.
 @param sender The object that initiated the action (unused).
 */

- (IBAction) uploadAll:(id)sender;

/*!
 @brief Displays the login sheet.
 @param sender The object that initiated the action (unused).
 */

- (IBAction) showLoginSheet:(id)sender;

/*!
 @brief Displays an open-file sheet where the user can choose files to add to
 the upload list.
 @param sender The object that initiated the action (unused).
 */

- (IBAction) addFile:(id)sender;

/*!
 @brief Displays an open-file sheet where the user can choose a directory.
 This directory will be scanned and all uploadable documents within it will be
 added.
 @param sender The object that initiated the action (unused).
 */

- (IBAction) addAllFiles:(id)sender;

/*!
 @brief Displays the Preferences window.
 @param sender The object that initiated the action.
 */

- (IBAction) displayPreferences:(id)sender;

/*!
 @brief Displays the Quick Look panel and toggles the menu item title.
 @param sender The object that initiated the action.
 */

- (IBAction) toggleQuickLookPanel:(id)sender;

//@}
@end
