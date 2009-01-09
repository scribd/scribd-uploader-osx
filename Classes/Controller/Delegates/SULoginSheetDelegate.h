#import <Cocoa/Cocoa.h>
#import "SUUploadHelper.h"
#import "SUBusyActionValueTransformer.h"

/*!
 @class SULoginSheetDelegate
 @abstract Delegate class for the login/signup sheet. Handles animations for
 switching between tabs.
 */

@interface SULoginSheetDelegate : NSObject {
	IBOutlet NSButton *loginSignupButton;
	IBOutlet NSWindow *sheet;
	IBOutlet SUUploadHelper *uploader;
	IBOutlet NSTabView *tabs;
}

/*!
 @method signup:
 @abstract Called when the Sign Up button is pressed. Creates a Scribd account
 and continues the upload process.
 @param sender The object that sent the action.
 @discussion If this method is called by a view event, a sender is provided. The
 method then calls itself in a new thread with a NULL sender. The second call
 with the NULL argument will invoke the signup process.
 */

- (IBAction) signup:(id)sender;

/*!
 @method login:
 @abstract Called when the Log In button is pressed. Logs into a Scribd account
 and continues the upload process.
 @param sender The object that sent the action.
 @discussion If this method is called by a view event, a sender is provided. The
 method then calls itself in a new thread with a NULL sender. The second call
 with the NULL argument will invoke the login process.
 */

- (IBAction) login:(id)sender;

/*!
 @method cancel:
 @abstract Called when the Cancel button is pressed. Dismisses the sheet and
 aborts the upload process.
 @param sender The object that sent the action.
 */

- (IBAction) cancel:(id)sender;

/*!
 @method showHelp:
 @abstract Displays the Scribd Uploader Help window with contextual information
 depending on which tab is selected.
 @param sender The object that sent the action.
 */

- (IBAction) showHelp:(id)sender;

@end
