#import "SUSessionHelper.h"

static SUSessionHelper *sharedSessionHelper = NULL;

@interface SUSessionHelper (Private)

#pragma mark Pseudo-properties

/*
 Returns the keychain item used to store the Scribd.com session key.
 */

- (EMGenericKeychainItem *) keychainItem;

@end

#pragma mark -

@implementation SUSessionHelper

#pragma mark Properties

@dynamic key;
@dynamic username;

#pragma mark Working with the singleton instance

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

#pragma mark Required setup methods

- (void) setupForLaunch {
	if (self.username && ![self keychainItem]) [[NSUserDefaults standardUserDefaults] removeObjectForKey:SUDefaultKeySessionUsername];
}

#pragma mark Dynamic properties

- (NSString *) key {
	return [[self keychainItem] password];
}

- (NSString *) username {
	return [[NSUserDefaults standardUserDefaults] stringForKey:SUDefaultKeySessionUsername];
}

#pragma mark Getting and setting the session key

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

#pragma mark -

@implementation SUSessionHelper (Private)

#pragma mark Pseudo-properties

- (EMGenericKeychainItem *) keychainItem {
	return [[EMKeychainProxy sharedProxy] genericKeychainItemForService:@"Scribd Uploader session key" withUsername:self.username];
}

@end
