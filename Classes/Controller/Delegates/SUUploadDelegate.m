#import "SUUploadDelegate.h"

@interface SUUploadDelegate (Private)

#pragma mark Helpers

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
	}
	return self;
}

/*
 Releases retained objects.
 */

- (void) dealloc {
	[document release];
	[managedObjectContext release];
	[super dealloc];
}

#pragma mark Delegate responders (ASIHTTPRequest)

- (void) requestFinished:(ASIHTTPRequest *)request {
	NSError *error = NULL;
	NSXMLDocument *xml = [[NSXMLDocument alloc] initWithXMLString:[request dataString] options:0 error:&error];
	if (xml) {
		NSDictionary *response = [[SUScribdAPI sharedAPI] parseXML:xml error:&error];
		//TODO shouldn't use a private method here
		if (response) {
			document.success = [NSNumber numberWithBool:YES];
			document.error = NULL;
			document.scribdID = [NSNumber numberWithInteger:[[response objectForKey:@"doc_id"] integerValue]];
			[self changeSettings];
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
	
	[[NSNotificationCenter defaultCenter] postNotificationName:SUUploadCompleteNotification object:self];
	[[NSNotificationCenter defaultCenter] postNotificationName:SUUploadSucceededNotification object:self];
}

- (void) requestFailed:(ASIHTTPRequest *)request {
	NSError *outerError = [request error];
	NSError *innerError = [[outerError userInfo] objectForKey:NSUnderlyingErrorKey];
	NSDictionary *errorDict;
	if (innerError) {
		NSString *description = [[NSString alloc] initWithFormat:@"A problem prevented the upload from completing: %@", [outerError localizedDescription]];
		NSString *recoverySuggestion = [[NSString alloc] initWithFormat:@"The underlying error was: %@", [innerError localizedDescription]];
		errorDict = [[NSDictionary alloc] initWithObjectsAndKeys:
					 description, NSLocalizedDescriptionKey,
					 recoverySuggestion, NSLocalizedRecoverySuggestionErrorKey,
					 NULL];
		[description release];
		[recoverySuggestion release];
	}
	else {
		NSString *description = [[NSString alloc] initWithFormat:@"A problem prevented the upload from completing: %@", [outerError localizedDescription]];
		errorDict = [[NSDictionary alloc] initWithObjectsAndKeys:
					 description, NSLocalizedDescriptionKey,
					 @"No additional information was provided.", NSLocalizedRecoverySuggestionErrorKey,
					 NULL];
		[description release];
	}
	NSError *error = [NSError errorWithDomain:SUScribdAPIErrorDomain code:SUErrorCodeUploadFailed userInfo:errorDict];
	[errorDict release];
	document.success = [NSNumber numberWithBool:NO];
	document.error = [NSArchiver archivedDataWithRootObject:error];
	document.errorIsUnrecoverable = [NSNumber numberWithBool:YES];
	
	[[NSNotificationCenter defaultCenter] postNotificationName:SUUploadCompleteNotification object:self];
	[[NSNotificationCenter defaultCenter] postNotificationName:SUUploadFailedNotification object:self];
}

#pragma mark Delegate responders (other)

/*
 Handles the dismissal of the alert by releasing the object.
 */

- (void) uploadAlertDidEnd:(NSAlert *)alert returnCode:(int)returnCode contextInfo:(void *)contextInfo {
	[alert release];
};

#pragma mark NSProgressBar emulation

/*
 Compatibility method for the ASIHTTPRequest API (mocks NSProgressBar).
 */

- (void) setDoubleValue:(double)value {
	progress = value;
	document.progress = [NSNumber numberWithDouble:progress/progressMax];
}

/*
 Compatibility method for the ASIHTTPRequest API (mocks NSProgressBar).
 */

- (void) incrementBy:(double)amount {
	progress += amount;
	document.progress = [NSNumber numberWithDouble:progress/progressMax];
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
	NSMutableDictionary *parameters = [[NSMutableDictionary alloc] init];
	[parameters setObject:[SUSessionHelper sessionHelper].key forKey:@"session_key"];
	[parameters setObject:document.scribdID forKey:@"doc_ids"];
	if (document.title && ![document.title isBlank]) [parameters setObject:document.title forKey:@"title"];
	if (document.summary && ![document.summary isBlank]) [parameters setObject:document.summary forKey:@"description"];
	if (document.tags && ![document.tags isBlank]) [parameters setObject:document.tags forKey:@"tags"];
	if (document.category) {
		if (document.category.parent) {
			[parameters setObject:document.category.name forKey:@"subcategory"];
			[parameters setObject:document.category.parent.name forKey:@"category"];
		}
		else [parameters setObject:document.category.name forKey:@"category"];
	}
	
	NSError *error = NULL;
	[[SUScribdAPI sharedAPI] callApiMethod:@"docs.changeSettings" parameters:parameters error:&error];
	[parameters release];
	
	if (error) {
		error = [error addMessagesForAction:SUChangeSettingsAction title:document.filename];
		document.error = [NSArchiver archivedDataWithRootObject:error];
		document.errorIsUnrecoverable = [NSNumber numberWithBool:NO];
		document.success = [NSNumber numberWithBool:NO];
	}
}

@end
