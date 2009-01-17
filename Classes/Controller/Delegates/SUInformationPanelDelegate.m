#import "SUInformationPanelDelegate.h"

@implementation SUInformationPanelDelegate

- (void) awakeFromNib {
	[tagsField setTokenizingCharacterSet:[NSCharacterSet characterSetWithCharactersInString:@" \n\r,;|-"]];
}

- (IBAction) changeCategory:(id)sender {
	[categoriesPanel makeKeyAndOrderFront:sender];
}

- (IBAction) showHelp:(id)sender {
	[[NSHelpManager sharedHelpManager] openHelpAnchor:@"adding_metadata" inBook:@"Scribd Uploader Help"];
}

- (NSArray *) tokenField:(NSTokenField *)tokenField completionsForSubstring:(NSString *)substring indexOfToken:(NSInteger)tokenIndex indexOfSelectedItem:(NSInteger *)selectedIndex {
	return [[SUScribdAPI sharedAPI] autocompletionsForSubstring:substring];
}

@end
