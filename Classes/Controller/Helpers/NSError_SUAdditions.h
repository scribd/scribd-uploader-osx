#import <Cocoa/Cocoa.h>
#import "SUConstants.h"

/*!
 @category NSError(SUAdditions)
 @abstract Additions to the @link //apple_ref/occ/cl/NSError NSError @/link.
 */

@interface NSError (SUAdditions)

/*!
 @method addMessagesForAction:
 @abstract Sets localized description and recovery suggestion messages based on
 the error's code and the given action.
 @param action The action that caused the error, such as "SignUp".
 @param sender The object using this error; its KVC values will be used to fill
 in values of fields used in error descriptions.
 @discussion Error messages are described in the ScribdAPI.plist file.
 */

- (void) addMessagesForAction:(NSString *)action sender:(id)sender;

@end
