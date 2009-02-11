/*!
 @class SUPreferencesWindowController
 @abstract Handles events for and sets up the Preferences window.
 */

@interface SUPreferencesWindowController : DBPrefsWindowController {
	IBOutlet NSView *automaticUpdatesView, *uploadingView, *metadataView;
	SUUpdater *sparkleUpdater;
}

#pragma mark Properties

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
