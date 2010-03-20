/*!
 @brief Additions to @c NSError for handling Scribd.com errors.
 @details In order to pass contextual information about API errors up from the
 API manager to the view, @c NSError instances resulting from API error status
 codes are annotated with additional information in their @c userInfo.
 
 The information that this category uses to annotate the error instances is
 found in the @c ScribdAPI.plist file.
 @ingroup helpers
 */

@interface NSError (SUAdditions)

#pragma mark Adding info
/** @name Adding info */
//@{

/*!
 @brief Sets localized description and recovery suggestion messages based on the
 error's code and the given action.
 @param action The action that caused the error, such as @c SignUp.
 @param sender The object using this error; its KVC values will be used to fill
 in values of fields used in error descriptions.
 @result This method will return the receiver if the error is not changed. If a
 new error was created, however, it will be returned and should replace the
 receiver in all subsequent code.
 */

- (NSError *) addMessagesForAction:(NSString *)action sender:(id)sender;

/*!
 @brief Sets localized description and recovery suggestion messages based on
 the error's code and the given action.
 @param action The action that caused the error, such as @c SignUp.
 @param docTitle The title of the document, to be embedded into the error
 description.
 @result This method will return the receiver if the error is not changed. If a
 new error was created, however, it will be returned and should replace the
 receiver in all subsequent code.
 */

- (NSError *) addMessagesForAction:(NSString *)action title:(NSString *)docTitle;

//@}
@end
