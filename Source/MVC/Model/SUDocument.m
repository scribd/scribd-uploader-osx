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
@dynamic converting;
@dynamic conversionComplete;
@dynamic assigningProperties;
@dynamic startTime;

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
@dynamic postProcessing;
@dynamic bytesUploaded;
@dynamic totalBytes;
@dynamic estimatedSecondsRemaining;
@dynamic uploading;
@dynamic pending;

#pragma mark Initializing and deallocating

/*
 Initializes the title-cleaning queue.
 */

+ (void) initialize {
	titleCleaningQueue = [[NSOperationQueue alloc] init];
}

/*
 You're not really supposed to override init for managed objects, but I see no
 other way I can ensure that variables are nilled out before anyone else touches
 them.
 */

- (id) init {
	if (self = [super init]) {
		kind = NULL;
		URL = NULL;
		size = NULL;
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
	return [self.URL relativePath];
}

- (NSString *) filename {
	if ([self remoteFile]) return [[self.URL relativeString] lastPathComponent];
	else return [[NSFileManager defaultManager] displayNameAtPath:self.fileSystemPath];
}

- (NSString *) kind {
	if (!kind) {
		if ([self remoteFile]) kind = [[[SUDocument kinds] objectForKey:[[self.URL relativeString] pathExtension]] retain];
		else kind = [[[SUDocument kinds] objectForKey:[self.fileSystemPath pathExtension]] retain];
		if (!kind) kind = @"document";
	}
	return kind;
}

- (NSImage *) icon {
	if ([self remoteFile]) return [[NSWorkspace sharedWorkspace] iconForFileType:[self.filename pathExtension]];
	return [[NSWorkspace sharedWorkspace] iconForFile:self.fileSystemPath];
}

- (NSNumber *) discoverability {
	if ([self.hidden boolValue]) return [NSNumber numberWithUnsignedInteger:0];
	NSUInteger disc = 1;
	if ([[NSSpellChecker sharedSpellChecker] countWordsInString:self.summary language:NULL] >= 5) disc++;
	if ([[NSSpellChecker sharedSpellChecker] countWordsInString:self.title language:NULL] >= 2) disc++;
	if (self.category) disc++;
	return [NSNumber numberWithUnsignedInteger:disc];
}

- (BOOL) pointsToActualFile {
	if ([self remoteFile]) return NO;
	return [[NSFileManager defaultManager] fileExistsAtPath:self.fileSystemPath];
}

- (BOOL) remoteFile {
	return ![self.URL isFileURL];
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

- (BOOL) postProcessing {
	return (self.uploaded && ([self.converting boolValue] || [self.assigningProperties boolValue]));
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

- (NSNumber *) bytesUploaded {
	if ([self hasSize])
		return [NSNumber numberWithUnsignedLongLong:([self.totalBytes doubleValue]*[self.progress doubleValue])];
	else return NULL;
}

- (NSNumber *) totalBytes {
	if (!size) {
		if (![self remoteFile]) {
			NSError *error = NULL;
			NSDictionary *attrs = [[NSFileManager defaultManager] attributesOfItemAtPath:self.fileSystemPath error:&error];
			if (!error) size = [attrs objectForKey:NSFileSize];
			if (!size) size = [NSNumber numberWithUnsignedLongLong:0];
		}
		else size = [NSNumber numberWithUnsignedLongLong:0];
		[size retain];
	}
	return size;
}

- (BOOL) hasSize {
	return (self.totalBytes && [self.totalBytes unsignedLongLongValue] > 0L);
}

- (NSNumber *) estimatedSecondsRemaining {
	if ([self hasSize] && self.uploading) {
		NSTimeInterval secondsSoFar = -[self.startTime timeIntervalSinceNow];
		if (secondsSoFar <= 2.0) return NULL; // give the estimate a few seconds to settle down
		double progressPerSecond = [self.progress doubleValue]/secondsSoFar;
		double totalTimeOfUpload = 1.0/progressPerSecond;
		return [NSNumber numberWithUnsignedLongLong:(unsigned long long)totalTimeOfUpload];
	}
	else return NULL;
}

- (BOOL) uploading {
	return (!self.uploaded && self.startTime != NULL);
}

- (BOOL) pending {
	return (self.startTime == NULL);
}

#pragma mark KVO

/*
 When the path changes, we need to check the title cleaner and suggest a title
 if one hasn't been added yet, and deallocate the kind so it can be recreated.
 */

- (void) observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary *)change context:(void *)context {
	if ([keyPath isEqualToString:@"path"]) {
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

+ (NSSet *) keyPathsForValuesAffectingURL {
	return [NSSet setWithObject:@"path"];
}

+ (NSSet *) keyPathsForValuesAffectingFileSystemPath {
	return [NSSet setWithObject:@"path"];
}

+ (NSSet *) keyPathsForValuesAffectingFilename {
	return [NSSet setWithObject:@"path"];
}

+ (NSSet *) keyPathsForValuesAffectingKind {
	return [NSSet setWithObject:@"path"];
}

+ (NSSet *) keyPathsForValuesAffectingIcon {
	return [NSSet setWithObject:@"path"];
}

+ (NSSet *) keyPathsForValuesAffectingDiscoverability {
	return [NSSet setWithObjects:@"title", @"summary", @"category", @"hidden", NULL];
}

+ (NSSet *) keyPathsForValuesAffectingErrorLevel {
	return [NSSet setWithObjects:@"error", @"success", @"errorIsUnrecoverable", NULL];
}

+ (NSSet *) keyPathsForValuesAffectingRemoteFile {
	return [NSSet setWithObject:@"URL"];
}

+ (NSSet *) keyPathsForValuesAffectingScribdURL {
	return [NSSet setWithObject:@"scribdID"];
}

+ (NSSet *) keyPathsForValuesAffectingUploaded {
	return [NSSet setWithObject:@"scribdID"];
}

+ (NSSet *) keyPathsForValuesAffectingPostProcessing {
	return [NSSet setWithObjects:@"scribdID", @"converting", @"assigningProperties", NULL];
}

+ (NSSet *) keyPathsForValuesAffectingBytesUploaded {
	return [NSSet setWithObjects:@"hasSize", @"progress", @"totalBytes", NULL];
}

+ (NSSet *) keyPathsForValuesAffectingTotalBytes {
	return [NSSet setWithObjects:@"remoteFile", @"path", NULL];
}

+ (NSSet *) keyPathsForValuesAffectingHasSize {
	return [NSSet setWithObject:@"totalBytes"];
}

+ (NSSet *) keyPathsForValuesAffectingEstimatedSecondsRemaining {
	return [NSSet setWithObjects:@"hasSize", @"uploading", @"startTime", @"bytesUploaded", @"totalBytes", NULL];
}

+ (NSSet *) keyPathsForValuesAffectingUploading {
	return [NSSet setWithObjects:@"startTime", @"uploaded", NULL];
}

+ (NSSet *) keyPathsForValuesAffectingPending {
	return [NSSet setWithObject:@"startTime"];
}

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

#pragma mark Creating new records

+ (SUDocument *) createFromPath:(NSString *)path inManagedObjectContext:(NSManagedObjectContext *)managedObjectContext {
	NSURL *pathURL = [[NSURL alloc] initFileURLWithPath:[path stringByStandardizingPath]];
	NSURL *absoluteURL = [pathURL absoluteURL];
	[pathURL release];
	SUDocument *existingDocument = NULL;
	if (existingDocument = [SUDocument findByPath:[absoluteURL absoluteString] inManagedObjectContext:managedObjectContext])
		[managedObjectContext deleteObject:existingDocument];
	SUDocument *file = [NSEntityDescription insertNewObjectForEntityForName:@"Document" inManagedObjectContext:managedObjectContext];
	[file setValue:[absoluteURL absoluteString] forKey:@"path"];
	if ([[NSUserDefaults standardUserDefaults] objectForKey:SUDefaultKeyUploadPrivateDefault]) [file setValue:[NSNumber numberWithBool:YES] forKey:@"hidden"];	
	return file;
}

+ (SUDocument *) createFromURLString:(NSString *)URLString inManagedObjectContext:(NSManagedObjectContext *)managedObjectContext {
	NSURL *URL = [[NSURL alloc] initWithString:URLString];
	NSURL *absoluteURL = [URL absoluteURL];
	[URL release];
	SUDocument *existingDocument = NULL;
	if (existingDocument = [SUDocument findByPath:[absoluteURL absoluteString] inManagedObjectContext:managedObjectContext])
		[managedObjectContext deleteObject:existingDocument];
	SUDocument *file = [NSEntityDescription insertNewObjectForEntityForName:@"Document" inManagedObjectContext:managedObjectContext];
	[file setValue:[absoluteURL absoluteString] forKey:@"path"];
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
