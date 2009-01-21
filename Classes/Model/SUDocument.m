#import "SUDocument.h"

static NSDictionary *kinds = NULL;

@interface SUDocument (Private)

/*
 Returns a list of supported filetypes mapped to descriptions of each type.
 */

+ (NSDictionary *) kinds;

@end


@implementation SUDocument

@dynamic path;
@dynamic progress;
@dynamic success;
@dynamic error;
@dynamic errorIsUnrecoverable;
@dynamic scribdID;
@dynamic hidden;
@dynamic title;
@dynamic summary;
@dynamic tags;

@dynamic category;

@dynamic filename;
@dynamic icon;
@dynamic kind;
@dynamic discoverability;
@dynamic errorLevel;

#pragma mark Initialization/deallocation

/*
 You're not really supposed to override init for managed objects, but I see no
 other way I can ensure that wrapper is nilled out before anyone else touches it.
 */

- (id) init {
	if (self = [super init]) {
		wrapper = NULL;
		kind = NULL;
		status = NULL;
	}
	return self;
}

/*
 Observe the path attribute so that we can prepare dependent attributes if it
 changes.
 */

- (void) awakeFromInsert {
	[self addObserver:self forKeyPath:@"path" options:NSKeyValueObservingOptionNew context:NULL];
}

/*
 Observe the path attribute so that we can prepare dependent attributes if it
 changes.
 */

- (void) awakeFromFetch {
	[self addObserver:self forKeyPath:@"path" options:NSKeyValueObservingOptionNew context:NULL];
}

/*
 Releases retained objects.
 */

- (void) dealloc {
	if (wrapper) [wrapper release];
	if (kind) [kind release];
	[super dealloc];
}

#pragma mark -
#pragma mark Derived properties

- (NSString *) filename {
	return [[NSFileManager defaultManager] displayNameAtPath:self.path];
}

- (NSString *) kind {
	if (!kind) {
		kind = [[[SUDocument kinds] objectForKey:[self.path pathExtension]] retain];
	}
	return kind;
}

- (NSImage *) icon {
	return [[self wrapper] icon];
}

- (NSNumber *) discoverability {
	if ([self.hidden boolValue]) return [NSNumber numberWithUnsignedInteger:0];
	NSUInteger disc = 1;
	if ([[NSSpellChecker sharedSpellChecker] countWordsInString:self.summary language:NULL] >= 5) disc++;
	if ([[NSSpellChecker sharedSpellChecker] countWordsInString:self.title language:NULL] >= 2) disc++;
	if (self.category) disc++;
	return [NSNumber numberWithUnsignedInteger:disc];
}

- (NSFileWrapper *) wrapper {
	if (!wrapper) wrapper = [[NSFileWrapper alloc] initWithPath:self.path];
	return wrapper;
}

- (BOOL) pointsToActualFile {
	return [[NSFileManager defaultManager] fileExistsAtPath:self.path];
}

- (NSString *) errorLevel {
	if (self.success && [self.success boolValue]) return @"Success";
	if (self.error) {
		if (self.errorIsUnrecoverable && [self.errorIsUnrecoverable boolValue]) return @"Error";
		else return @"Caution";
	}
	return @"Pending";
}

#pragma mark -
#pragma mark Key paths

/*
 When the path changes, we need to release the wrapper and kind to prepare for
 new lazy inits. We also need to check the title cleaner and suggest a title if
 one hasn't been added yet.
 */

- (void) observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary *)change context:(void *)context {
	if ([keyPath isEqualToString:@"path"]) {
		if (wrapper) [wrapper release];
		wrapper = NULL;
		if (kind) [kind release];
		kind = NULL;
		
		if (self.path && (!self.title || [self.title isEmpty])) {
			NSString *suggestedTitle = [[SUScribdAPI sharedAPI] titleForFilename:self.filename];
			if (suggestedTitle) self.title = suggestedTitle;
		}
	}
	else [super observeValueForKeyPath:keyPath ofObject:object change:change context:context];
}

/*
 When the path changes the filename must change as well.
 */

+ (NSSet *) keyPathsForValuesAffectingFilename {
	return [NSSet setWithObject:@"path"];
}

/*
 When the path changes the kind must change as well.
 */

+ (NSSet *) keyPathsForValuesAffectingKind {
	return [NSSet setWithObject:@"path"];
}

/*
 When the path changes the icon must change as well.
 */

+ (NSSet *) keyPathsForValuesAffectingIcon {
	return [NSSet setWithObject:@"path"];
}

/*
 Discoverability is determined by title, description, category, and the private
 setting.
 */

+ (NSSet *) keyPathsForValuesAffectingDiscoverability {
	return [NSSet setWithObjects:@"title", @"summary", @"category", @"hidden", NULL];
}

/*
 Error level is determined by success, error, and unrecoverable status.
 */

+ (NSSet *) keyPathsForValuesAffectingErrorLevel {
	return [NSSet setWithObjects:@"error", @"success", @"errorIsUnrecoverable", NULL];
}

#pragma mark -
#pragma mark Finders

