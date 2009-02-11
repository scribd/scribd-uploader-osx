/*!
 @class SUUploadHelper
 @abstract Controller interface for uploading files, logging in, and creating
 new accounts.
 @discussion This class displays and handles sheets for signing up, logging in,
 and beginning uploads. It interfaces with @link SUScribdAPI SUScribdAPI @/link
 to perform the network operations.
 
 This class also acts as a bridge between the server and the key-value compliant
 view. View attributes are converted to server-friendly values before being sent
 to the API interface. API errors are converted into key-value validation errors
 for appropriate use in the view.
 */

@interface SUUploadHelper : NSObject {
	BOOL isBusy, uploadStarted;
	NSUInteger currentlyUploadingCount;
	NSString *busyAction;
	NSString *scribdLogin, *scribdPassword;
	NSString *newUserLogin, *newUserEmail, *newUserPassword, *newUserName;
	NSError *newUserLoginError, *newUserEmailError, *newUserPasswordError, *newUserNameError;
	NSMutableSet *uploadDelegates;
	IBOutlet NSWindow *uploadWindow, *loginSheet;
	IBOutlet SUDatabaseHelper *db;
}

#pragma mark Properties

/*!
 @property isBusy
 @abstract Set by this class when a network operation is in progress, so that a
 visual indication of such is available to the view.
 */

@property (assign) BOOL isBusy;

/*!
 @property currentlyUploadingCount
 @abstract The number of files simultaneously being uploaded at this moment.
 Zero when no uploading is currently in progress.
 */

@property (assign) NSUInteger currentlyUploadingCount;

/*!
 @property isUploading
 @abstract YES if uploads are currently in progress (if
 @link currentlyUploadingCount currentlyUploadingCount @/link is at least 1).
 */

@property (readonly) BOOL isUploading;

/*!
 @property uploadComplete
 @abstract YES if at least one upload has occurred and no files are currently
 being transferred; NO otherwise.
 */

@property (readonly) BOOL uploadComplete;

/*!
 @property busyAction
 @abstract A description of what network operation this helper is currently
 performing (if any).
 @discussion Values can be NULL, "login", or "signup".
 */

@property (retain) NSString *busyAction;

/*!
 @property newUserLogin
 @abstract The login to use when creating a new user.
 */

@property (retain) NSString *newUserLogin;

/*!
 @property newUserEmail
 @abstract The email address to use when creating a new user.
 */

@property (retain) NSString *newUserEmail;

/*!
 @property newUserPassword
 @abstract The password to use when creating a new user.
 */

@property (retain) NSString *newUserPassword;

/*!
 @property newUserName
 @abstract The real name to use when creating a new user.
 */

@property (retain) NSString *newUserName;

/*!
 @property scribdLogin
 @abstract The username used when signing in to an existing account.
 */

@property (retain) NSString *scribdLogin;

/*!
 @property scribdPassword
 @abstract The password used when signing in to an existing account.
 */

@property (retain) NSString *scribdPassword;

#pragma mark Working with Scribd.com

/*!
 @method authenticate
 @abstract Logs in to Scribd with the login and password stored in the user
 defaults.
 @result YES if the operation was successful, NO if not.
 @discussion The login and password are stored under the defaults keys of
 "scribdLogin" and "scribdPassword".
 */

- (BOOL) authenticate;

/*!
 @method createAccount
 @abstract Creates a new Scribd account using the values of the newUser
 properties.
 @result YES if the operation was successful, NO if not.
 */

- (BOOL) createAccount;


/*!
 @method uploadFiles
 @abstract Uploads all files in the file list.
 @discussion If the uploadAsPrivate property is set, the files will be uploaded
 as private documents.
 */

- (void) uploadFiles;

#pragma mark Getting state information

/*!
 @method uploadComplete
 @abstract Returns YES if all uploads are complete (if
 @link currentlyUploadingCount currentlyUploadingCount @/link is zero).
 @result YES if all uploads are complete; NO if some uploads are still ongoing
 or if uploads have not yet been started.
 */

- (BOOL) uploadComplete;

@end
