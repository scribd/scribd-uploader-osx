#import <Cocoa/Cocoa.h>

/*!
 @class SUBusyActionValueTransformer
 @abstract Converts a @link SUUploadHelper SUUploadHelper @/link busy status into a
 descriptive string of the operation for display in the login/signup sheet.
 @discussion A SUUploadHelper busy status ("login" or "signup") is converted to a
 human readable status (such as "Logging in…").
 */

@interface SUBusyActionValueTransformer : NSValueTransformer {
	
}

@end
