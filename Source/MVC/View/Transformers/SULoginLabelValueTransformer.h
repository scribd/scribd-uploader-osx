/*!
 @brief Converts a stored session username into a descriptive label for the
 currently logged-in user.
 @details If no session has been stored in the user defaults, the string <tt>Not
 logged in</tt>. will be returned. If a session has been stored, the username of
 that session will be inserted in a descriptive <tt>Logged in as
 <i>person</i></tt> string and returned.
 @ingroup transformers
 */

@interface SULoginLabelValueTransformer : NSValueTransformer {
	
}

@end
