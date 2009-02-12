#import "SUFileStatusButtonImageValueTransformer.h"

@implementation SUFileStatusButtonImageValueTransformer

#pragma mark Initializing and deallocating

- (id) init {
	return [self initWithSuffix:NULL];
}

- (id) initWithSuffix:(NSString *)suffix {
	if (self = [super init]) {
		if (suffix) {
			NSString *successString = [[NSString alloc] initWithFormat:@"Go %@", suffix];
			NSString *cautionString = [[NSString alloc] initWithFormat:@"Caution %@", suffix];
			NSString *errorString = [[NSString alloc] initWithFormat:@"Error %@", suffix];
			successImage = [[NSImage alloc] initByReferencingFile:[[NSBundle mainBundle] pathForResource:successString ofType:@"png"]];
			cautionImage = [[NSImage alloc] initByReferencingFile:[[NSBundle mainBundle] pathForResource:cautionString ofType:@"png"]];
			errorImage = [[NSImage alloc] initByReferencingFile:[[NSBundle mainBundle] pathForResource:errorString ofType:@"png"]];
			[successString release];
			[cautionString release];
			[errorString release];
		} else {
			successImage = [[NSImage alloc] initByReferencingFile:[[NSBundle mainBundle] pathForResource:@"Go" ofType:@"png"]];
			cautionImage = [[NSImage alloc] initByReferencingFile:[[NSBundle mainBundle] pathForResource:@"Caution" ofType:@"png"]];
			errorImage = [[NSImage alloc] initByReferencingFile:[[NSBundle mainBundle] pathForResource:@"Error" ofType:@"png"]];
		}
	}
	return self;
}

/*
 Releases retained objects.
 */

- (void) dealloc {
	[successImage release];
	[cautionImage release];
	[errorImage release];
	[super dealloc];
}

#pragma mark Value transformer

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
 Transforms an error level indicator into the front-end visual indication.
 */

- (id) transformedValue:(id)value {
	if ([value isEqualToString:@"Success"]) return successImage;
	else if ([value isEqualToString:@"Caution"]) return cautionImage;
	else if ([value isEqualToString:@"Error"]) return errorImage;
	else return NULL;
}

@end
