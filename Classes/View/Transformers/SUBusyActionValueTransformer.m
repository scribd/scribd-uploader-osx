#import "SUBusyActionValueTransformer.h"

@implementation SUBusyActionValueTransformer

#pragma mark Value transformer

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
	if ([value isEqual:@"login"]) return NSLocalizedString(@"Logging in…", NULL);
	else if ([value isEqual:@"signup"]) return NSLocalizedString(@"Signing up…", NULL);
	else return value;
}

@end
