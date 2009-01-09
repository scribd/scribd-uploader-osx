#import "SUSessionHelper.h"

static SUSessionHelper *sharedSessionHelper = NULL;

@implementation SUSessionHelper

@dynamic key;
@dynamic username;

+ (SUSessionHelper *) sessionHelper {
	@synchronized(self) {
		if (sharedSessionHelper == NULL) [[self alloc] init];
	}
	return sharedSessionHelper;
}

/*
 Ensures that someone else cannot directly allocate space for another instance.
 */

+ (id) allocWithZone:(NSZone *)zone {
	@synchronized(self) {
		if (sharedSessionHelper == NULL) {
			sharedSessionHelper = [super allocWithZone:zone];
			return sharedSessionHelper;
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
 Returns the session key stored in the user defaults.
 */

- (NSString *) key {
	return [[NSUserDefaults standardUserDefaults] stringForKey:SUDefaultKeySessionKey];
}

/*
 Returns the session username stored in the user defaults.
 */

- (NSString *) username {
	return [[NSUserDefaults standardUserDefaults] stringForKey:SUDefaultKeySessionUsername];
}

- (void) storeSessionKey:(NSString *)key username:(NSString *)username {
	[[NSUserDefaults standardUserDefaults] setObject:key forKey:SUDefaultKeySessionKey];
	[[NSUserDefaults standardUserDefaults] setObject:username forKey:SUDefaultKeySessionUsername];
}

- (void) clearSession {
	[[NSUserDefaults standardUserDefaults] setObject:NULL forKey:SUDefaultKeySessionKey];
	[[NSUserDefaults standardUserDefaults] setObject:NULL forKey:SUDefaultKeySessionUsername];
}

- (BOOL) sessionStored {
	return [[NSUserDefaults standardUserDefaults] objectForKey:SUDefaultKeySessionKey] != NULL;
}

@end
