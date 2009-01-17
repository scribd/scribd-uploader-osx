#import "SUCategory.h"

@implementation SUCategory

@dynamic name;
@dynamic position;

@dynamic parent;
@dynamic children;

@dynamic indexPath;

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

- (NSIndexPath *) indexPath {
	if (indexPath) return indexPath;
	
	if (self.parent) indexPath = [self.parent.indexPath indexPathByAddingIndex:[self.position unsignedIntegerValue]];
	else indexPath = [NSIndexPath indexPathWithIndex:[self.position unsignedIntegerValue]];
	return indexPath;
}

@end
