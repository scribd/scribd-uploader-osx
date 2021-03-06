#import "SUPreferencesWindowController.h"

@interface SUPreferencesWindowController (Private)

#pragma mark Helpers

- (NSView *) activeView;

@end

#pragma mark -

@implementation SUPreferencesWindowController

#pragma mark Properties

@synthesize sparkleUpdater;

#pragma mark Initializing and deallocating

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
	NSImage *image = [[NSImage alloc] initByReferencingFile:[[NSBundle mainBundle] pathForResource:@"Upload" ofType:@"png"]];
	[self addView:uploadingView label:NSLocalizedString(@"Uploading", @"preference pane") image:image];
	[image release];
	
	[self addView:metadataView label:NSLocalizedString(@"Metadata", @"preference pane") image:[NSImage imageNamed:@"NSInfo"]];
	
	[self addView:automaticUpdatesView label:NSLocalizedString(@"Automatic Updates", @"preference pane")];
}

#pragma mark Actions

- (IBAction) checkForUpdates:(id)sender {
	[sparkleUpdater checkForUpdates:sender];
}

- (IBAction) showHelp:(id)sender {
	NSString *anchor = NULL;
	if ([[self activeView] isEqualTo:automaticUpdatesView]) anchor = @"automatic_updates";
	if ([[self activeView] isEqualTo:uploadingView]) anchor = @"uploading_preferences";
	if ([[self activeView] isEqualTo:metadataView]) anchor = @"metadata_preferences";
	if (anchor) [[NSHelpManager sharedHelpManager] openHelpAnchor:anchor inBook:@"Scribd Uploader Help"];
}

@end

#pragma mark -

@implementation SUPreferencesWindowController (Private)

#pragma mark Helpers

- (NSView *) activeView {
	return [[self window] initialFirstResponder];
}

@end
