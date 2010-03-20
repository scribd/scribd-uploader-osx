/*!
 @brief Stores settings and constants relating to the Scribd.com API.
 @ingroup network
 */

@interface SUAPIHelper : NSObject {
	@protected
		NSDictionary *settings;
}

#pragma mark Working with the singleton instance
/** @name Working with the singleton instance */
//@{

/*!
 @brief Returns the singleton instance.
 @result The singleton instance.
 */

+ (SUAPIHelper *) helper;

//@}

#pragma mark Getting settings
/** @name Getting settings */
//@{

/*!
 @brief The settings stored in the @c ScribdAPI.plist file.
 */

@property (readonly) NSDictionary *settings;

//@}
@end
