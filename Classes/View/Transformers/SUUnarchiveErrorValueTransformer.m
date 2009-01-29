#import "SUUnarchiveErrorValueTransformer.h"

@implementation SUUnarchiveErrorValueTransformer

/*
 This class converts between different subclasses of NSObject.
 */

+ (Class) transformedValueClass {
	return [NSObject class];
}

/*
 This is a two-way transformer.
 */

+ (BOOL) allowsReverseTransformation {
	return YES;
}

/*
 Transforms an archived NSError into an Objective-C object. Also transforms
 arrays of NSDatas into arrays of NSErrors.
 */

- (id) transformedValue:(id)value {
	if ([value isKindOfClass:[NSData class]])
		return [NSUnarchiver unarchiveObjectWithData:value];
	else if ([value isKindOfClass:[NSArray class]]) {
		NSMutableArray *outArray = [NSMutableArray arrayWithCapacity:[(NSArray *)value count]];
		for (NSData *data in (NSArray *)value) {
			if (data && [data isNotEqualTo:[NSNull null]]) {
				id item = [NSUnarchiver unarchiveObjectWithData:data];
				[outArray addObject:item];
			} else {
				[outArray addObject:[NSNull null]];
			}
		}
		return outArray;
	}
	else return value;
}

/*
 Serializes an NSError into an NSData. Also works with arrays of NSErrors.
 */

- (id) reverseTransformedValue:(id)value {
	if ([value isKindOfClass:[NSError class]])
		return [NSArchiver archivedDataWithRootObject:value];
	else if ([value isKindOfClass:[NSArray class]]) {
		NSMutableArray *outArray = [NSMutableArray arrayWithCapacity:[(NSArray *)value count]];
		for (id item in (NSArray *)value) {
			NSData *data = [NSArchiver archivedDataWithRootObject:item];
			[outArray addObject:data];
		}
		return outArray;
	}
	else return value;
}

@end
