/*!
 @class SULogInButtonTitleValueTransformer
 @abstract Sets the title of the "Log In"/"Log Out" button.
 @discussion The button's title will be set to "Log In" if no session key exists
 in the user defaults. It will be set to "Log Out" if a session key exists.
 */

@interface SULogInButtonTitleValueTransformer : NSValueTransformer {
	
}

@end
