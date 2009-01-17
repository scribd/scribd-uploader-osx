#import "NSArray_SUAdditions.h"

@implementation NSArray (SUAdditions)

- (NSArray *) reversedArray {
	NSMutableArray *array = [[NSMutableArray alloc] initWithCapacity:[self count]];
	NSEnumerator *enumerator = [self reverseObjectEnumerator];
	id object;
	while (object = [enumerator nextObject]) [array addObject:object];
	return [array autorelease];
}

@end
