#import "SUAboutWindowDelegate.h"

@implementation SUAboutWindowDelegate

#pragma mark Properties

@dynamic version;

#pragma mark Actions

- (IBAction) showAboutHelp:(id)sender {
	[[NSHelpManager sharedHelpManager] openHelpAnchor:@"about" inBook:@"Scribd Uploader Help"];
}

#pragma mark Dynamic properties

- (NSString *) version {
	return [[[NSBundle mainBundle] infoDictionary] objectForKey:@"CFBundleShortVersionString"];
}

@end
