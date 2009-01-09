#import "SUFileStatusButtonImageValueTransformer.h"

@implementation SUFileStatusButtonImageValueTransformer

/*
 Loads the icon images.
 */

- (id) init {
	if (self = [super init]) {
		successImage = [[NSImage alloc] initByReferencingFile:[[NSBundle mainBundle] pathForResource:@"success" ofType:@"tif"]];
		errorImage = [[NSImage alloc] initByReferencingFile:[[NSBundle mainBundle] pathForResource:@"error" ofType:@"tif"]];
	}
	return self;
}

/*
 Releases retained objects.
 */

- (void) dealloc {
	[successImage release];
	[errorImage release];
	[super dealloc];
}

/*
 This transformer transforms between a variety of NSObject subclasses.
 */

+ (Class) transformedValueClass {
	return [NSObject class];
}

/*
 This is a one-way transformer.
 */

+ (BOOL) allowsReverseTransformation {
	return NO;
}

/*
 Transforms an error or success indicator into the front-end visual indication.
 */

- (id) transformedValue:(id)value {
	if (!value) return NULL;
	if ([value isEqual:[NSNumber numberWithBool:YES]]) return successImage;
	if ([value isEqual:[NSNumber numberWithBool:NO]]) return errorImage;
	else return NULL;
}

@end
