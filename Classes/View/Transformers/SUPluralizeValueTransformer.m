#import "SUPluralizeValueTransformer.h"

@implementation SUPluralizeValueTransformer

- (id) initWithSingular:(NSString *)sing plural:(NSString *)plu {
	if (self = [super init]) {
		singular = [sing retain];
		plural = [plu retain];
	}
	return self;
}

/*
 Releases instance fields.
 */

- (void) dealloc {
	[singular release];
	[plural release];
	[super dealloc];
}

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
 Transforms a string into its human-readable equivalent.
 */

- (id) transformedValue:(id)value {
	if ([value integerValue] == 1) return singular;
	else return plural;
}

@end
