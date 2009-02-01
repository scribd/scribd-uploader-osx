#import "SUMetadataTabValueTransformer.h"

@implementation SUMetadataTabValueTransformer

/*
 This transformer converts between different subclasses of NSObject.
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
 Transforms a string into its human-readable equivalent.
 */

- (id) transformedValue:(id)value {
	if ([value boolValue]) return @"After Upload";
	else return @"Before Upload";
}

@end
