#import "SUFileStatusColorValueTransformer.h"

@implementation SUFileStatusColorValueTransformer

#pragma mark Value transformer

/*
 Creates the NSColor instances.
 */

- (id) init {
	if (self = [super init]) {
		successColor = [NSColor blackColor]; //TODO is there some reason (0.0, 0.5, 0.0) doesn't work??
		errorColor = [NSColor redColor];
		otherColor = [NSColor blackColor];
	}
	return self;
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
	if (!value) return otherColor;
	if ([value isEqual:[NSNumber numberWithBool:YES]]) return successColor;
	else if ([value isKindOfClass:[NSError class]]) return errorColor;
	else return otherColor;
}

@end
