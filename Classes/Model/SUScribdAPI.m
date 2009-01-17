#import "SUScribdAPI.h"

static SUScribdAPI *sharedAPI;

@interface SUScribdAPI (Private)

/*
 Returns settings in the ScribdAPI.plist resource.
 */

- (NSDictionary *) settings;

/*
 Returns the formatted Scribd API url for a set of parameters and an API method.
 */

- (NSURL *) apiUrlWithMethod:(NSString *)method parameters:(NSDictionary *)parameters;

/*
 Converts a Scribd XML response to an NSDictionary and constructs an NSError if
 necessary. Returns NULL if the XML cannot be parsed.
 */

- (NSDictionary *) parseXML:(NSXMLDocument *)xml error:(NSError **)error;

@end

@implementation SUScribdAPI

/*
 Sets preference defaults.
 */

+ (void) initialize {
	NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
	NSDictionary *appDefaults = [NSDictionary dictionaryWithObject:[NSNumber numberWithInteger:4] forKey:@"SUMaximumSimultaneousUploads"];
	[defaults registerDefaults:appDefaults];
}

+ (SUScribdAPI *) sharedAPI {
	@synchronized(self) {
		if (sharedAPI == NULL) [[self alloc] init];
	}
	return sharedAPI;
}

/*
 Ensures that someone else cannot directly allocate space for another instance.
 */

