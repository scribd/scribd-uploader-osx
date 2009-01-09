#import "SUPrivateDescriptionValueTransformer.h"

@implementation SUPrivateDescriptionValueTransformer

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
		return @"These documents will only be visible to you or people you choose.";
	else return @"These documents will be visible to everyone once they are uploaded.";
}

@end
