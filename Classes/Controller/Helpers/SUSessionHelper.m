#import "SUSessionHelper.h"

static SUSessionHelper *sharedSessionHelper = NULL;

@interface SUSessionHelper (Private)

/*
 Returns the keychain item used to store the Scribd.com session key.
 */

- (EMGenericKeychainItem *) keychainItem;

@end

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

- (void) setupForLaunch {
	if (self.username && ![self keychainItem]) [[NSUserDefaults standardUserDefaults] removeObjectForKey:SUDefaultKeySessionUsername];
}

- (NSString *) key {
	return [[self keychainItem] password];
}

- (NSString *) username {
	return [[NSUserDefaults standardUserDefaults] stringForKey:SUDefaultKeySessionUsername];
}

- (void) storeSessionKey:(NSString *)key username:(NSString *)username {
	EMGenericKeychainItem *keychainItem = [self keychainItem];
	if (self.username && keychainItem) {
		[keychainItem setUsername:username];
		[keychainItem setPassword:key];
	}
	else
		[[EMKeychainProxy sharedProxy] addGenericKeychainItemForService:@"Scribd Uploader session key" withUsername:username password:key];
	
	[[NSUserDefaults standardUserDefaults] setObject:username forKey:SUDefaultKeySessionUsername];
}

- (BOOL) sessionStored {
	return [self keychainItem] != NULL;
}

@end

@implementation SUSessionHelper (Private)

- (EMGenericKeychainItem *) keychainItem {
	return [[EMKeychainProxy sharedProxy] genericKeychainItemForService:@"Scribd Uploader session key" withUsername:self.username];
}

@end
