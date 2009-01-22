#import "SUConstants.h"

/* Constants */
const NSTimeInterval SUTimeBetweenCategoryLoads = 1209600.0; // two weeks

/* Error domains */
NSString *SUScribdAPIErrorDomain = @"SUScribdAPIErrorDomain";

/* Error user-info keys */
NSString *SUInvalidatePropertyErrorKey = @"SUInvalidateProperty";
NSString *SUActionErrorKey = @"SUActionErrorKey";

/* Error codes */
const NSInteger SUErrorCodeUploadFailed = -100;

/* Actions */
NSString *SULogInAction = @"LogIn";
NSString *SUSignUpAction = @"SignUp";
NSString *SUUploadAction = @"Upload";
NSString *SUChangeSettingsAction = @"ChangeSettings";

/* User defaults keys */
NSString *SUDefaultKeySessionKey = @"sessionKey";
NSString *SUDefaultKeySessionUsername = @"sessionUsername";
NSString *SUDefaultKeyLastCategoryLoad = @"lastCategoryLoad";

/* Notifications */
NSString *SUUploadCompleteNotification = @"SUUploadCompleteNotification";
NSString *SUUploadSucceededNotification = @"SUUploadSucceededNotification";
NSString *SUUploadFailedNotification = @"SUUploadFailedNotification";
