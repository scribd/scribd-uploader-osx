#import "SUMappingValueTransformer.h"

@implementation SUMappingValueTransformer

#pragma mark Properties

@synthesize mappings;

#pragma mark Initialization and deallocation

- (id) initWithDictionary:(NSDictionary *)dictionary {
	if (self = [super init]) {
		mappings = [dictionary retain];
	}
	return self;
}

/*
 Releases local memory usage.
 */

- (void) dealloc {
	if (mappings) [mappings release];
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
 Returns the value for a dictionary key.
 */

- (id) transformedValue:(id)value {
	return [mappings objectForKey:value];
}

@end
