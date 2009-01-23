#import "SUAboutWindowDelegate.h"

@implementation SUAboutWindowDelegate

@dynamic version;

- (IBAction) showAboutHelp:(id)sender {
	[[NSHelpManager sharedHelpManager] openHelpAnchor:@"about" inBook:@"Scribd Uploader Help"];
}

- (NSString *) version {
	return [[[NSBundle mainBundle] infoDictionary] objectForKey:@"CFBundleShortVersionString"];
}

@end
