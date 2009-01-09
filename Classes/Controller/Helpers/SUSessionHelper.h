#import <Cocoa/Cocoa.h>

#import "SUConstants.h"

/*!
 @class SUSessionHelper
 @abstract Singleton class with helper methods for managing Scribd sessions.
 @discussion Scribd session information is stored in the shared user defaults
 object.
 */

@interface SUSessionHelper : NSObject {

}

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

/*!
 @method sessionHelper
 @abstract Returns the singleton instance.
 @result The singleton instance.
 */

+ (SUSessionHelper *) sessionHelper;

/*!
 @method storeSessionKey:username:
 @abstract Stores the session key returned by Scribd and the login or email
 associated with that key in the user defaults store.
 @param key The session key.
 @param username The login or email associated with the session.
 */

- (void) storeSessionKey:(NSString *)key username:(NSString *)username;

/*!
 @method clearSession
 @abstract Removes the session information from the user defaults store.
 */

- (void) clearSession;

/*!
 @method sessionStored
 @abstract Returns YES if session information is stored for the next upload; NO
 if not.
 */

- (BOOL) sessionStored;

@end
