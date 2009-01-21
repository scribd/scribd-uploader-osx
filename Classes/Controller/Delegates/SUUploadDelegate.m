#import "SUUploadDelegate.h"

@interface SUUploadDelegate (Private)

- (void) changeSettings;

@end

@implementation SUUploadDelegate

@synthesize uploadWindow;
@synthesize uploadCompleteSheet;
@synthesize uploadCompleteSheetDelegate;

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
		uploadCompleteSheet = NULL;
		uploadCompleteSheetDelegate = NULL;
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
	if (uploadCompleteSheet) [uploadCompleteSheet release];
	if (uploadCompleteSheetDelegate) [uploadCompleteSheetDelegate release];
	[super dealloc];
}

- (void) requestFinished:(ASIHTTPRequest *)request {
	uploader.currentlyUploadingCount--;
	
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
	}
	else document.success = [NSNumber numberWithBool:NO];
	if (error) {
		[error addMessagesForAction:SUUploadAction sender:self];
		document.error = [NSArchiver archivedDataWithRootObject:error];
		document.errorIsUnrecoverable = [NSNumber numberWithBool:YES];
	}
	
	if ([uploader uploadComplete]) {
		if (![[NSApplication sharedApplication] isActive])
			[GrowlApplicationBridge notifyWithTitle:@"All uploads have completed."
										description:@"Your files are now ready to be viewed on Scribd.com."
								   notificationName:@"All uploads complete"
										   iconData:NULL
										   priority:0
										   isSticky:NO 
									   clickContext:NULL];
		[[NSSound soundNamed:@"Upload Complete"] play];
		[[NSApplication sharedApplication] beginSheet:uploadCompleteSheet modalForWindow:uploadWindow modalDelegate:uploadCompleteSheetDelegate didEndSelector:@selector(sheetDidEnd:returnCode:contextInfo:) contextInfo:NULL];
	}
}

/*
 Handles the dismissal of the alert by releasing the object.
 */

- (void) uploadAlertDidEnd:(NSAlert *)alert returnCode:(int)returnCode contextInfo:(void *)contextInfo {
	[alert release];
};

- (void) requestFailed:(ASIHTTPRequest *)request {
	uploader.currentlyUploadingCount--;
	
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
	document.errorIsUnrecoverable = [NSNumber numberWithBool:YES];
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

@implementation SUUploadDelegate (Private)

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
		[error addMessagesForAction:SUChangeSettingsAction title:document.filename];
		document.error = [NSArchiver archivedDataWithRootObject:error];
		document.errorIsUnrecoverable = [NSNumber numberWithBool:NO];
		document.success = [NSNumber numberWithBool:NO];
	}
}

@end
