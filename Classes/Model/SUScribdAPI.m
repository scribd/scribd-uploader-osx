#import "SUScribdAPI.h"

static SUScribdAPI *sharedAPI = NULL;
static NSDictionary *settings = NULL;

@interface SUScribdAPI (Private)

/*
 Adds a Category entity for every child of the given node to the managed object
 context, given a proxy set for the parent.
 */

- (void) setChildren:(NSMutableSet *)children ofNode:(NSXMLElement *)element managedObjectContext:(NSManagedObjectContext *)managedObjectContext;

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
	NSDictionary *appDefaults = [[NSDictionary alloc] initWithObject:[NSNumber numberWithInteger:4] forKey:@"SUMaximumSimultaneousUploads"];
	[defaults registerDefaults:appDefaults];
	[appDefaults release];
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
	NSError *error = NULL;
	NSString *response = [[NSString alloc] initWithContentsOfURL:url encoding:NSUTF8StringEncoding error:&error];
	[url release];
	if (error) return NULL;
	
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
	NSError *error = NULL;
	NSString *response = [[NSString alloc] initWithContentsOfURL:url encoding:NSUTF8StringEncoding error:&error];
	[url release];
	if (error) return NULL;
	
	if ([response isEqualToString:filename]) {
		[response release];
		return NULL;
	}
	else return [response autorelease];
}

- (void) loadCategoriesIntoManagedObjectContext:(NSManagedObjectContext *)managedObjectContext {
	// download category XML from scribd
	NSURL *url = [[NSURL alloc] initWithString:[[self settings] objectForKey:@"CategoriesURL"]];
	NSError *error = NULL;
	NSXMLDocument *xml = [[NSXMLDocument alloc] initWithContentsOfURL:url options:NSXMLDocumentTidyXML error:&error];
	[url release];
	if (error) return;
	
	// delete all categories
	NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] init];
	[fetchRequest setEntity:[NSEntityDescription entityForName:@"Category" inManagedObjectContext:managedObjectContext]];
	NSArray *categories = [managedObjectContext executeFetchRequest:fetchRequest error:&error];
	[fetchRequest release];
	if (error) return;
	for (SUCategory *category in categories) [managedObjectContext deleteObject:category];
	
	// load in new categories
	for (NSXMLElement *element in [[xml rootElement] children]) {
		SUCategory *category = [NSEntityDescription insertNewObjectForEntityForName:@"Category" inManagedObjectContext:managedObjectContext];
		category.name = [[element attributeForName:@"name"] stringValue];
		category.position = [NSNumber numberWithUnsignedInteger:[element index]];
		NSMutableSet *children = [category mutableSetValueForKey:@"children"];
		[self setChildren:children ofNode:element managedObjectContext:managedObjectContext];
	}
	
	[xml release];
}

@end

@implementation SUScribdAPI (Private)

- (void) setChildren:(NSMutableSet *)children ofNode:(NSXMLElement *)element managedObjectContext:(NSManagedObjectContext *)managedObjectContext {
	for (NSXMLElement *child in [element children]) {
		SUCategory *category = [NSEntityDescription insertNewObjectForEntityForName:@"Category" inManagedObjectContext:managedObjectContext];
		category.name = [[child attributeForName:@"name"] stringValue];
		category.position = [NSNumber numberWithUnsignedInteger:[child index]];
		NSMutableSet *grandkids = [category mutableSetValueForKey:@"children"];
		[self setChildren:grandkids ofNode:child managedObjectContext:managedObjectContext];
		[children addObject:category];
	}
}

- (NSDictionary *) settings {
	if (!settings) settings = [[NSDictionary alloc] initWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"ScribdAPI" ofType:@"plist"]];
	return settings;
}

- (NSURL *) apiUrlWithMethod:(NSString *)method parameters:(NSDictionary *)parameters {
	NSMutableDictionary *urlParameters = [[NSMutableDictionary alloc] initWithDictionary:parameters];
	[urlParameters setObject:[[self settings] objectForKey:@"APIKey"] forKey:@"api_key"];
	[urlParameters setObject:[[self settings] objectForKey:@"APISecret"] forKey:@"api_sig"];
	[urlParameters setObject:method forKey:@"method"];
	
	NSMutableArray *urlParameterSubstrings = [[NSMutableArray alloc] initWithCapacity:[parameters count]];
	for (NSString *key in urlParameters) {
		id value = [urlParameters objectForKey:key];
		NSString *valueString;
		if ([value isKindOfClass:[NSString class]]) valueString = value;
		else valueString = [value stringValue];
		
		NSString *paramName = [key stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
		NSString *paramValue = (NSString *)CFURLCreateStringByAddingPercentEscapes(kCFAllocatorDefault,
																	   (CFStringRef)valueString,
																	   NULL,
																	   (CFStringRef)@"&",
																	   NSUTF8StringEncoding);
		[urlParameterSubstrings addObject:[NSString stringWithFormat:@"%@=%@", paramName, paramValue]];
		[paramValue release];
	}
	
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
			errorInfo = [[NSDictionary alloc] initWithObject:[[errorNode attributeForName:@"message"] stringValue] forKey:NSLocalizedFailureReasonErrorKey];
		}
		else {
			errorCode = -1;
			errorInfo = [[NSDictionary alloc] initWithObject:@"Improper format" forKey:NSLocalizedFailureReasonErrorKey];
		}
		*error = [NSError errorWithDomain:SUScribdAPIErrorDomain code:errorCode userInfo:errorInfo];
		[errorInfo release];
		return NULL;
	}
}

@end
