#import "SUPreferencesWindowController.h"

@interface SUPreferencesWindowController (Private)

- (NSView *) activeView;

@end

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

- (IBAction) showHelp:(id)sender {
	NSString *anchor;
	if ([[self activeView] isEqualTo:automaticUpdatesView]) anchor = @"automatic_updates";
	[[NSHelpManager sharedHelpManager] openHelpAnchor:anchor inBook:@"Scribd Uploader Help"];
}

@end

@implementation SUPreferencesWindowController (Private)

- (NSView *) activeView {
	return [[self window] initialFirstResponder];
}

@end
