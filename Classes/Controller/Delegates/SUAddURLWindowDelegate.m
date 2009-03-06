#import "SUAddURLWindowDelegate.h"

@implementation SUAddURLWindowDelegate

#pragma mark Properties

@synthesize URLString;

#pragma mark Initialization and deallocation

/*
 Sets up value transformers.
 */

+ (void) initialize {
	[NSValueTransformer setValueTransformer:[[[SUNotEmptyValueTransformer alloc] init] autorelease] forName:@"SUNotEmpty"];
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
