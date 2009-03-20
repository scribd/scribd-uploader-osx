#import "SUConversionStatusTracker.h"

@implementation SUConversionStatusTracker

@synthesize document;

- (id) initWithDocument:(SUDocument *)doc {
	if (self = [super init]) {
		self.document = doc;
		NSTimer *timer = [NSTimer timerWithTimeInterval:2.0 target:self selector:@selector(update:) userInfo:NULL repeats:YES];
		[[NSRunLoop currentRunLoop] addTimer:timer forMode:NSDefaultRunLoopMode];
	}
	return self;
}

- (void) dealloc {
	if (document) [document release];
	[super dealloc];
}

- (void) update:(NSTimer *)timer {
	NSError *error = NULL;
	NSDictionary *parameters = [[NSDictionary alloc] initWithObjectsAndKeys:
								document.scribdID, @"doc_id",
								[SUSessionHelper sessionHelper].key, @"session_key",
								NULL];
	NSDictionary *result = [[SUScribdAPI sharedAPI] callAPIMethod:@"docs.getConversionStatus" parameters:parameters error:&error];
	[parameters release];
	NSString *status = [result objectForKey:@"conversion_status"];
	if (error || !status) return;
	
	if ([status isEqualToString:@"PROCESSING"]) document.converting = [NSNumber numberWithBool:YES];
	else {
		document.converting = [NSNumber numberWithBool:NO];
		[timer invalidate];
	}
}

@end
