#import "SUPrivateDescriptionValueTransformer.h"

@implementation SUPrivateDescriptionValueTransformer

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
		return NSLocalizedString(@"This document will only be visible to you or people you choose.", NULL);
	else return NSLocalizedString(@"This document will be visible to everyone once it is uploaded.", NULL);
}

@end
