#import "SUDiscoverabilityDescriptionValueTransformer.h"

@implementation SUDiscoverabilityDescriptionValueTransformer

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
 Transforms a boolean into a human-readable string.
 */

- (id) transformedValue:(id)value {
	if ([value isEqualTo:[NSNumber numberWithBool:true]])
		return @"Your document is private, so no one will be able to discover it.";
	else return @"To make your document more discoverable, add more information above.";
}

@end
