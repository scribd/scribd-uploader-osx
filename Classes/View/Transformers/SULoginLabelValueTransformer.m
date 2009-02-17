#import "SULoginLabelValueTransformer.h"

@implementation SULoginLabelValueTransformer

#pragma mark Value transformer

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
	if (value) return [NSString stringWithFormat:NSLocalizedString(@"Logged in as %@.", NULL), value];
	else return NSLocalizedString(@"Not logged in.", NULL);
}

@end
