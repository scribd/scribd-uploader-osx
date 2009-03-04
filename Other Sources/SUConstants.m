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

/* Actions */
NSString *SULogInAction = @"LogIn";
NSString *SUSignUpAction = @"SignUp";
NSString *SUUploadAction = @"Upload";
NSString *SUChangeSettingsAction = @"ChangeSettings";

/* User defaults keys */
NSString *SUDefaultKeySessionUsername = @"sessionUsername";
NSString *SUDefaultKeyLastCategoryLoad = @"lastCategoryLoad";
NSString *SUDefaultKeyUploadPrivateDefault = @"privateUploadsByDefault";
NSString *SUDefaultKeyManualMetadataDrawer = @"manualMetadataDrawer";

/* Notifications */
NSString *SUUploadCompleteNotification = @"SUUploadCompleteNotification";
NSString *SUUploadSucceededNotification = @"SUUploadSucceededNotification";
NSString *SUUploadFailedNotification = @"SUUploadFailedNotification";
NSString *SUScanningStartedNotification = @"SUScanningStartedNotification";
NSString *SUScanningDoneNotification = @"SUScanningDoneNotification";

/* Info.plist keys */
NSString *SUMyDocsURLInfoKey = @"SUMyDocsURL";
NSString *SUDocumentURLInfoKey = @"SUDocumentURL";
NSString *SUDocumentEditURLInfoKey = @"SUDocumentEditURL";
