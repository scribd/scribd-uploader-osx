#import "SUUploadDelegate.h"

@interface SUUploadDelegate (Private)

#pragma mark Helpers

/*
 Creates an NSTimer that periodically checks the conversion status and updates
 the document's attributes as appropriate.
 */

- (void) trackConversionStatus;

/*
 Sends a docs.changeSettings call to the server, setting the document's
 metadata. This method is intended to be run in a thread.
 */

- (void) changeSettings;

@end

#pragma mark -

@implementation SUUploadDelegate

#pragma mark Initializing and deallocating

/*
 Prevent initialization without a document.
 */

- (id) init {
	return NULL;
}

- (id) initWithDocument:(SUDocument *)doc inManagedObjectContext:(NSManagedObjectContext *)context {
	if (self = [super init]) {
		document = [doc retain];
		progress = 0.0;
		progressMax = 1.0;
		managedObjectContext = [context retain];
		
		dateFormatter = [[NSDateFormatter alloc] init];
		[dateFormatter setDateFormat:@"MM/dd/yyyy"];
	}
	return self;
}

/*
 Releases retained objects.
 */

- (void) dealloc {
	[document release];
	[managedObjectContext release];
	[dateFormatter release];
	[super dealloc];
}

#pragma mark Delegate responders (ASIHTTPRequest)

- (void) requestFinished:(ASIHTTPRequest *)request {
	NSError *error = NULL;
	NSXMLDocument *xml = [[NSXMLDocument alloc] initWithXMLString:[request responseString] options:0 error:&error];
	if (xml) {
		NSDictionary *response = [[SUScribdAPI sharedAPI] parseResponseXML:xml error:&error];
		if (response) {
			document.success = [NSNumber numberWithBool:YES];
			document.error = NULL;
			document.converting = [NSNumber numberWithBool:YES];
			document.scribdID = [NSNumber numberWithInteger:[[response objectForKey:@"doc_id"] integerValue]];
			[NSThread detachNewThreadSelector:@selector(changeSettings) toTarget:self withObject:NULL];
			[self trackConversionStatus];
		}
		else document.success = [NSNumber numberWithBool:NO];
		[xml release];
	}
	else document.success = [NSNumber numberWithBool:NO];
	if (error) {
		error = [error addMessagesForAction:SUUploadAction sender:self];
		document.error = [NSArchiver archivedDataWithRootObject:error];
		document.errorIsUnrecoverable = [NSNumber numberWithBool:YES];
	}
	
	[[NSNotificationCenter defaultCenter] postNotificationName:SUUploadDidCompleteNotification object:self];
	[[NSNotificationCenter defaultCenter] postNotificationName:SUUploadDidSucceedNotification object:self];
}

- (void) requestFailed:(ASIHTTPRequest *)request {
	NSError *outerError = [request error];
	NSError *innerError = [[outerError userInfo] objectForKey:NSUnderlyingErrorKey];
	NSDictionary *errorDict;
	if (innerError) {
		NSString *description = [[NSString alloc] initWithFormat:NSLocalizedString(@"A problem prevented the upload from completing: %@", NULL), [outerError localizedDescription]];
		NSString *recoverySuggestion = [[NSString alloc] initWithFormat:NSLocalizedString(@"The underlying error was: %@", NULL), [innerError localizedDescription]];
		errorDict = [[NSDictionary alloc] initWithObjectsAndKeys:
					 description, NSLocalizedDescriptionKey,
					 recoverySuggestion, NSLocalizedRecoverySuggestionErrorKey,
					 NULL];
		[description release];
		[recoverySuggestion release];
	}
	else {
		NSString *description = [[NSString alloc] initWithFormat:NSLocalizedString(@"A problem prevented the upload from completing: %@", NULL), [outerError localizedDescription]];
		errorDict = [[NSDictionary alloc] initWithObjectsAndKeys:
					 description, NSLocalizedDescriptionKey,
					 NSLocalizedString(@"No additional information was provided.", @"about the error"), NSLocalizedRecoverySuggestionErrorKey,
					 NULL];
		[description release];
	}
	NSError *error = [NSError errorWithDomain:SUErrorDomain code:SUErrorCodeUploadFailed userInfo:errorDict];
	[errorDict release];
	document.success = [NSNumber numberWithBool:NO];
	document.error = [NSArchiver archivedDataWithRootObject:error];
	document.errorIsUnrecoverable = [NSNumber numberWithBool:YES];
	
	[[NSNotificationCenter defaultCenter] postNotificationName:SUUploadDidCompleteNotification object:self];
	[[NSNotificationCenter defaultCenter] postNotificationName:SUUploadDidFailNotification object:self];
}

