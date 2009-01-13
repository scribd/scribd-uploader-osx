#import "SUDocumentHelper.h"

static SUDocumentHelper *sharedDocumentManager = NULL;

@implementation SUDocumentHelper

+ (SUDocumentHelper *) documentManager {
	@synchronized(self) {
		if (sharedDocumentManager == NULL) [[self alloc] init];
	}
	return sharedDocumentManager;
}


/*
 Ensures that someone else cannot directly allocate space for another instance.
 */

+ (id) allocWithZone:(NSZone *)zone {
	@synchronized(self) {
		if (sharedDocumentManager == NULL) {
			sharedDocumentManager = [super allocWithZone:zone];
			return sharedDocumentManager;
		}
	}
	return NULL;
}

/*
 Ensures singleton status by disallowing copies.
 */

- (id) copyWithZone:(NSZone *)zone {
	return self;
}

/*
 Prevents this object from being retained.
 */

- (id) retain {
	return self;
}

/*
 Indicates that this object is not memory-managed.
 */

- (NSUInteger) retainCount {
	return NSUIntegerMax;
}

/*
 Prevents this object from being released.
 */

- (void) release {
	
}

/*
 Prevents this object from being added to an autorelease pool.
 */

- (id) autorelease {
	return self;
}

- (SUDocument *) findDocumentByPath:(NSString *)path inManagedObjectContext:(NSManagedObjectContext *)managedObjectContext {
	NSEntityDescription *docEntity = [NSEntityDescription entityForName:@"Document" inManagedObjectContext:managedObjectContext];
	
	NSExpression *lhs = [NSExpression expressionForKeyPath:@"path"];
	NSExpression *rhs = [NSExpression expressionForConstantValue:[NSArray arrayWithObject:[path stringByStandardizingPath]]];
	NSPredicate *predicate = [NSComparisonPredicate predicateWithLeftExpression:lhs
																rightExpression:rhs
																	   modifier:NSDirectPredicateModifier
																		   type:NSEqualToPredicateOperatorType
																		options:NSCaseInsensitivePredicateOption];
	
	NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] init];
	[fetchRequest setEntity:docEntity];
	[fetchRequest setPredicate:predicate];
	
	NSError *error = NULL;
	NSArray *objects = [managedObjectContext executeFetchRequest:fetchRequest error:&error];
	[fetchRequest release];
	
	if (objects && [objects count] > 0) return [objects objectAtIndex:0];
	else return NULL;
}

- (BOOL) documentPointsToActualFile:(SUDocument *)document {
	return [[NSFileManager defaultManager] fileExistsAtPath:document.path];
}

- (NSArray *) scribdFileTypes {
	return [[NSDictionary dictionaryWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"FileTypes" ofType:@"plist"]] allKeys];
}

- (NSArray *) allDocumentsInManagedObjectContext:(NSManagedObjectContext *)managedObjectContext error:(NSError **)error {
	NSEntityDescription *docEntity = [NSEntityDescription entityForName:@"Document" inManagedObjectContext:managedObjectContext];
	
	NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] init];
	[fetchRequest setEntity:docEntity];
	
	NSArray *objects = [managedObjectContext executeFetchRequest:fetchRequest error:error];
	[fetchRequest release];
	
	return objects;
}

- (NSArray *) pendingDocumentsInManagedObjectContext:(NSManagedObjectContext *)managedObjectContext error:(NSError **)error {
	NSEntityDescription *docEntity = [NSEntityDescription entityForName:@"Document" inManagedObjectContext:managedObjectContext];
	
	NSExpression *lhs = [NSExpression expressionForKeyPath:@"success"];
	NSExpression *rhs = [NSExpression expressionForConstantValue:[NSNull null]];
	NSPredicate *predicate = [NSComparisonPredicate predicateWithLeftExpression:lhs
																rightExpression:rhs
																	   modifier:NSDirectPredicateModifier
																		   type:NSEqualToPredicateOperatorType
																		options:NSCaseInsensitivePredicateOption];
	
	NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] init];
	[fetchRequest setEntity:docEntity];
	[fetchRequest setPredicate:predicate];
	
	NSArray *objects = [managedObjectContext executeFetchRequest:fetchRequest error:error];
	[fetchRequest release];
	
	return objects;
}

- (NSArray *) completedDocumentsInManagedObjectContext:(NSManagedObjectContext *)managedObjectContext error:(NSError **)error {
	NSEntityDescription *docEntity = [NSEntityDescription entityForName:@"Document" inManagedObjectContext:managedObjectContext];
	
	NSExpression *lhs = [NSExpression expressionForKeyPath:@"success"];
	NSExpression *rhs = [NSExpression expressionForConstantValue:[NSNumber numberWithBool:YES]];
	NSPredicate *predicate = [NSComparisonPredicate predicateWithLeftExpression:lhs
																rightExpression:rhs
																	   modifier:NSDirectPredicateModifier
																		   type:NSEqualToPredicateOperatorType
																		options:NSCaseInsensitivePredicateOption];	
	
	NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] init];
	[fetchRequest setEntity:docEntity];
	[fetchRequest setPredicate:predicate];
	
	NSArray *objects = [managedObjectContext executeFetchRequest:fetchRequest error:error];
	[fetchRequest release];
	
	return objects;
}

- (NSUInteger) numberOfPendingDocumentsInManagedObjectContext:(NSManagedObjectContext *)managedObjectContext error:(NSError **)error {
	NSEntityDescription *docEntity = [NSEntityDescription entityForName:@"Document" inManagedObjectContext:managedObjectContext];
	
	NSExpression *lhs = [NSExpression expressionForKeyPath:@"success"];
	NSExpression *rhs = [NSExpression expressionForConstantValue:[NSNull null]];
	NSPredicate *predicate = [NSComparisonPredicate predicateWithLeftExpression:lhs
																rightExpression:rhs
																	   modifier:NSDirectPredicateModifier
																		   type:NSEqualToPredicateOperatorType
																		options:NSCaseInsensitivePredicateOption];
	
	NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] init];
	[fetchRequest setEntity:docEntity];
	[fetchRequest setPredicate:predicate];
	
	NSUInteger count = [managedObjectContext countForFetchRequest:fetchRequest error:error];
	[fetchRequest release];
	
	return count;
}

@end
