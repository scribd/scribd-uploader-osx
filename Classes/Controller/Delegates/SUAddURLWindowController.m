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
