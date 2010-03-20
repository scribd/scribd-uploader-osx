/*!
 @brief Delegate class for the login/signup sheet.
 @details This class responds to actions from the login/signup sheet, delegating
 them to the appropriate handlers, validates user input from the fields of
 the sheet, and configures value transformers used by the sheet.
 @ingroup delegates
 */

@interface SULoginSheetDelegate : NSObject {
	@private
		IBOutlet NSButton *loginSignupButton;
		IBOutlet NSWindow *sheet;
		IBOutlet SUUploadHelper *uploader;
		IBOutlet NSTabView *tabs;
}

#pragma mark Actions
/** @name Actions */
//@{

/*!
 @brief Called when the Sign Up button is pressed. Creates a Scribd account and
 continues the upload process.
 @param sender The object that sent the action.
 @details If this method is called by a view event, a sender is provided. The
 method then calls itself in a new thread with a @c NULL sender. The second call
 with the @c NULL argument will invoke the signup process.
 */

- (IBAction) signup:(id)sender;

/*!
 @brief Called when the Log In button is pressed. Logs into a Scribd account and
 continues the upload process.
 @param sender The object that sent the action.
 @details If this method is called by a view event, a sender is provided. The
 method then calls itself in a new thread with a @c NULL sender. The second call
 with the @c NULL argument will invoke the login process.
 */

- (IBAction) login:(id)sender;

/*!
 @brief Called when the Cancel button is pressed. Dismisses the sheet and aborts
 the upload process.
 @param sender The object that sent the action (unused).
 */

- (IBAction) cancel:(id)sender;

/*!
 @brief Displays the Scribd Uploader Help window with contextual information
 depending on which tab is selected.
 @param sender The object that sent the action (unused).
 */

- (IBAction) showHelp:(id)sender;

//@}
@end
