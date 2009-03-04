#import "SUPublisherPanelDelegate.h"

@implementation SUPublisherPanelDelegate

#pragma mark Initialization and deallocation

/*
 Configures value transformers.
 */

+ (void) initialize {
	NSDictionary *licenses = [[NSDictionary alloc] initWithObjectsAndKeys:
							  NSLocalizedString(@"Attribution", @"copyright license"), @"by",
							  NSLocalizedString(@"Attribution (non-commercial)", @"copyright license"), @"by-nc",
							  NSLocalizedString(@"Attribution (non-commercial, no derivatives)", @"copyright license"), @"by-nc-nd",
							  NSLocalizedString(@"Attribution (non-commercial, share alike)", @"copyright license"), @"by-nc-sa",
							  NSLocalizedString(@"Attribution (no derivatives)", @"copyright license"), @"by-nd",
							  NSLocalizedString(@"Attribution (share alike)", @"copyright license"), @"by-sa",
							  NSLocalizedString(@"Traditional copyright — all rights reserved", @"copyright license"), @"c",
							  NSLocalizedString(@"Public Domain", @"copyright license"), @"pd",
							  NSLocalizedString(@"Not specified", @"copyright license"), [NSNull null],
							  NULL];
	SUReversibleMappingValueTransformer *licensesTransformer = [[SUReversibleMappingValueTransformer alloc] initWithDictionary:licenses];
	[licenses release];
	[NSValueTransformer setValueTransformer:[licensesTransformer autorelease] forName:@"SULicense"];
}

#pragma mark Actions

- (IBAction) showHelp:(id)sender {
	[[NSHelpManager sharedHelpManager] openHelpAnchor:@"adding_publisher_metadata" inBook:@"Scribd Uploader Help"];
}

- (IBAction) toggleMenuItem:(id)sender {
	if ([panel isVisible]) {
		[panel orderOut:self];
		[togglePanelItem setTitle:NSLocalizedString(@"Show Publisher Panel", NULL)];
	}
	else {
		[panel makeKeyAndOrderFront:self];
		[togglePanelItem setTitle:NSLocalizedString(@"Hide Publisher Panel", NULL)];
	}
}

- (IBAction) setToday:(id)sender {
	[documents setValue:[NSDate date] forKeyPath:@"selection.datePublished"];
}

@end
