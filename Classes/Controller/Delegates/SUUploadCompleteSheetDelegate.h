#import <Cocoa/Cocoa.h>

#import "SUDatabaseHelper.h"

/*!
 @class SUUploadCompleteSheetDelegate
 @abstract Receives events from the upload-complete sheet.
 */

@interface SUUploadCompleteSheetDelegate : NSObject {
	IBOutlet SUDatabaseHelper *db;
	IBOutlet NSWindow *sheet;
}

/*!
 @method editOnWebsite:
 @abstract Brings the user to a Scribd.com URL where they can edit the documents
 they have just uploaded.
 @param sender The object that initiated this action.
 */

- (IBAction) editOnWebsite:(id)sender;

/*!
 @method close:
 @abstract Dismisses the sheet.
 @param sender The object that initiated this action.
 */

- (IBAction) close:(id)sender;

/*!
 @method showHelp:
 @abstract Displays a help page relevant to the sheet.
 @param sender The object that initiated this action.
 */

- (IBAction) showHelp:(id)sender;

@end
