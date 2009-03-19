#import "SUFileListDelegate.h"

@implementation SUFileListDelegate

#pragma mark Initialization and deallocation

/*
 Creates value transformers for the image and alternate image.
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

#pragma mark Delegate methods

/*
 Prepares a status column cell by binding its image and alternateImage to the
 document.errorLevel property. Does nothing for other columns' cells.
 */

- (void) tableView:(NSTableView *)tableView willDisplayCell:(id)cell forTableColumn:(NSTableColumn *)column row:(NSInteger)row {
	if ([[column identifier] isNotEqualTo:@"status"]) return;
	
	SUDocument *document = [[documents arrangedObjects] objectAtIndex:row];
	
	NSDictionary *options = [[NSDictionary alloc] initWithObject:@"SUFileStatusButtonImage" forKey:NSValueTransformerNameBindingOption];
	[cell bind:@"image" toObject:document withKeyPath:@"errorLevel" options:options];
	[options release];
	
	options = [[NSDictionary alloc] initWithObject:@"SUFileStatusButtonAlternateImage" forKey:NSValueTransformerNameBindingOption];
	[cell bind:@"alternateImage" toObject:document withKeyPath:@"errorLevel" options:options];
	[options release];
}

@end
