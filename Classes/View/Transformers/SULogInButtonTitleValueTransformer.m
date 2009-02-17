#import "SULogInButtonTitleValueTransformer.h"

@implementation SULogInButtonTitleValueTransformer

#pragma mark Value transformer

/*
 This transformer converts between session keys (strings) and button titles
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
 Given a session key, transforms it into a title for the Log In/Log Out button.
 */

- (id) transformedValue:(id)value {
	return value ? NSLocalizedString(@"Switch Users", @"command") : NSLocalizedString(@"Log In", @"command");
}

@end
