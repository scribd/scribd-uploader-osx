#import "SUAPIHelper.h"

static SUAPIHelper *helper = NULL;

@implementation SUAPIHelper

#pragma mark Properties

@synthesize settings;

#pragma mark Initializing and deallocating

/*
 Initializes local variables.
 */

- (id) init {
	if (self = [super init]) {
		settings = [[NSDictionary alloc] initWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"ScribdAPI" ofType:@"plist"]];
	}
	return self;
}

/*
 Releases local variables.
 */

- (void) dealloc {
	[settings release];
	[super dealloc];
}

#pragma mark Working with the singleton instance

+ (SUAPIHelper *) helper {
	@synchronized(self) {
		if (helper == NULL) [[self alloc] init];
	}
	return helper;
}

/*
 Ensures that someone else cannot directly allocate space for another instance.
 */

+ (id) allocWithZone:(NSZone *)zone {
	@synchronized(self) {
		if (helper == NULL) {
			helper = [super allocWithZone:zone];
			return helper;
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

@end
