#import "SUAddURLWindowController.h"

@interface SUAddURLWindowController (Private)

#pragma mark Background tasks

/*
 Downloads a PDF, renders the first page to an image, and sets the preview
 window to display the image.
 */

- (void) loadPDF:(id)unused;

@end

#pragma mark -

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

- (void) awakeFromNib {
	[self addObserver:self forKeyPath:@"URLString" options:NSKeyValueObservingOptionNew context:NULL];
}

- (void) observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary *)change context:(void *)context {
    if ([keyPath isEqualToString:@"URLString"]) {
		if ([[self.URLString pathExtension] isEqualToString:@"pdf"])
			[NSThread detachNewThreadSelector:@selector(loadPDF:) toTarget:self withObject:NULL];
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

@end

#pragma mark -

@implementation SUAddURLWindowController (Private)

- (void) loadPDF:(id)unused {
	NSAutoreleasePool *pool = [[NSAutoreleasePool alloc] init];
	self.downloading = YES;
	
	NSURL *URL = [[NSURL alloc] initWithString:self.URLString];
	NSData *PDFData = [[NSData alloc] initWithContentsOfURL:URL];
	[URL release];
	NSPDFImageRep *representation = [NSPDFImageRep imageRepWithData:PDFData];
	[PDFData release];
	NSImage *image = [[NSImage alloc] initWithSize:[preview bounds].size];
	[image addRepresentation:representation];
	[preview setImage:image];
	[image release];
	
	self.downloading = NO;
	[pool release];
}

@end
