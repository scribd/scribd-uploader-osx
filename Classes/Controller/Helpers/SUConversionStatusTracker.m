#import "SUConversionStatusTracker.h"

@implementation SUConversionStatusTracker

#pragma mark Properties

@synthesize document;

#pragma mark Initializing and deallocating

- (id) initWithDocument:(SUDocument *)doc {
	if (self = [super init]) {
		self.document = doc;
		timer = [NSTimer timerWithTimeInterval:2.0 target:self selector:@selector(update:) userInfo:NULL repeats:YES];
		[[NSRunLoop currentRunLoop] addTimer:timer forMode:NSDefaultRunLoopMode];
	}
	return self;
}

/*
 Releases local memory usage.
 */

- (void) dealloc {
	if (document) [document release];
	[super dealloc];
}

#pragma mark Periodic updates

/*
 Called regularly, begins an asynchronous API request for the conversion status.
 */

- (void) update:(NSTimer *)sendingTimer {
	NSDictionary *parameters = [[NSDictionary alloc] initWithObjectsAndKeys:
								document.scribdID, @"doc_id",
								[SUSessionHelper sessionHelper].key, @"session_key",
								NULL];
	[[SUScribdAPI sharedAPI] asynchronouslyCallAPIMethod:@"docs.getConversionStatus" parameters:parameters delegate:self];
	//TODO throttle these requests if there are a lot of instances
	[parameters release];
}

#pragma mark ASIHTTPRequest delegate methods

/*
 Parses the server's response and updates the document's attributes as
 appropriate. Kills the timer if conversion is complete.
 */

- (void) requestFinished:(ASIHTTPRequest *)request {
	document.conversionComplete = [NSNumber numberWithBool:YES];
	NSError *error = NULL;
	NSXMLDocument *xml = [[NSXMLDocument alloc] initWithXMLString:[request responseString] options:0 error:&error];
	if (xml) {
		NSDictionary *response = [[SUScribdAPI sharedAPI] parseXML:xml error:&error];
		//TODO shouldn't use a private method here
		if (response) {
			NSString *status = [response objectForKey:@"conversion_status"];
			if (!status) return;
			if ([status isEqualToString:@"PROCESSING"]) document.converting = [NSNumber numberWithBool:YES];
			else {
				document.converting = [NSNumber numberWithBool:NO];
				[timer invalidate];
			}
		}
	}
}

@end
