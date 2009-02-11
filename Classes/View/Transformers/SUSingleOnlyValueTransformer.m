#import "SUSingleOnlyValueTransformer.h"

@implementation SUSingleOnlyValueTransformer

#pragma mark Value transformer

/*
 This transformer converts between NSNumbers.
 */

+ (Class) transformedValueClass {
	return [NSNumber class];
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
	if ([value integerValue] == 1) return [NSNumber numberWithBool:YES];
	else return NO;
}

@end
