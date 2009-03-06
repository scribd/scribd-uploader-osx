#import "SUAddURLWindowController.h"

@implementation SUAddURLWindowController

#pragma mark Properties

@synthesize URLString;

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
		if ([[self.URLString pathExtension] isEqualToString:@"pdf"]) {
			NSURL *URL = [[NSURL alloc] initWithString:self.URLString];
			NSData *PDFData = [[NSData alloc] initWithContentsOfURL:URL];
			[URL release];
			NSPDFImageRep *representation = [NSPDFImageRep imageRepWithData:PDFData];
			[PDFData release];
			NSImage *image = [[NSImage alloc] initWithSize:[preview bounds].size];
			[image addRepresentation:representation];
			[preview setImage:image];
			[image release];
			
		}
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
