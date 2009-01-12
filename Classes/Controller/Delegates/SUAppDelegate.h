#import <Cocoa/Cocoa.h>

#import "SUPrivateDescriptionValueTransformer.h"
#import "SUFileStatusButtonImageValueTransformer.h"
#import "SUDocumentHelper.h"
#import "SUDatabaseHelper.h"
#import "SULoginSheetDelegate.h"
#import "SUFileStatusColorValueTransformer.h"
#import "SUUnarchiveErrorValueTransformer.h"
#import "SULogInButtonTitleValueTransformer.h"
#import "SULoginLabelValueTransformer.h"
#import "SUSessionHelper.h"

/*!
 @class SUAppDelegate
 @discussion This object receives application events and delegates them to
 the appropriate handlers. It also maintains references to the Core Data
 handlers (the persistent store coordinator, managed object model, and
 managed object context).
 */

@interface SUAppDelegate : NSObject {
	IBOutlet NSWindow *window, *loginSheet;
	IBOutlet SULoginSheetDelegate *loginSheetDelegate;
	IBOutlet SUDatabaseHelper *db;
	IBOutlet NSTableView *uploadTable;
	IBOutlet SUUploadHelper *uploader;
}

/*!
 @method saveAction:sender
 @abstract Performs the save action for the application, which is to send the
 save: message to the application's managed object context.
 @discussion Any encountered errors are presented to the user.
 @param sender The object that initiated the action.
 */

- (IBAction) saveAction:(id)sender;

/*!
 @method uploadSelectionAction:sender
 @abstract Uploads every selected @link SUDocument SUDocument @/link to Scribd.
 @param sender The object that initiated the action.
 */

- (IBAction) uploadSelectionAction:(id)sender;

/*!
 @method uploadAllAction:sender
 @abstract Uploads every @link SUDocument SUDocument @/link to Scribd.
 @discussion Any encountered errors are presented to the user.
 @param sender The object that initiated the action.
 */

- (IBAction) uploadAllAction:(id)sender;

/*!
 @method loginAction:sender:
 @abstract Displays the login sheet.
 @param sender The object that initiated the action.
 */

- (IBAction) loginAction:(id)sender;

/*!
 @method addFile:sender
 @abstract Displays an open-file sheet where the user can choose files to add to
 the upload list.
 @param sender The object that initiated the action.
 */

- (IBAction) addFile:(id)sender;

@end
