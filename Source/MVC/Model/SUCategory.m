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

#pragma mark Finding categories

+ (SUCategory *) categoryAtIndexPath:(NSIndexPath *)path inManagedObjectContext:(NSManagedObjectContext *)managedObjectContext {
	NSEntityDescription *entity = [NSEntityDescription entityForName:@"Category" inManagedObjectContext:managedObjectContext];
	
	NSExpression *lhs = [NSExpression expressionForKeyPath:@"position"];
	NSExpression *rhs = [NSExpression expressionForConstantValue:[NSNumber numberWithUnsignedInteger:[path indexAtPosition:0]]];
	NSPredicate *positionedAtPathIndex = [[NSComparisonPredicate alloc] initWithLeftExpression:lhs
																			   rightExpression:rhs
																					  modifier:NSDirectPredicateModifier
																						  type:NSEqualToPredicateOperatorType
																					   options:0]; // position = ?
	lhs = [NSExpression expressionForKeyPath:@"parent"];
	rhs = [NSExpression expressionForConstantValue:[NSNull null]];
	NSPredicate *noParent = [[NSComparisonPredicate alloc] initWithLeftExpression:lhs
																  rightExpression:rhs
																		 modifier:NSDirectPredicateModifier
																			 type:NSEqualToPredicateOperatorType
																		  options:0]; // parent IS NULL
	NSArray *subpredicates = [[NSArray alloc] initWithObjects:noParent, positionedAtPathIndex, NULL];
	NSPredicate *rootNodePositionedAtPathIndex = [[NSCompoundPredicate alloc] initWithType:NSAndPredicateType subpredicates:subpredicates]; // position = ? AND parent IS NULL
	NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] init];
	[fetchRequest setEntity:entity];
	[fetchRequest setPredicate:rootNodePositionedAtPathIndex];
	
	NSError *error = NULL;
	NSArray *objects = [managedObjectContext executeFetchRequest:fetchRequest error:&error];
	[subpredicates release];
	[positionedAtPathIndex release];
	[noParent release];
	[rootNodePositionedAtPathIndex release];
	[fetchRequest release];
	
	SUCategory *category;
	if (objects && [objects count] > 0) category = [objects objectAtIndex:0];
	else return NULL;
	
	if ([path length] == 1) return category;
	else return [category categoryAtIndexPath:[path indexPathByRemovingFirstIndex] inManagedObjectContext:managedObjectContext];
}

- (SUCategory *) categoryAtIndexPath:(NSIndexPath *)path inManagedObjectContext:(NSManagedObjectContext *)managedObjectContext {	
	NSExpression *lhs = [NSExpression expressionForKeyPath:@"position"];
	NSExpression *rhs = [NSExpression expressionForConstantValue:[NSNumber numberWithUnsignedInteger:[path indexAtPosition:0]]];
	NSPredicate *positionedAtPathIndex = [[NSComparisonPredicate alloc] initWithLeftExpression:lhs
																			   rightExpression:rhs
																					  modifier:NSDirectPredicateModifier
																						  type:NSEqualToPredicateOperatorType
																					   options:NSCaseInsensitivePredicateOption]; // position = ?
	NSSet *objects = [self.children filteredSetUsingPredicate:positionedAtPathIndex];
	[positionedAtPathIndex release];
	
	SUCategory *category;
	if (objects && [objects count] == 1) category = [objects anyObject];
	else return NULL;
	
	if ([path length] == 1) return category;
	else return [category categoryAtIndexPath:[path indexPathByRemovingFirstIndex] inManagedObjectContext:managedObjectContext];	
}

+ (NSUInteger) countInManagedObjectContext:(NSManagedObjectContext *)managedObjectContext {
	NSEntityDescription *entity = [NSEntityDescription entityForName:@"Category" inManagedObjectContext:managedObjectContext];
	NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] init];
	[fetchRequest setEntity:entity];
	NSError *error = NULL;
	NSUInteger numRecords = [managedObjectContext countForFetchRequest:fetchRequest error:&error];
	[fetchRequest release];
	return numRecords;
}

@end
