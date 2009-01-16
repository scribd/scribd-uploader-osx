#import "SUSingleSelectionOnlyValueTransformer.h"

@implementation SUSingleSelectionOnlyValueTransformer

/*
 This transformer converts between numeric values.
 */

+ (Class) transformedValueClass {
	return [NSNumber class];
}

/*
 This is a one-way value transformer.
 */

+ (BOOL) allowsReverseTransformation {
	return NO;
}

/*
 Given a number, returns YES if it is equal to 1, or NO otherwise.
 */

- (id) transformedValue:(id)value {
	if ([value integerValue] == 1) return [NSNumber numberWithBool:YES];
	else return [NSNumber numberWithBool:NO];
}

@end
