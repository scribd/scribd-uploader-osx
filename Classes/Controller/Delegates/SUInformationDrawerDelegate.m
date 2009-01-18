#import "SUInformationDrawerDelegate.h"

@implementation SUInformationDrawerDelegate

- (void) awakeFromNib {
	[tagsField setTokenizingCharacterSet:[NSCharacterSet characterSetWithCharactersInString:@" \n\r,;|-"]];
}

- (IBAction) showHelp:(id)sender {
	[[NSHelpManager sharedHelpManager] openHelpAnchor:@"adding_metadata" inBook:@"Scribd Uploader Help"];
}

- (NSArray *) tokenField:(NSTokenField *)tokenField completionsForSubstring:(NSString *)substring indexOfToken:(NSInteger)tokenIndex indexOfSelectedItem:(NSInteger *)selectedIndex {
	return [[SUScribdAPI sharedAPI] autocompletionsForSubstring:substring];
}

- (IBAction) toggleMenuItem:(id)sender {
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