+ (SUDocument *) findByPath:(NSString *)path inManagedObjectContext:(NSManagedObjectContext *)managedObjectContext {
	NSEntityDescription *docEntity = [NSEntityDescription entityForName:@"Document" inManagedObjectContext:managedObjectContext];
	
	NSExpression *lhs = [NSExpression expressionForKeyPath:@"path"];
	NSExpression *rhs = [NSExpression expressionForConstantValue:[path stringByStandardizingPath]];
	NSPredicate *predicate = [[NSComparisonPredicate alloc] initWithLeftExpression:lhs
																   rightExpression:rhs
																		  modifier:NSDirectPredicateModifier
																			  type:NSEqualToPredicateOperatorType
																		   options:NSCaseInsensitivePredicateOption];
	
	NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] init];
	[fetchRequest setEntity:docEntity];
	[fetchRequest setPredicate:predicate];
	
	NSError *error = NULL;
	NSArray *objects = [managedObjectContext executeFetchRequest:fetchRequest error:&error];
	[predicate release];
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

+ (NSArray *) findPendingInManagedObjectContext:(NSManagedObjectContext *)managedObjectContext error:(NSError **)error {
	NSEntityDescription *docEntity = [NSEntityDescription entityForName:@"Document" inManagedObjectContext:managedObjectContext];
	
	NSExpression *lhs = [NSExpression expressionForKeyPath:@"success"];
	NSExpression *rhs = [NSExpression expressionForConstantValue:[NSNull null]];
	NSPredicate *predicate = [[NSComparisonPredicate alloc] initWithLeftExpression:lhs
																   rightExpression:rhs
																		  modifier:NSDirectPredicateModifier
																			  type:NSEqualToPredicateOperatorType
																		   options:0];
	
	NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] init];
	[fetchRequest setEntity:docEntity];
	[fetchRequest setPredicate:predicate];
	
	NSArray *objects = [managedObjectContext executeFetchRequest:fetchRequest error:error];
	[predicate release];
	[fetchRequest release];
	
	return objects;
}

+ (NSArray *) findUploadedInManagedObjectContext:(NSManagedObjectContext *)managedObjectContext error:(NSError **)error {
	NSEntityDescription *docEntity = [NSEntityDescription entityForName:@"Document" inManagedObjectContext:managedObjectContext];
	
	NSExpression *lhs = [NSExpression expressionForKeyPath:@"success"];
	NSExpression *rhs = [NSExpression expressionForConstantValue:[NSNumber numberWithBool:YES]];
	NSPredicate *successPredicate = [[NSComparisonPredicate alloc] initWithLeftExpression:lhs
																   rightExpression:rhs
																		  modifier:NSDirectPredicateModifier
																			  type:NSEqualToPredicateOperatorType
																		   options:0];
	lhs = [NSExpression expressionForKeyPath:@"error"];
	rhs = [NSExpression expressionForConstantValue:[NSNull null]];
	NSPredicate *errorPredicate = [[NSComparisonPredicate alloc] initWithLeftExpression:lhs
																		rightExpression:rhs
																			   modifier:NSDirectPredicateModifier
																				   type:NSNotEqualToPredicateOperatorType
																				options:0];
	lhs = [NSExpression expressionForKeyPath:@"errorIsUnrecoverable"];
	rhs = [NSExpression expressionForConstantValue:[NSNumber numberWithBool:NO]];
	NSPredicate *unrecoverablePredicate = [[NSComparisonPredicate alloc] initWithLeftExpression:lhs
																				rightExpression:rhs
																					   modifier:NSDirectPredicateModifier
																						   type:NSEqualToPredicateOperatorType
																						options:0];
	NSArray *subpredicates = [[NSArray alloc] initWithObjects:errorPredicate, unrecoverablePredicate, NULL];
	NSPredicate *unrecoverableErrorOnlyPredicate = [[NSCompoundPredicate alloc] initWithType:NSAndPredicateType subpredicates:subpredicates];
	[subpredicates release];
	subpredicates = [[NSArray alloc] initWithObjects:successPredicate, unrecoverableErrorOnlyPredicate, NULL];
	NSPredicate *predicate = [[NSCompoundPredicate alloc] initWithType:NSOrPredicateType subpredicates:subpredicates];
	[subpredicates release];
	
	NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] init];
	[fetchRequest setEntity:docEntity];
	[fetchRequest setPredicate:predicate];
	
	NSArray *objects = [managedObjectContext executeFetchRequest:fetchRequest error:error];
	[successPredicate release];
	[errorPredicate release];
	[unrecoverablePredicate release];
	[unrecoverableErrorOnlyPredicate release];
	[predicate release];
	[fetchRequest release];
	
	return objects;
}

+ (NSUInteger) numberOfPendingInManagedObjectContext:(NSManagedObjectContext *)managedObjectContext error:(NSError **)error {
	NSEntityDescription *docEntity = [NSEntityDescription entityForName:@"Document" inManagedObjectContext:managedObjectContext];
	
	NSExpression *lhs = [NSExpression expressionForKeyPath:@"success"];
	NSExpression *rhs = [NSExpression expressionForConstantValue:[NSNull null]];
	NSPredicate *predicate = [[NSComparisonPredicate alloc] initWithLeftExpression:lhs
																   rightExpression:rhs
																		  modifier:NSDirectPredicateModifier
																			  type:NSEqualToPredicateOperatorType
																		   options:0];
	
	NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] init];
	[fetchRequest setEntity:docEntity];
	[fetchRequest setPredicate:predicate];
	
	NSUInteger count = [managedObjectContext countForFetchRequest:fetchRequest error:error];
	[predicate release];
	[fetchRequest release];
	
	return count;
}

#pragma mark -
#pragma mark Other

+ (NSArray *) scribdFileTypes {
	return [[self kinds] allKeys];
}

@end

@implementation SUDocument (Private)

+ (NSDictionary *) kinds {
	if (!kinds) kinds = [[NSDictionary alloc] initWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"FileTypes" ofType:@"plist"]];
	return kinds;
}

@end
