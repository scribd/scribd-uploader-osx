/*!
 @brief Delegate for the Publisher Information panel.
 @details Responds to events from the Publisher Information panel and configures
 value transformers used by the panel.
 @ingroup delegates
 */

@interface SUPublisherPanelController : NSObject {
	@private
		IBOutlet NSPanel *panel;
		IBOutlet NSMenuItem *togglePanelItem;
		IBOutlet NSArrayController *documents;
}

#pragma mark Actions
/** @name Actions */
//@{

/*!
 @brief Opens a help page regarding the publisher panel.
 @param sender The object that initiated the action (unused).
 */

- (IBAction) showHelp:(id)sender;

/*!
 @brief Shows or hides the publisher panel and updates the "Show/Hide Publisher
 Panel" menu item to reflect the change.
 @param sender The object that initiated the action (unused).
 */

- (IBAction) toggleMenuItem:(id)sender;

/*!
 @brief Sets the date published of all selected documents to the current date.
 @param sender The object that initiated the action (unused).
 */

- (IBAction) setToday:(id)sender;

//@}
@end
