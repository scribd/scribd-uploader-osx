#import "SUDocument+QuickLook.h"

@implementation SUDocument (QuickLook)

#pragma mark Quick Look preview item

/*
 We use the URL to the file as our Quick Look preview item.
 */

- (NSURL *) previewItemURL {
	return self.URL;
}

/*
 The title of the document is the title of the Quick Look window.
 */

- (NSString *) previewItemTitle {
	return self.title;
}

@end
