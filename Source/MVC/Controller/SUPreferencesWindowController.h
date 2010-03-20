/*!
 @brief Sets up, and responds to events from, the Preferences window.
 @ingroup controller
 */

@interface SUPreferencesWindowController : DBPrefsWindowController {
	@private
		IBOutlet NSView *automaticUpdatesView, *uploadingView, *metadataView;
		SUUpdater *sparkleUpdater;
}

#pragma mark Properties

/*!
 @brief The Sparkle @c SUUpdater instance that will perform the update check.
 @details This property is automatically assigned upon awakening from the xib
 file.
 */

@property (retain) SUUpdater *sparkleUpdater;

#pragma mark Actions
/** @name Actions */
//@{

/*!
 @brief Uses the Sparkle Updater to check for updates manually.
 @param sender The object that initiated the action (unused).
 */

- (IBAction) checkForUpdates:(id)sender;

/*!
 @brief Displays a help page relevant to the selected tab.
 @param sender The object that initiated the action (unused).
 */

- (IBAction) showHelp:(id)sender;

//@}
@end
