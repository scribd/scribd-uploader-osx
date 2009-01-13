#import "SUPreferencesWindowController.h"

@implementation SUPreferencesWindowController

@synthesize sparkleUpdater;

/*
 Connects the Sparkle Updater shared instance to the local property.
 */

- (void) awakeFromNib {
	self.sparkleUpdater = [SUUpdater sharedUpdater];
}

/*
 Adds all the preference panes.
 */

- (void) setupToolbar {
	[self addView:automaticUpdatesView label:@"Automatic Updates"];
}

- (IBAction) checkForUpdates:(id)sender {
	[sparkleUpdater checkForUpdates:sender];
}

@end
