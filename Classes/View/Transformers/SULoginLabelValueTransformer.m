#import "SULoginLabelValueTransformer.h"

@implementation SULoginLabelValueTransformer

/*
 This transformer converts between usernames (strings) and NSLabel values
 (strings).
 */

+ (Class) transformedValueClass {
	return [NSString class];
}

/*
 This is a one-way value transformer.
 */

+ (BOOL) allowsReverseTransformation {
	return NO;
}

/*
 Given a username (or NULL if not logged in), converts it into a descriptive
 label.
 */

- (id) transformedValue:(id)value {
	if (value) return [NSString stringWithFormat:@"Logged in as %@.", value];
	else return @"Not logged in.";
}

@end
