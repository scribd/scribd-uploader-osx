#import "SUAboutWindowDelegate.h"

@implementation SUAboutWindowDelegate

- (IBAction) showAboutHelp:(id)sender {
	[[NSHelpManager sharedHelpManager] openHelpAnchor:@"about" inBook:@"Scribd Uploader Help"];
}

@end
