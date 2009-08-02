/*!
 @class SULoginLabelValueTransformer
 @abstract Converts a stored session username into a descriptive label for the
 currently logged-in user.
 @discussion If no session has been stored in the user defaults, the string "Not
 logged in." will be returned. If a session has been stored, the username of
 that session will be inserted in a descriptive "Logged in as" string and
 returned.
 */

@interface SULoginLabelValueTransformer : NSValueTransformer {
	
}

@end
