/*!
 @class SUAPIHelper
 @abstract Stores settings and constants relating to the Scribd.com API.
 */

@interface SUAPIHelper : NSObject {
	@protected
		NSDictionary *settings;
}

#pragma mark Properties

/*!
 @property settings
 @abstract The settings stored in the ScribdAPI.plist file.
 */

@property (readonly) NSDictionary *settings;

#pragma mark Working with the singleton instance

/*!
 @method helper
 @abstract Returns the singleton instance.
 @result The singleton instance.
 */

+ (SUAPIHelper *) helper;

@end
