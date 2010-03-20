#import "SUDocument+Finders.h"

@implementation SUDocument (Finders)

#pragma mark Finding documents

+ (SUDocument *) findByPath:(NSString *)path inManagedObjectContext:(NSManagedObjectContext *)managedObjectContext {
	NSEntityDescription *docEntity = [NSEntityDescription entityForName:@"Document" inManagedObjectContext:managedObjectContext];
	
	NSExpression *lhs = [NSExpression expressionForKeyPath:@"path"];
	NSExpression *rhs = [NSExpression expressionForConstantValue:path];
	NSPredicate *pathMatches = [[NSComparisonPredicate alloc] initWithLeftExpression:lhs
																	 rightExpression:rhs
																			modifier:NSDirectPredicateModifier
																				type:NSEqualToPredicateOperatorType
																			 options:NSCaseInsensitivePredicateOption]; // path == ?
	
	NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] init];
	[fetchRequest setEntity:docEntity];
	[fetchRequest setPredicate:pathMatches];
	
	NSError *error = NULL;
	NSArray *objects = [managedObjectContext executeFetchRequest:fetchRequest error:&error];
	[pathMatches release];
	[fetchRequest release];
	
	if (objects && [objects count] > 0) return [objects objectAtIndex:0];
	else return NULL;
}

+ (NSArray *) findAllInManagedObjectContext:(NSManagedObjectContext *)managedObjectContext error:(NSError **)error {
	NSEntityDescription *docEntity = [NSEntityDescription entityForName:@"Document" inManagedObjectContext:managedObjectContext];
	
	NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] init];
	[fetchRequest setEntity:docEntity];
	
	NSArray *objects = [managedObjectContext executeFetchRequest:fetchRequest error:error];
	[fetchRequest release];
	
	return objects;
}

+ (NSArray *) findUploadableInManagedObjectContext:(NSManagedObjectContext *)managedObjectContext error:(NSError **)error {
	NSEntityDescription *docEntity = [NSEntityDescription entityForName:@"Document" inManagedObjectContext:managedObjectContext];
	
	NSExpression *lhs = [NSExpression expressionForKeyPath:@"scribdID"];
	NSExpression *rhs = [NSExpression expressionForConstantValue:[NSNull null]];
	NSPredicate *docIsPending = [[NSComparisonPredicate alloc] initWithLeftExpression:lhs
																	  rightExpression:rhs
																			 modifier:NSDirectPredicateModifier
																				 type:NSEqualToPredicateOperatorType
																			  options:0]; // scribdID IS NULL
	
	NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] init];
	[fetchRequest setEntity:docEntity];
	[fetchRequest setPredicate:docIsPending];
	
	NSArray *objects = [managedObjectContext executeFetchRequest:fetchRequest error:error];
	[docIsPending release];
	[fetchRequest release];
	
	return objects;
}

+ (NSArray *) findUploadedInManagedObjectContext:(NSManagedObjectContext *)managedObjectContext error:(NSError **)error {
	NSEntityDescription *docEntity = [NSEntityDescription entityForName:@"Document" inManagedObjectContext:managedObjectContext];
	
	NSExpression *lhs = [NSExpression expressionForKeyPath:@"success"];
	NSExpression *rhs = [NSExpression expressionForConstantValue:[NSNumber numberWithBool:YES]];
	NSPredicate *uploadSuccessful = [[NSComparisonPredicate alloc] initWithLeftExpression:lhs
																		  rightExpression:rhs
																				 modifier:NSDirectPredicateModifier
																					 type:NSEqualToPredicateOperatorType
																				  options:0]; // success = TRUE
	lhs = [NSExpression expressionForKeyPath:@"error"];
	rhs = [NSExpression expressionForConstantValue:[NSNull null]];
	NSPredicate *noError = [[NSComparisonPredicate alloc] initWithLeftExpression:lhs
																 rightExpression:rhs
																		modifier:NSDirectPredicateModifier
																			type:NSNotEqualToPredicateOperatorType
																		 options:0]; // error IS NOT NULL
	lhs = [NSExpression expressionForKeyPath:@"errorIsUnrecoverable"];
	rhs = [NSExpression expressionForConstantValue:[NSNumber numberWithBool:NO]];
	NSPredicate *errorWasWarning = [[NSComparisonPredicate alloc] initWithLeftExpression:lhs
																		 rightExpression:rhs
																				modifier:NSDirectPredicateModifier
																					type:NSEqualToPredicateOperatorType
																				 options:0]; // errorIsUnrecoverable = FALSE
	NSArray *subpredicates = [[NSArray alloc] initWithObjects:noError, errorWasWarning, NULL];
	NSPredicate *withRecoverableErrors = [[NSCompoundPredicate alloc] initWithType:NSAndPredicateType subpredicates:subpredicates]; // error IS NOT NULL AND errorIsUnrecoverable = FALSE
	[subpredicates release];
	subpredicates = [[NSArray alloc] initWithObjects:uploadSuccessful, withRecoverableErrors, NULL];
	NSPredicate *docWasUploaded = [[NSCompoundPredicate alloc] initWithType:NSOrPredicateType subpredicates:subpredicates]; // success = TRUE OR (error IS NOT NULL AND errorIsUnrecoverable = FALSE)
	[subpredicates release];
	
	NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] init];
	[fetchRequest setEntity:docEntity];
	[fetchRequest setPredicate:docWasUploaded];
	
	NSArray *objects = [managedObjectContext executeFetchRequest:fetchRequest error:error];
	[uploadSuccessful release];
	[noError release];
	[errorWasWarning release];
	[withRecoverableErrors release];
	[docWasUploaded release];
	[fetchRequest release];
	
	return objects;
}

+ (NSUInteger) numberOfUploadableInManagedObjectContext:(NSManagedObjectContext *)managedObjectContext error:(NSError **)error {
	NSEntityDescription *docEntity = [NSEntityDescription entityForName:@"Document" inManagedObjectContext:managedObjectContext];
	
	NSExpression *lhs = [NSExpression expressionForKeyPath:@"scribdID"];
	NSExpression *rhs = [NSExpression expressionForConstantValue:[NSNull null]];
	NSPredicate *docIsPending = [[NSComparisonPredicate alloc] initWithLeftExpression:lhs
																	  rightExpression:rhs
																			 modifier:NSDirectPredicateModifier
																				 type:NSEqualToPredicateOperatorType
																			  options:0]; // scribdID IS NULL
	
	NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] init];
	[fetchRequest setEntity:docEntity];
	[fetchRequest setPredicate:docIsPending];
	
	NSUInteger count = [managedObjectContext countForFetchRequest:fetchRequest error:error];
	[docIsPending release];
	[fetchRequest release];
	
	return count;
}

@end
