#import "NSIndexPath_SUAdditions.h"

@implementation NSIndexPath (SUAdditions)

- (NSIndexPath *) indexPathByRemovingFirstIndex {
	NSUInteger *indexes = malloc(sizeof(NSUInteger)*([self length] - 1));
	NSUInteger depth;
	for (depth = 1; depth != [self length]; depth++) indexes[depth - 1] = [self indexAtPosition:depth];
	NSIndexPath *strippedPath = [[NSIndexPath alloc] initWithIndexes:indexes length:([self length] - 1)];
	free(indexes);
	return [strippedPath autorelease];
}

@end
