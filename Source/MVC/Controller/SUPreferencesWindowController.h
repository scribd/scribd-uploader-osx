/*!
 @class SUPreferencesWindowController
 @abstract Sets up and responds to events from the Preferences window.
 */

@interface SUPreferencesWindowController : DBPrefsWindowController {
	@private
		IBOutlet NSView *automaticUpdatesView, *uploadingView, *metadataView;
		SUUpdater *sparkleUpdater;
}

#pragma mark Properties

/*!
 @property sparkleUpdater
 @abstract The Sparkle SUUpdater instance that will perform the update check.
 @discussion This property is automatically assigned upon awakening from the xib
 file.
 */

@property (retain) SUUpdater *sparkleUpdater;

#pragma mark Actions

/*!
 @method checkForUpdates:
 @abstract Uses the Sparkle Updater to check for updates manually.
 @param sender The object that initiated the action.
 */

- (IBAction) checkForUpdates:(id)sender;

/*!
 @method showHelp:
 @abstract Displays a help page relevant to the selected tab.
 @param sender The object that initiated the action.
 */

- (IBAction) showHelp:(id)sender;

@end
