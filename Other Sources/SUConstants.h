#pragma mark Constants

/*!
 @const SUTimeBetweenCategoryLoads
 @abstract The amount of time that must pass before categories are considered
 stale and are reloaded from the server.
 */

const NSTimeInterval SUTimeBetweenCategoryLoads;

#pragma mark Error Domains

/*!
 @const SUScribdAPIErrorDomain
 @abstract The domain that @link //apple_ref/occ/cl/NSError NSError @/link
 instances are initialized with.
 */

NSString *SUScribdAPIErrorDomain;

#pragma mark Error user-info keys

/*!
 @const SUInvalidatePropertyErrorKey
 @abstract The key of an @link //apple_ref/occ/cl/NSError NSError's @/link
 user-info dictionary containing the property whose value is invalid.
 */

NSString *SUInvalidatePropertyErrorKey;

/*!
 @const SUActionErrorKey
 @abstract The key of an @link //apple_ref/occ/cl/NSError NSError's @/link
 user-info dictionary containing the API action that was performed when the
 error occurred (see Actions below).
 */

NSString *SUActionErrorKey;

#pragma mark Error codes

/*!
 @const SUErrorCodeUploadFailed
 @abstract The error code for an @link //apple_ref/occ/cl/NSError NSError @/link
 created when an upload could not complete for any reason other than a Scribd
 server error code.
 */

const NSInteger SUErrorCodeUploadFailed;

#pragma mark Actions

/*!
 @const SULogInAction
 @abstract A string representing the action of logging in. Scribd error codes
 are organized by the action that could cause the error.
 */

NSString *SULogInAction;

/*!
 @const SUSignUpAction
 @abstract A string representing the action of signing up. Scribd error codes
 are organized by the action that could cause the error.
 */

NSString *SUSignUpAction;

/*!
 @const SUUploadAction
 @abstract A string representing the action of uploading. Scribd error codes are
 organized by the action that could cause the error.
 */

NSString *SUUploadAction;

/*!
 @const SUChangeSettingsAction
 @abstract A string representing the action of setting a document's metadata.
 Scribd error codes are organized by the action that could cause the error.
 */

NSString *SUChangeSettingsAction;

#pragma mark User defaults keys

/*!
 @const SUDefaultKeySessionUsername
 @abstract The User Defaults key for the login or email address of the currently
 logged in user.
 @discussion NULL if no user is currently logged in. The session key is stored
 in the keychain.
 */

NSString *SUDefaultKeySessionUsername;

/*!
 @const SUDefaultKeyLastCategoryLoad
 @abstract The User Defaults key for the last time that the category list was
 downloaded from the server.
 */

NSString *SUDefaultKeyLastCategoryLoad;

/*!
 @const SUDefaultKeyUploadPrivateDefault
 @abstract The User Defaults key for the boolean which indicates if newly added
 documents should be marked to upload as private by default.
 */

NSString *SUDefaultKeyUploadPrivateDefault;

#pragma mark Notifications

/*!
 @const SUUploadCompleteNotification
 @abstract Posted when a file completes or fails uploading. The included object
 is the @link SUUploadDelegate SUUploadDelegate @/link for the upload.
 */

NSString *SUUploadCompleteNotification;

/*!
 @const SUUploadSucceededNotification
 @abstract Posted when a file uploads successfully. The included object is the
 @link SUUploadDelegate SUUploadDelegate @/link for the upload.
 */

NSString *SUUploadSucceededNotification;

/*!
 @const SUUploadFailedNotification
 @abstract Posted when a file fails to upload. The included object is the
 @link SUUploadDelegate SUUploadDelegate @/link for the upload.
 */

NSString *SUUploadFailedNotification;

#pragma mark Info.plist keys

/*!
 @const SUMyDocsURLInfoKey
 @abstract Info.plist dictionary key whose value is the URL for the Scribd.com
 My Docs page.
 */

NSString *SUMyDocsURLInfoKey;

/*!
 @const SUDocumentURLInfoKey
 @abstract Info.plist dictionary key whose value is the format of a document's
 URL on Scribd.com.
 */

NSString *SUDocumentURLInfoKey;
