#import "SUBusyActionValueTransformer.h"

@implementation SUBusyActionValueTransformer

/*
 This transformer converts between strings.
 */

+ (Class) transformedValueClass {
	return [NSString class];
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
	if ([value isEqual:@"login"]) return @"Logging in…";
	else if ([value isEqual:@"signup"]) return @"Signing up…";
	else return value;
}

@end
