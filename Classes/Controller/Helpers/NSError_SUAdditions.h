/*!
 @category NSError(SUAdditions)
 @abstract Additions to the @link //apple_ref/occ/cl/NSError NSError @/link for
 handling Scribd.com errors.
 */

@interface NSError (SUAdditions)

#pragma mark Adding info

/*!
 @method addMessagesForAction:sender:
 @abstract Sets localized description and recovery suggestion messages based on
 the error's code and the given action.
 @param action The action that caused the error, such as "SignUp".
 @param sender The object using this error; its KVC values will be used to fill
 in values of fields used in error descriptions.
 @result This method will return the receiver if the error is not changed. If a
 new error was created, however, it will be returned and should replace the
 receiver in all subsequent code.
 @discussion Error messages are described in the ScribdAPI.plist file.
 */

- (NSError *) addMessagesForAction:(NSString *)action sender:(id)sender;

/*!
 @method addMessagesForAction:title:
 @abstract Sets localized description and recovery suggestion messages based on
 the error's code and the given action.
 @param action The action that caused the error, such as "SignUp".
 @param docTitle The title of the document, to be embedded into the error
 description.
 @result This method will return the receiver if the error is not changed. If a
 new error was created, however, it will be returned and should replace the
 receiver in all subsequent code.
 @discussion Error messages are described in the ScribdAPI.plist file.
 */

- (NSError *) addMessagesForAction:(NSString *)action title:(NSString *)docTitle;

@end
