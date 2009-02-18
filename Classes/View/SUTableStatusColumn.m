#import "SUTableStatusColumn.h"

@implementation SUTableStatusColumn

#pragma mark Initializing and deallocating

/*
 Registers value transformers.
 */

+ (void) initialize {
	NSImage *successImage = [[NSImage alloc] initByReferencingFile:[[NSBundle mainBundle] pathForResource:@"Go" ofType:@"png"]];
	NSImage *cautionImage = [[NSImage alloc] initByReferencingFile:[[NSBundle mainBundle] pathForResource:@"Caution" ofType:@"png"]];
	NSImage *errorImage = [[NSImage alloc] initByReferencingFile:[[NSBundle mainBundle] pathForResource:@"Error" ofType:@"png"]];
	NSDictionary *imageMappings = [[NSDictionary alloc] initWithObjectsAndKeys:
								   successImage, @"Success",
								   cautionImage, @"Caution",
								   errorImage, @"Error",
								   NULL];
	[successImage release];
	[cautionImage release];
	[errorImage release];
	[NSValueTransformer setValueTransformer:[[[SUMappingValueTransformer alloc] initWithDictionary:imageMappings] autorelease] forName:@"SUFileStatusButtonImage"];
	[imageMappings release];
	
	successImage = [[NSImage alloc] initByReferencingFile:[[NSBundle mainBundle] pathForResource:@"Go Clicked" ofType:@"png"]];
	cautionImage = [[NSImage alloc] initByReferencingFile:[[NSBundle mainBundle] pathForResource:@"Caution Clicked" ofType:@"png"]];
	errorImage = [[NSImage alloc] initByReferencingFile:[[NSBundle mainBundle] pathForResource:@"Error Clicked" ofType:@"png"]];
	imageMappings = [[NSDictionary alloc] initWithObjectsAndKeys:
					 successImage, @"Success",
					 cautionImage, @"Caution",
					 errorImage, @"Error",
					 NULL];
	[successImage release];
	[cautionImage release];
	[errorImage release];
	[NSValueTransformer setValueTransformer:[[[SUMappingValueTransformer alloc] initWithDictionary:imageMappings] autorelease] forName:@"SUFileStatusButtonAlternateImage"];
	[imageMappings release];
}

/*
 Registers this instance as an observer of the data source's status attribute.
 */

- (void) awakeFromNib {
	[[[self tableView] dataSource] addObserver:self forKeyPath:@"arrangedObjects.errorLevel" options:NSKeyValueObservingOptionNew context:NULL];
}

#pragma mark KVO

/*
 Refreshes the icons of the buttons based on the new file statuses.
 */

- (void) observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary *)change context:(void *)context {
	if ([keyPath isEqualToString:@"arrangedObjects.errorLevel"]) {
		NSArray *levels = [object valueForKeyPath:keyPath];
		NSValueTransformer *buttonImageTransformer = [NSValueTransformer valueTransformerForName:@"SUFileStatusButtonImage"];
		NSValueTransformer *buttonAlternateImageTransformer = [NSValueTransformer valueTransformerForName:@"SUFileStatusButtonAlternateImage"];
		NSInteger row;
		for (row = 0; row != [levels count]; row++) {
			[(NSButtonCell *)([self dataCellForRow:row]) setImage:[buttonImageTransformer transformedValue:[levels objectAtIndex:row]]];
			[(NSButtonCell *)([self dataCellForRow:row]) setAlternateImage:[buttonAlternateImageTransformer transformedValue:[levels objectAtIndex:row]]];
		}
	}
	else [super observeValueForKeyPath:keyPath ofObject:object change:change context:context];
}

@end
