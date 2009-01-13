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
	BOOL uploadAsPrivate;
	BOOL isBusy;
	NSUInteger currentlyUploadingCount;
	NSString *busyAction;
	NSString *newUserLogin, *newUserEmail, *newUserPassword, *newUserName;
	NSError *newUserLoginError, *newUserEmailError, *newUserPasswordError, *newUserNameError;
	IBOutlet NSWindow *uploadWindow, *loginSheet, *uploadCompleteSheet;
	IBOutlet SUUploadCompleteSheetDelegate *uploadCompleteSheetDelegate;
	IBOutlet SUDatabaseHelper *db;
}

/*!
 @property uploadAsPrivate
 @abstract If YES, documents will be uploaded with the private flag set to true.
 Otherwise, documents will be public.
 */

@property (assign) BOOL uploadAsPrivate;

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

/*!
 @method uploadComplete
 @abstract Returns YES if all uploads are complete (if
 @link currentlyUploadingCount currentlyUploadingCount @/link is zero).
 @result YES if all uploads are complete; NO if some uploads are still ongoing
 or if uploads have not yet been started.
 */

- (BOOL) uploadComplete;

@end
