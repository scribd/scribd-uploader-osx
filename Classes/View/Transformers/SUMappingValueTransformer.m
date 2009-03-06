#import "SUMappingValueTransformer.h"

@implementation SUMappingValueTransformer

#pragma mark Properties

@synthesize mappings;

#pragma mark Initializing and deallocating

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
	if (!value) value = [NSNull null];
	id result = [mappings objectForKey:value];
	if ([result isEqualTo:[NSNull null]]) return NULL;
	else return result;
}

@end
