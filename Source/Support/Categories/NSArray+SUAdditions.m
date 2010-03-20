#import "NSArray+SUAdditions.h"

@implementation NSArray (SUAdditions)

#pragma mark Initializing an Array

- (NSArray *) initWithObject:(id)object {
	NSZone *memorySpace = [self zone];
	[self release];
	NSMutableArray *newSelf = [[NSMutableArray allocWithZone:memorySpace] initWithCapacity:1];
	[newSelf addObject:object];
	return newSelf;
}

#pragma mark Deriving New Arrays

- (NSArray *) reversedArray {
	NSMutableArray *array = [[NSMutableArray alloc] initWithCapacity:[self count]];
	NSEnumerator *enumerator = [self reverseObjectEnumerator];
	id object;
	while (object = [enumerator nextObject]) [array addObject:object];
	return [array autorelease];
}

- (NSArray *) map:(id (^)(id value))block {
	NSMutableArray *mappedArray = [[NSMutableArray alloc] initWithCapacity:[self count]];
	for (id object in self) [mappedArray addObject:block(object)];
	return [mappedArray autorelease];
}

@end
