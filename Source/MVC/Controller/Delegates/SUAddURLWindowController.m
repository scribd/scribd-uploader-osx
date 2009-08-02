#import "SUAddURLWindowController.h"

@implementation SUAddURLWindowController

#pragma mark Properties

@synthesize URLString;
@synthesize downloading;

#pragma mark Initializing and deallocating

/*
 Sets up value transformers.
 */

+ (void) initialize {
	[NSValueTransformer setValueTransformer:[[[SUNotEmptyValueTransformer alloc] init] autorelease] forName:@"SUNotEmpty"];
}

/*
 Sets up KVO observers and initializes fields.
 */

- (void) awakeFromNib {
	[self addObserver:self forKeyPath:@"URLString" options:NSKeyValueObservingOptionNew context:NULL];
	previewImageData = NULL;
}

/*
 Begins a new preview download if the URL is a valid PDF URL.
 */

- (void) observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary *)change context:(void *)context {
    if ([keyPath isEqualToString:@"URLString"]) {
		if ([[self.URLString pathExtension] isEqualToString:@"pdf"]) {
			self.downloading = YES;
			
			if (previewImageData) [previewImageData release];
			previewImageData = [[NSMutableData alloc] init];
			
			NSURL *URL = [[NSURL alloc] initWithString:self.URLString];
			NSURLRequest *request = [[NSURLRequest alloc] initWithURL:URL cachePolicy:NSURLRequestUseProtocolCachePolicy timeoutInterval:10.0];
			[URL release];
			[[NSURLConnection alloc] initWithRequest:request delegate:self]; // will be released in a delegate method
			[request release];
		}
		else [preview setImage:NULL];
	}
	else [super observeValueForKeyPath:keyPath ofObject:object change:change context:context];
}

#pragma mark Actions

- (IBAction) addURL:(id)sender {
	[SUDocument createFromURLString:self.URLString inManagedObjectContext:db.managedObjectContext];
	
	self.URLString = NULL;
	[window orderOut:self];
}

- (IBAction) showHelp:(id)sender {
	[[NSHelpManager sharedHelpManager] openHelpAnchor:@"add_url" inBook:@"Scribd Uploader Help"];
}

#pragma mark NSURLConnection delegate

/*
 Resets the preview data in preparation for a new download.
 */

- (void) connection:(NSURLConnection *)connection didReceiveResponse:(NSURLResponse *)response {
	[previewImageData setLength:0];
}

/*
 Appends newly received data to the preview data.
 */

- (void) connection:(NSURLConnection *)connection didReceiveData:(NSData *)data {
	[previewImageData appendData:data];
}

/*
 Aborts the preview operation, releasing local variables.
 */

- (void) connection:(NSURLConnection *)connection didFailWithError:(NSError *)error {
	[connection release];
	[previewImageData release];
	previewImageData = NULL;
	self.downloading = NO;
}

/*
 Finishes the preview operation, building a preview from the downloaded PDF data
 and setting up the NSImageView.
 */

- (void) connectionDidFinishLoading:(NSURLConnection *)connection {
	NSPDFImageRep *representation = [NSPDFImageRep imageRepWithData:previewImageData];
	
	[connection release];
	[previewImageData release];
	previewImageData = NULL;
	self.downloading = NO;
	
	NSImage *image = [[NSImage alloc] initWithSize:[preview bounds].size];
	[image addRepresentation:representation];
	[preview setImage:image];
	[image release];
}

@end
