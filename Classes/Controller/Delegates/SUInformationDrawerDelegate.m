#import "SUInformationDrawerDelegate.h"

@implementation SUInformationDrawerDelegate

- (void) awakeFromNib {
	[tagsField setTokenizingCharacterSet:[NSCharacterSet characterSetWithCharactersInString:@" \n\r,;|-"]];
	[documentsController addObserver:self forKeyPath:@"selection.@count" options:0 context:NULL];
}

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


- (IBAction) showHelp:(id)sender {
	[[NSHelpManager sharedHelpManager] openHelpAnchor:@"adding_metadata" inBook:@"Scribd Uploader Help"];
}

- (NSArray *) tokenField:(NSTokenField *)tokenField completionsForSubstring:(NSString *)substring indexOfToken:(NSInteger)tokenIndex indexOfSelectedItem:(NSInteger *)selectedIndex {
	return [[SUScribdAPI sharedAPI] autocompletionsForSubstring:substring];
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

@end