+ (id) allocWithZone:(NSZone *)zone {
	@synchronized(self) {
		if (sharedAPI == NULL) {
			sharedAPI = [super allocWithZone:zone];
			return sharedAPI;
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

/*
 Initializes local variables.
 */

- (id) init {
	if (self = [super init]) {
		uploadQueue = [[NSOperationQueue alloc] init];
		[uploadQueue setMaxConcurrentOperationCount:[[NSUserDefaults standardUserDefaults] integerForKey:@"SUMaximumSimultaneousUploads"]];
	}
	return self;
}

/*
 Releases local variables.
 */

- (void) dealloc {
	[uploadQueue release];
	[super dealloc];
}

- (NSDictionary *) callApiMethod:(NSString *)method parameters:(NSDictionary *)parameters error:(NSError **)error {
	NSURL *url = [self apiUrlWithMethod:method parameters:parameters];
	NSError *parseError = NULL;
	NSXMLDocument *xml = [[NSXMLDocument alloc] initWithContentsOfURL:url options:NSXMLDocumentTidyXML error:&parseError];
	
	if (parseError) {
		*error = parseError;
		return NULL;
	}
	
	NSDictionary *results = [self parseXML:xml error:error];
	[xml release];
	return results;
}

- (void) apiSubmitFile:(SUDocument *)file apiMethod:(NSString *)method parameters:(NSDictionary *)parameters delegate:(id)delegate {
	NSURL *url = [self apiUrlWithMethod:method parameters:parameters];
	ASIFormDataRequest *request = [[ASIFormDataRequest alloc] initWithURL:url];
	
	[request setDelegate:delegate];
	[request setUploadProgressDelegate:delegate];
	//[request setDownloadProgressDelegate:delegate];
	
	[request setFile:file.path forKey:@"file"];
	for (NSString *key in parameters) [request setPostValue:[parameters objectForKey:key] forKey:key];
	
	NSOperation *uploadOperation = [[NSInvocationOperation alloc] initWithTarget:[request autorelease] selector:@selector(start) object:NULL];
	[uploadQueue addOperation:uploadOperation];
}

- (NSArray *) autocompletionsForSubstring:(NSString *)substring {
	NSURL *url = [[NSURL alloc] initWithString:[NSString stringWithFormat:[[self settings] objectForKey:@"TagsURL"], [substring stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding]]];
	NSString *response = [[NSString alloc] initWithContentsOfURL:url];
	[url release];
	
	if ([response isEmpty]) {
		[response release];
		return [NSArray array];
	}
	
	NSArray *lines = [response componentsSeparatedByCharactersInSet:[NSCharacterSet newlineCharacterSet]];
	NSMutableDictionary *tagsByFrequency = [[NSMutableDictionary alloc] initWithCapacity:[lines count]];
	for (NSString *line in lines) {
		NSArray *elements = [line componentsSeparatedByString:@"|"];
		NSString *tag = [elements objectAtIndex:0];
		NSUInteger freq = [[elements objectAtIndex:1] integerValue];
		[tagsByFrequency setObject:[NSNumber numberWithUnsignedInteger:freq] forKey:tag];
	}
	
	NSArray *tags = [tagsByFrequency keysSortedByValueUsingSelector:@selector(compare:)];
	
	[response release];
	[tagsByFrequency release];
	
	return [tags reversedArray];
}

- (NSString *) titleForFilename:(NSString *)filename {
	NSURL *url = [[NSURL alloc] initWithString:[NSString stringWithFormat:[[self settings] objectForKey:@"TitleCleanURL"], [filename stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding]]];
	NSString *response = [[NSString alloc] initWithContentsOfURL:url];
	[url release];
	
	if ([response isEqualToString:filename]) {
		[response release];
		return NULL;
	}
	else return [response autorelease];
}

@end

@implementation SUScribdAPI (Private)

- (NSDictionary *) settings {
	return [NSDictionary dictionaryWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"ScribdAPI" ofType:@"plist"]];
}

- (NSURL *) apiUrlWithMethod:(NSString *)method parameters:(NSDictionary *)parameters {
	NSMutableDictionary *urlParameters = [[NSMutableDictionary alloc] initWithDictionary:parameters];
	[urlParameters setObject:[[self settings] objectForKey:@"APIKey"] forKey:@"api_key"];
	[urlParameters setObject:[[self settings] objectForKey:@"APISecret"] forKey:@"api_sig"];
	[urlParameters setObject:method forKey:@"method"];
	
	NSMutableArray *urlParameterSubstrings = [[NSMutableArray alloc] initWithCapacity:[parameters count]];
	for (NSString *key in urlParameters) [urlParameterSubstrings addObject:[[NSString stringWithFormat:@"%@=%@", key, [urlParameters objectForKey:key]] stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding]];
	
	NSMutableString *urlString = [[NSMutableString alloc] initWithString:[[self settings] objectForKey:@"BaseURL"]];
	[urlString appendString:[urlParameterSubstrings componentsJoinedByString:@"&"]];
	NSURL *url = [NSURL URLWithString:urlString];
	
	[urlString release];
	[urlParameters release];
	[urlParameterSubstrings release];
	
	return url;
}

- (NSDictionary *) parseXML:(NSXMLDocument *)xml error:(NSError **)error {
	if ([[[[xml rootElement] attributeForName:@"stat"] stringValue] isEqualToString:@"ok"]) {
		NSMutableDictionary *properties = [[NSMutableDictionary alloc] initWithCapacity:[[xml rootElement] childCount]];
		for (NSXMLElement *child in [[xml rootElement] children]) {
			[properties setObject:[child stringValue] forKey:[child name]];
		}
		return [properties autorelease];
	} else {
		int errorCode;
		NSDictionary *errorInfo;
		
		NSXMLElement *errorNode = [[[xml rootElement] elementsForName:@"error"] objectAtIndex:0];
		if (errorNode) {
			errorCode = [[[errorNode attributeForName:@"code"] stringValue] integerValue];
			errorInfo = [NSDictionary dictionaryWithObject:[[errorNode attributeForName:@"message"] stringValue] forKey:NSLocalizedFailureReasonErrorKey];
		}
		else {
			errorCode = -1;
			errorInfo = [NSDictionary dictionaryWithObject:@"Improper format" forKey:NSLocalizedFailureReasonErrorKey];
		}
		*error = [NSError errorWithDomain:SUScribdAPIErrorDomain code:errorCode userInfo:errorInfo];
		return NULL;
	}
}

@end