#pragma mark NSProgressBar emulation

/*
 Compatibility method for the ASIHTTPRequest API (mocks NSProgressBar).
 */

- (void) setDoubleValue:(double)value {
	progress = value;
	document.progress = [NSNumber numberWithDouble:progress/progressMax];
	if (document.startTime == NULL) document.startTime = [NSDate date]; // start the timer when we get our first data chunk
}

/*
 Compatibility method for the ASIHTTPRequest API (mocks NSProgressBar).
 */

- (void) incrementBy:(double)amount {
	progress += amount;
	document.progress = [NSNumber numberWithDouble:progress/progressMax];
	if (document.startTime == NULL) document.startTime = [NSDate date]; // start the timer when we get our first data chunk
}

/*
 Compatibility method for the ASIHTTPRequest API (mocks NSProgressBar).
 */

- (void) setMaxValue:(double)newMax {
	progressMax = newMax;
}

@end

#pragma mark -

@implementation SUUploadDelegate (Private)

#pragma mark Helpers

- (void) changeSettings {
	NSAutoreleasePool *pool = [[NSAutoreleasePool alloc] init];
	document.assigningProperties = [NSNumber numberWithBool:YES];
	
	NSMutableDictionary *parameters = [[NSMutableDictionary alloc] init];
	[parameters setObject:[SUSessionHelper sessionHelper].key forKey:@"session_key"];
	[parameters setObject:document.scribdID forKey:@"doc_ids"];
	if (document.title && ![document.title isBlank]) [parameters setObject:document.title forKey:@"title"];
	if (document.summary && ![document.summary isBlank]) [parameters setObject:document.summary forKey:@"description"];
	if (document.tags && ![document.tags isBlank]) [parameters setObject:document.tags forKey:@"tags"];
	if (document.license) [parameters setObject:document.license forKey:@"license"];
	if (document.author && ![document.author isBlank]) [parameters setObject:document.author forKey:@"author"];
	if (document.publisher && ![document.publisher isBlank]) [parameters setObject:document.publisher forKey:@"publisher"];
	if (document.edition && ![document.edition isBlank]) [parameters setObject:document.edition forKey:@"edition"];
	if (document.datePublished) [parameters setObject:[dateFormatter stringFromDate:document.datePublished] forKey:@"when_published"];
	if (document.category) {
		if (document.category.parent) {
			[parameters setObject:document.category.name forKey:@"subcategory"];
			[parameters setObject:document.category.parent.name forKey:@"category"];
		}
		else [parameters setObject:document.category.name forKey:@"category"];
	}
	
	NSError *error = NULL;
	[[SUScribdAPI sharedAPI] callAPIMethod:[[SUAPIHelper helper].settings objectForKey:@"APIChangeSettingsMethod"] parameters:parameters error:&error];
	[parameters release];
	
	if (error) {
		error = [error addMessagesForAction:SUChangeSettingsAction title:document.filename];
		document.error = [NSArchiver archivedDataWithRootObject:error];
		document.errorIsUnrecoverable = [NSNumber numberWithBool:NO];
		document.success = [NSNumber numberWithBool:NO];
	}
	
	document.assigningProperties = [NSNumber numberWithBool:NO];
	[pool release];
}

- (void) trackConversionStatus {
	[[[SUConversionStatusTracker alloc] initWithDocument:document] autorelease];
}

@end
