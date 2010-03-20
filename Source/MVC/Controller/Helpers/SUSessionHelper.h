/*!
 @brief This singleton class has utility methods for working with the Scribd.com
 session.
 @details Scribd session information is stored in the shared user defaults
 object. It is a session key linked with the login of the Scribd.com user owning
 the session.
 
 The @link SUSessionHelper::setupForLaunch setupForLaunch @endlink method should
 be called when the application first starts up.
 @ingroup helpers
 */

@interface SUSessionHelper : NSObject {
	
}

#pragma mark Working with the singleton instance
/** @name Working with the singleton instance */
//@{

/*!
 @brief Returns the singleton instance.
 @result The singleton instance.
 */

+ (SUSessionHelper *) sessionHelper;

//@}

#pragma mark Getting and setting the session key
/** @name Getting and setting the session key */
//@{

/*!
 @brief The Scribd session key stored in the user defaults.
 */

@property (readonly) NSString *key;

/*!
 @brief The login or email assocated with the session key stored in the user
 defaults.
 */

@property (readonly) NSString *username;

/*!
 @brief Stores the session key returned by Scribd and the login or email
 associated with that key in the user defaults store.
 @param key The session key.
 @param username The login or email associated with the session.
 */

- (void) storeSessionKey:(NSString *)key username:(NSString *)username;

/*!
 @brief Returns @c YES if session information is stored for the next upload;
 @c NO if not.
 */

- (BOOL) sessionStored;

//@}

#pragma mark Required setup methods
/** @name Required setup methods */
//@{

/*!
 @brief This method should be called when the application first launches. It
 clears out the session username if the session keychain item has been deleted.
 */

- (void) setupForLaunch;

//@}
@end
