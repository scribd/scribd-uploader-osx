/*!
 @class SUPreferencesWindowController
 @abstract Handles events for and sets up the Preferences window.
 */

@interface SUPreferencesWindowController : DBPrefsWindowController {
	IBOutlet NSView *automaticUpdatesView;
	SUUpdater *sparkleUpdater;
}

@property (retain) SUUpdater *sparkleUpdater;

/*!
 @method checkForUpdates:
 @abstract Uses the Sparkle Updater to check for updates manually.
 @param sender The object that initiated the action.
 */

- (IBAction) checkForUpdates:(id)sender;

@end
