/*!
 @class SUAppDelegate
 @discussion This object receives application events and delegates them to
 the appropriate handlers. It also maintains references to the Core Data
 handlers (the persistent store coordinator, managed object model, and
 managed object context).
 */

@interface SUAppDelegate : NSObject {
	IBOutlet NSWindow *window, *loginSheet, *directoryScanSheet;
	IBOutlet SULoginSheetDelegate *loginSheetDelegate;
	IBOutlet SUDatabaseHelper *db;
	IBOutlet NSTableView *uploadTable;
	IBOutlet SUUploadHelper *uploader;
	IBOutlet NSTreeController *categoriesController;
	IBOutlet SUDirectoryScanner *directoryScanner;
}

/*!
 @method saveAction:
 @abstract Performs the save action for the application, which is to send the
 save: message to the application's managed object context.
 @discussion Any encountered errors are presented to the user.
 @param sender The object that initiated the action.
 */

- (IBAction) saveAction:(id)sender;

/*!
 @method viewAllDocumentsAction:
 @abstract Opens the Scribd.com My Docs page in the default web browser.
 @param sender The object that initiated the action.
 */

- (IBAction) viewAllDocumentsAction:(id)sender;

/*!
 @method uploadAllAction:
 @abstract Uploads every @link SUDocument SUDocument @/link to Scribd.
 @discussion Any encountered errors are presented to the user.
 @param sender The object that initiated the action.
 */

- (IBAction) uploadAllAction:(id)sender;

/*!
 @method loginAction:
 @abstract Displays the login sheet.
 @param sender The object that initiated the action.
 */

- (IBAction) loginAction:(id)sender;

/*!
 @method addFile:
 @abstract Displays an open-file sheet where the user can choose files to add to
 the upload list.
 @param sender The object that initiated the action.
 */

- (IBAction) addFile:(id)sender;

/*!
 @method addAllFiles:
 @abstract Displays an open-file sheet where the user can choose a directory.
 This directory will be scanned and all uploadable documents within it will be
 added.
 @param sender The object that initiated the action.
 */

- (IBAction) addAllFiles:(id)sender;

/*!
 @method displayPreferences:
 @abstract Displays the Preferences window.
 @param sender The object that initiated the action.
 */

- (IBAction) displayPreferences:(id)sender;

@end
