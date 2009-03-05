#import "SUDocument.h"

static NSDictionary *kinds = NULL;
static NSOperationQueue *titleCleaningQueue = NULL;

@interface SUDocument (Private)

#pragma mark Helpers

/*
 Returns a list of supported filetypes mapped to descriptions of each type.
 */

+ (NSDictionary *) kinds;

@end

#pragma mark -

@implementation SUDocument

#pragma mark Properties

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
@dynamic author;
@dynamic publisher;
@dynamic edition;
@dynamic datePublished;
@dynamic license;

@dynamic category;

@dynamic URL;
@dynamic fileSystemPath;
@dynamic filename;
@dynamic icon;
@dynamic kind;
@dynamic discoverability;
@dynamic errorLevel;
@dynamic scribdURL;
@dynamic editURL;
@dynamic uploaded;

#pragma mark Initializing and deallocating

/*
 Initializes the title-cleaning queue.
 */

+ (void) initialize {
	titleCleaningQueue = [[NSOperationQueue alloc] init];
}

/*
 You're not really supposed to override init for managed objects, but I see no
 other way I can ensure that wrapper is nilled out before anyone else touches it.
 */

- (id) init {
	if (self = [super init]) {
		wrapper = NULL;
		kind = NULL;
		URL = NULL;
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
	if (URL) [URL release];
	[super dealloc];
}

#pragma mark Dynamic properties

- (NSURL *) URL {
	if (!URL) URL = [[NSURL alloc] initWithString:self.path];
	return URL;
}

- (NSString *) fileSystemPath {
	return [URL relativePath];
}

- (NSString *) filename {
	if ([self isRemoteFile]) return [[self.URL relativeString] lastPathComponent];
	else return [[NSFileManager defaultManager] displayNameAtPath:self.fileSystemPath];
}

- (NSString *) kind {
	if (!kind) {
		if ([self isRemoteFile]) kind = [[[SUDocument kinds] objectForKey:[[self.URL relativeString] pathExtension]] retain];
		else kind = [[[SUDocument kinds] objectForKey:[self.fileSystemPath pathExtension]] retain];
	}
	return kind;
}

- (NSImage *) icon {
	//TODO remote files
	if ([self isRemoteFile]) return NULL;
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
	if ([self isRemoteFile]) return NULL;
	if (!wrapper) wrapper = [[NSFileWrapper alloc] initWithPath:self.fileSystemPath];
	return wrapper;
}

- (BOOL) pointsToActualFile {
	if ([self isRemoteFile]) return NO;
	return [[NSFileManager defaultManager] fileExistsAtPath:self.fileSystemPath];
}

- (BOOL) isRemoteFile {
	return ![URL isFileURL];
}

- (NSString *) errorLevel {
	if (self.success && [self.success boolValue]) return @"Success";
	if (self.error) {
		if (self.errorIsUnrecoverable && [self.errorIsUnrecoverable boolValue]) return @"Error";
		else return @"Caution";
	}
	return @"Pending";
}

- (BOOL) uploaded {
	return (self.scribdID != NULL);
}

- (NSURL *) scribdURL {
	if (!self.uploaded) return NULL;
	NSString *URLString = [[NSString alloc] initWithFormat:[[[NSBundle mainBundle] infoDictionary] objectForKey:SUDocumentURLInfoKey], self.scribdID];
	NSURL *viewURL = [[NSURL alloc] initWithString:URLString];
	[URLString release];
	return [viewURL autorelease];
}

- (NSURL *) editURL {
	if (!self.uploaded) return NULL;
	NSString *URLString = [[NSString alloc] initWithFormat:[[[NSBundle mainBundle] infoDictionary] objectForKey:SUDocumentEditURLInfoKey], self.scribdID];
	NSURL *editURL = [[NSURL alloc] initWithString:URLString];
	[URLString release];
	return [editURL autorelease];
}

#pragma mark KVO

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
		
		if ([change objectForKey:NSKeyValueChangeNewKey] && [[change objectForKey:NSKeyValueChangeNewKey] isNotEqualTo:[NSNull null]]) {
			SUTitleCleanerOperation *op = [[SUTitleCleanerOperation alloc] initWithDocument:self];
			[titleCleaningQueue addOperation:op];
			[op release];
		}
	}
	else [super observeValueForKeyPath:keyPath ofObject:object change:change context:context];
}

/*
 When the path changes the URL must change as well.
 */

+ (NSSet *) keyPathsForValuesAffectingURL {
	return [NSSet setWithObject:@"path"];
}

/*
 When the path changes the fileSystemPath must change as well.
 */

+ (NSSet *) keyPathsForValuesAffectingFileSystemPath {
	return [NSSet setWithObject:@"path"];
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

/*
 Scribd URL is determined by Scribd URL.
 */

+ (NSSet *) keyPathsForValuesAffectingScribdURL {
	return [NSSet setWithObject:@"scribdID"];
}

/*
 isUploaded is determined by Scribd URL.
 */

+ (NSSet *) keyPathsForValuesAffectingUploaded {
	return [NSSet setWithObject:@"scribdID"];
}

#pragma mark Finding documents

+ (SUDocument *) findByPath:(NSString *)path inManagedObjectContext:(NSManagedObjectContext *)managedObjectContext {
	NSURL *pathURL = [[NSURL alloc] initFileURLWithPath:[path stringByStandardizingPath]];
	NSEntityDescription *docEntity = [NSEntityDescription entityForName:@"Document" inManagedObjectContext:managedObjectContext];
	
	NSExpression *lhs = [NSExpression expressionForKeyPath:@"path"];
	NSExpression *rhs = [NSExpression expressionForConstantValue:[[pathURL absoluteURL] absoluteString]];
	[pathURL release];
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

#pragma mark Creating new records

+ (SUDocument *) createFromPath:(NSString *)path inManagedObjectContext:(NSManagedObjectContext *)managedObjectContext {
	NSURL *pathURL = [[NSURL alloc] initFileURLWithPath:[path stringByStandardizingPath]];
	SUDocument *existingDocument = NULL;
	if (existingDocument = [SUDocument findByPath:path inManagedObjectContext:managedObjectContext])
		[managedObjectContext deleteObject:existingDocument];
	SUDocument *file = [NSEntityDescription insertNewObjectForEntityForName:@"Document" inManagedObjectContext:managedObjectContext];
	[file setValue:[[pathURL absoluteURL] absoluteString] forKey:@"path"];
	[pathURL release];
	if ([[NSUserDefaults standardUserDefaults] objectForKey:SUDefaultKeyUploadPrivateDefault]) [file setValue:[NSNumber numberWithBool:YES] forKey:@"hidden"];	
	return file;
}

#pragma mark Configuration information

+ (NSArray *) scribdFileTypes {
	return [[self kinds] allKeys];
}

@end

#pragma mark -

@implementation SUDocument (Private)

#pragma mark Helpers

+ (NSDictionary *) kinds {
	if (!kinds) kinds = [[NSDictionary alloc] initWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"FileTypes" ofType:@"plist"]];
	return kinds;
}

@end
