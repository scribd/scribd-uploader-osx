#import "SUConstants.h"

/* Constants */
const NSTimeInterval SUTimeBetweenCategoryLoads = 1209600.0; // two weeks

/* Error domains */
NSString *SUErrorDomain = @"SUErrorDomain";
NSString *SUScribdAPIErrorDomain = @"SUScribdAPIErrorDomain";

/* Error user-info keys */
NSString *SUInvalidatePropertyErrorKey = @"SUInvalidateProperty";
NSString *SUActionErrorKey = @"SUActionErrorKey";
NSString *SUInvalidObjectErrorKey = @"SUInvalidObjectErrorKey";

/* Exceptions */
NSString *SUExceptionDictionaryMustBePerfect = @"SUExceptionDictionaryMustBePerfect";
NSString *SUExceptionMustHaveRootUnit = @"SUExceptionMustHaveRootUnit";

/* Actions */
NSString *SULogInAction = @"LogIn";
NSString *SUSignUpAction = @"SignUp";
NSString *SUUploadAction = @"Upload";
NSString *SUChangeSettingsAction = @"ChangeSettings";

/* User defaults keys */
NSString *SUDefaultKeySessionUsername = @"SUSessionUsername";
NSString *SUDefaultKeyLastCategoryLoad = @"SULastCategoryLoad";
NSString *SUDefaultKeyUploadPrivateDefault = @"SUUploadPrivateDefault";
NSString *SUDefaultKeyManualMetadataDrawer = @"SUManualMetadataDrawer";

/* Notifications */
NSString *SUUploadDidCompleteNotification = @"SUUploadDidCompleteNotification";
NSString *SUUploadDidSucceedNotification = @"SUUploadDidSucceedNotification";
NSString *SUUploadDidFailNotification = @"SUUploadDidFailNotification";
NSString *SUScanningDidBeginNotification = @"SUScanningDidBeginNotification";
NSString *SUScanningDidCompleteNotification = @"SUScanningDidCompleteNotification";

/* Info.plist keys */
NSString *SUMyDocsURLInfoKey = @"SUMyDocsURL";
NSString *SUDocumentURLInfoKey = @"SUDocumentURL";
NSString *SUDocumentEditURLInfoKey = @"SUDocumentEditURL";
