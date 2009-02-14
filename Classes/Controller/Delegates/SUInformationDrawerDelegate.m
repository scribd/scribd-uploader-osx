#import "SUInformationDrawerDelegate.h"

@implementation SUInformationDrawerDelegate

#pragma mark Initializing and deallocating

/*
 Configures the tags field and configures KVO.
 */

- (void) awakeFromNib {
	[tagsField setTokenizingCharacterSet:[NSCharacterSet characterSetWithCharactersInString:@" \n\r,;|-"]];
	[documentsController addObserver:self forKeyPath:@"selection.@count" options:0 context:NULL];
}

#pragma mark KVO

/*
 Called when the file list selection changes; shows or hides the information
 drawer if the preference is set to auto and the selection is not empty.
 */

- (void) observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary *)change context:(void *)context {
	if ([keyPath isEqualToString:@"selection.@count"]) {
		if ([[NSUserDefaults standardUserDefaults] boolForKey:SUDefaultKeyManualMetadataDrawer]) return;
		if ([[documentsController selectedObjects] count] == 0) {
			[drawer close:self];
			[toggleDrawerItem setTitle:@"Show Information Drawer"];
		}
		else {
			[drawer open:self];
			[toggleDrawerItem setTitle:@"Hide Information Drawer"];
		}
	}
	else [super observeValueForKeyPath:keyPath ofObject:object change:change context:context];
}

#pragma mark Actions

- (IBAction) showHelp:(id)sender {
	[[NSHelpManager sharedHelpManager] openHelpAnchor:@"adding_metadata" inBook:@"Scribd Uploader Help"];
}

- (IBAction) toggleMenuItem:(id)sender {
	[[NSUserDefaults standardUserDefaults] setBool:true forKey:SUDefaultKeyManualMetadataDrawer];
	if ([drawer state] == NSDrawerOpenState || [drawer state] == NSDrawerOpeningState) {
		[drawer close:self];
		[toggleDrawerItem setTitle:@"Show Information Drawer"];
	}
	else {
		[drawer open:self];
		[toggleDrawerItem setTitle:@"Hide Information Drawer"];
	}
}

#pragma mark Delegate responders

/*
 Provides the token field with a list of autocompletions given by Scribd.com
 */

- (NSArray *) tokenField:(NSTokenField *)tokenField completionsForSubstring:(NSString *)substring indexOfToken:(NSInteger)tokenIndex indexOfSelectedItem:(NSInteger *)selectedIndex {
	return [[SUScribdAPI sharedAPI] autocompletionsForSubstring:substring];
}

/*
 Fades between the pre-uploaded and post-uploaded metadata view.
 */

- (void) tabView:(NSTabView *)tabView willSelectTabViewItem:(NSTabViewItem *)tabViewItem {
	NSDictionary *fadeOut = [[NSDictionary alloc] initWithObjectsAndKeys:
							 [[tabView selectedTabViewItem] view], NSViewAnimationTargetKey,
							 NSViewAnimationFadeOutEffect, NSViewAnimationEffectKey,
							 NULL];
	NSDictionary *fadeIn = [[NSDictionary alloc] initWithObjectsAndKeys:
							[tabViewItem view], NSViewAnimationTargetKey,
							NSViewAnimationFadeInEffect, NSViewAnimationEffectKey,
							NULL];
	
	NSArray *effects = [[NSArray alloc] initWithObjects:fadeOut, fadeIn, NULL];
	[fadeOut release];
	[fadeIn release];
	
	NSViewAnimation *viewAnimation = [[NSViewAnimation alloc] initWithViewAnimations:effects];
	[effects release];
	[viewAnimation setDuration:0.25];
	
	[viewAnimation startAnimation]; //TODO the tab content isn't updated until after it's animated
	
	[viewAnimation release];
}

@end
