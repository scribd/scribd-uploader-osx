#import "SUToggleValueTransformer.h"

@implementation SUToggleValueTransformer

#pragma mark Properties

@synthesize trueValue;
@synthesize falseValue;

#pragma mark Initializing and deallocating

- (id) initWithTrueValue:(NSObject *)whenTrue falseValue:(NSObject *)whenFalse {
	if (self = [super init]) {
		trueValue = [whenTrue retain];
		falseValue = [whenFalse retain];
	}
	return self;
}

/*
 Releases local memory usage.
 */

- (void) dealloc {
	if (trueValue) [trueValue release];
	if (falseValue) [falseValue release];
	[super dealloc];
}

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
 Returns either trueValue or falseValue depending on the incoming value.
 */

- (id) transformedValue:(id)value {
	if (value && [value isNotEqualTo:[NSNull null]] && [value isNotEqualTo:[NSNumber numberWithBool:NO]]) return trueValue;
	else return falseValue;
}

@end
