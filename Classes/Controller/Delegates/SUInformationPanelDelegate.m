#import "SUInformationPanelDelegate.h"

@implementation SUInformationPanelDelegate

- (IBAction) changeCategory:(id)sender {
	[categoriesPanel makeKeyAndOrderFront:sender];
}

- (IBAction) showHelp:(id)sender {
	[[NSHelpManager sharedHelpManager] openHelpAnchor:@"adding_metadata" inBook:@"Scribd Uploader Help"];
}

@end
