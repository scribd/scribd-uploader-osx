#import "SUNotEmptyValueTransformer.h"

@implementation SUNotEmptyValueTransformer

#pragma mark Value transformer

/*
 This transformer converts between different subclasses of NSObject.
 */

+ (Class) transformedValueClass {
	return [NSObject class];
}

/*
 This is a one-directional transformer.
 */

+ (BOOL) allowsReverseTransformation {
	return NO;
}

/*
 Returns either YES or NO depending on if the string has content.
 */

- (id) transformedValue:(id)value {
	if (!value) return [NSNumber numberWithBool:NO];
	if ([(NSString *)value isBlank]) return [NSNumber numberWithBool:NO];
	else return [NSNumber numberWithBool:YES];
}

@end
