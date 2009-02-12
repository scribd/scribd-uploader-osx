#import "SUIndexPathValueTransformer.h"

@implementation SUIndexPathValueTransformer

#pragma mark Properties

@synthesize managedObjectContext;

#pragma mark Initializing and deallocating

/*
 Initializes instance fields.
 */

- (id) init {
	if (self = [super init]) {
		managedObjectContext = NULL;
	}
	return self;
}

#pragma mark Value transformer

/*
 This transformer converts between different subclasses of NSObject.
 */

+ (Class) transformedValueClass {
	return [NSObject class];
}

/*
 This is a bidirectional transformer.
 */

+ (BOOL) allowsReverseTransformation {
	return YES;
}

/*
 Releases local memory usage.
 */

- (void) dealloc {
	if (managedObjectContext) [managedObjectContext release];
	[super dealloc];
}

/*
 Returns the index path for a Category managed object.
 */

- (id) transformedValue:(id)value {
	if ([value isKindOfClass:[NSManagedObject class]])
		return [NSArray arrayWithObject:[(SUCategory *)value indexPath]];
	else return value;
}

/*
 Finds a managed object from an index path.
 */

- (id) reverseTransformedValue:(id)value {
	if ([value isKindOfClass:[NSArray class]] && [(NSArray *)value count] == 1) {
		NSIndexPath *path = [(NSArray *)value objectAtIndex:0];
		return [SUCategory categoryAtIndexPath:path inManagedObjectContext:self.managedObjectContext];
	}
	else if ([value isKindOfClass:[NSIndexPath class]])
		return [SUCategory categoryAtIndexPath:(NSIndexPath *)value inManagedObjectContext:self.managedObjectContext];
	else return value;
}


@end
