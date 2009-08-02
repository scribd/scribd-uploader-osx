/*!
 @class SUSessionHelper
 @abstract This singleton class has methods for working with the Scribd.com
 session.
 @discussion Scribd session information is stored in the shared user defaults
 object. It is a session key linked with the login of the Scribd.com user owning
 the session.
 
 The @link setupForLaunch setupForLaunch @/link method should be called when the
 application first starts up.
 */

@interface SUSessionHelper : NSObject {
	
}

#pragma mark Properties

/*!
 @property key
 @abstract The Scribd session key stored in the user defaults.
 */

@property (readonly) NSString *key;

/*!
 @property
 @abstract The login or email assocated with the session key stored in the user
 defaults.
 */

@property (readonly) NSString *username;

#pragma mark Working with the singleton instance

/*!
 @method sessionHelper
 @abstract Returns the singleton instance.
 @result The singleton instance.
 */

+ (SUSessionHelper *) sessionHelper;

#pragma mark Getting and setting the session key

/*!
 @method storeSessionKey:username:
 @abstract Stores the session key returned by Scribd and the login or email
 associated with that key in the user defaults store.
 @param key The session key.
 @param username The login or email associated with the session.
 */

- (void) storeSessionKey:(NSString *)key username:(NSString *)username;

/*!
 @method sessionStored
 @abstract Returns YES if session information is stored for the next upload; NO
 if not.
 */

- (BOOL) sessionStored;

#pragma mark Required setup methods

/*!
 @method setupForLaunch
 @abstract This method should be called when the application first launches. It
 clears out the session username if the session keychain item has been deleted.
 */

- (void) setupForLaunch;

@end