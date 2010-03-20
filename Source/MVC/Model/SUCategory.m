#import "SUCategory.h"

@implementation SUCategory

#pragma mark Properties

@dynamic name;
@dynamic position;

@dynamic parent;
@dynamic children;

@dynamic indexPath;

#pragma mark Initializing and deallocating

/*
 Initialize indexPath field.
 */

- (void) awakeFromFetch {
	[super awakeFromFetch];
	indexPath = NULL;
}

/*
 Initialize indexPath field.
 */

- (void) awakeFromInsert {
	[super awakeFromInsert];
	indexPath = NULL;
}

#pragma mark Dynamic properties

- (NSIndexPath *) indexPath {
	if (indexPath) return indexPath;
	
	if (self.parent) indexPath = [self.parent.indexPath indexPathByAddingIndex:[self.position unsignedIntegerValue]];
	else indexPath = [NSIndexPath indexPathWithIndex:[self.position unsignedIntegerValue]];
	return indexPath;
}

@end
