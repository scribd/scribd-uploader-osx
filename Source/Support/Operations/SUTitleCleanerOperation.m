#import "SUTitleCleanerOperation.h"

@implementation SUTitleCleanerOperation

#pragma mark Properties

@synthesize document;

#pragma mark Initializing and deallocating

- (id) initWithDocument:(SUDocument *)doc {
	if (self = [super init]) {
		self.document = doc;
	}
	return self;
}

/*
 Releases fields.
 */

- (void) dealloc {
	if (document) [document release];
	[super dealloc];
}

#pragma mark NSOperation

/*
 Makes the call to Scribd and sets the document title.
 */

- (void) main {
	if (self.document.path && (!self.document.title || [self.document.title isEmpty])) {
		NSString *suggestedTitle = [[SUScribdAPI sharedAPI] titleForFilename:self.document.filename];
		if (suggestedTitle) self.document.title = suggestedTitle;
	}
}

@end
