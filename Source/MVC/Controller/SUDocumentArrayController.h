/*!
 @brief A subclass of @c NSArrayController that includes responders for the
 actions of the buttons on the More Information drawer.
 @details This class also configured value transformers that the panel uses.
 @ingroup controller
 */

@interface SUDocumentArrayController : NSArrayController {
	
}

#pragma mark Actions
/** @name Actions */
//@{

/*!
 @brief Opens the selected document's web page on Scribd.com in the default
 browser.
 @param sender The object that initiated the action.
 */

- (IBAction) viewOnWebsite:(id)sender;

/*!
 @brief Opens the selected document's bulk-edit web page on Scribd.com in the
 default browser.
 @param sender The object that initiated the action.
 */

- (IBAction) editOnWebsite:(id)sender;

//@}
@end
