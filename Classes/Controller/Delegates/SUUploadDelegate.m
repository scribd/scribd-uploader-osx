#import "SUUploadDelegate.h"

@implementation SUUploadDelegate

@synthesize uploadWindow;

/*
 Prevent initialization without a document.
 */

- (id) init {
	return NULL;
}

- (id) initWithDocument:(SUDocument *)doc inManagedObjectContext:(NSManagedObjectContext *)context fromUploader:(SUUploadHelper *)caller {
	if (self = [super init]) {
		document = [doc retain];
		progress = 0.0;
		progressMax = 1.0;
		uploadWindow = NULL;
		managedObjectContext = [context retain];
		uploader = [caller retain];
	}
	return self;
}

/*
 Releases retained objects.
 */

- (void) dealloc {
	[document release];
	[managedObjectContext release];
	[uploader release];
	if (uploadWindow) [uploadWindow release];
	[super dealloc];
}

- (void) requestFinished:(ASIHTTPRequest *)request {
	[uploader setValue:[NSNumber numberWithInt:[[uploader valueForKey:@"currentlyUploadingCount"] intValue] - 1] forKey:@"currentlyUploadingCount"];
	if ([[uploader valueForKey:@"currentlyUploadingCount"] intValue] == 0)
		[[NSSound soundNamed:@"Upload Complete"] play];
	
	NSError *error = NULL;
	NSXMLDocument *xml = [[NSXMLDocument alloc] initWithXMLString:[request dataString] options:0 error:&error];
	if (xml) {
		NSDictionary *response = [[SUScribdAPI sharedAPI] parseXML:xml error:&error];
		//TODO shouldn't use a private method here
		if (response) {
			//[managedObjectContext deleteObject:document];
			document.success = [NSNumber numberWithBool:YES];
			document.error = NULL;
			return;
		}
	}
	[error addMessagesForAction:SUUploadAction sender:self];
	document.error = [NSArchiver archivedDataWithRootObject:error];
	document.success = [NSNumber numberWithBool:NO];
}

/*
 Handles the dismissal of the alert by releasing the object.
 */

- (void) uploadAlertDidEnd:(NSAlert *)alert returnCode:(int)returnCode contextInfo:(void *)contextInfo {
	[alert release];
};

- (void) requestFailed:(ASIHTTPRequest *)request {
	[uploader setValue:[NSNumber numberWithInt:[[uploader valueForKey:@"currentlyUploadingCount"] intValue] - 1] forKey:@"currentlyUploadingCount"];
	
	NSError *outerError = [request error];
	NSError *innerError = [[outerError userInfo] objectForKey:NSUnderlyingErrorKey];
	NSDictionary *errorDict;
	if (innerError) {
		errorDict = [NSDictionary dictionaryWithObjectsAndKeys:
					 [NSString stringWithFormat:@"A problem prevented the upload from completing: %@", [outerError localizedDescription]], NSLocalizedDescriptionKey,
					 [NSString stringWithFormat:@"The underlying error was: %@", [innerError localizedDescription]], NSLocalizedRecoverySuggestionErrorKey,
					 NULL];
	} else {
		errorDict = [NSDictionary dictionaryWithObjectsAndKeys:
					 [NSString stringWithFormat:@"A problem prevented the upload from completing: %@", [outerError localizedDescription]], NSLocalizedDescriptionKey,
					 @"No additional information was provided.", NSLocalizedRecoverySuggestionErrorKey,
					 NULL];
	}
	NSError *error = [NSError errorWithDomain:SUScribdAPIErrorDomain code:SUErrorCodeUploadFailed userInfo:errorDict];
	document.success = [NSNumber numberWithBool:NO];
	document.error = [NSArchiver archivedDataWithRootObject:error];
}

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
