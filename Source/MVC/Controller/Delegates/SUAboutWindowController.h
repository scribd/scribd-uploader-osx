/*!
 @brief This class provides data to and responds to events from the About
 window.
 @ingroup delegates
 */

@interface SUAboutWindowController : NSObject {
	
}

#pragma mark Properties
/** @name Program information */
//@{

/*!
 @brief Returns the current human-readable short version number of this
 application.
 */

@property (readonly) NSString *version;

//@}

#pragma mark Actions
/** @name Actions */
//@{

/*!
 @brief Opens the help window with the About page open, where the user can
 then navigate to contact, license, and version history information.
 @param sender The object that called this method (unused).
 */

- (IBAction) showAboutHelp:(id)sender;

//@}
@end
