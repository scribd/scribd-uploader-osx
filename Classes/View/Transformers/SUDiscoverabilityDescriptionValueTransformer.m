#import "SUDiscoverabilityDescriptionValueTransformer.h"

@implementation SUDiscoverabilityDescriptionValueTransformer

#pragma mark Value transformer

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
		return NSLocalizedString(@"Your document is private, so no one will be able to discover it.", NULL);
	else return NSLocalizedString(@"To make your document more discoverable, add more information above.", NULL);
}

@end
