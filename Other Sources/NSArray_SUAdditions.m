#import "NSArray_SUAdditions.h"

@implementation NSArray (SUAdditions)

- (NSArray *) initWithObject:(id)object {
	NSZone *memorySpace = [self zone];
	[self release];
	NSMutableArray *newSelf = [[NSMutableArray allocWithZone:memorySpace] initWithCapacity:1];
	[newSelf addObject:object];
	return newSelf;
}

- (NSArray *) reversedArray {
	NSMutableArray *array = [[NSMutableArray alloc] initWithCapacity:[self count]];
	NSEnumerator *enumerator = [self reverseObjectEnumerator];
	id object;
	while (object = [enumerator nextObject]) [array addObject:object];
	return [array autorelease];
}

@end
