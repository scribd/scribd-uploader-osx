/*!
 @brief Controller interface for uploading files, logging in, and creating new
 accounts.
 @details This class displays and handles sheets for signing up, logging in,
 and beginning uploads. It interfaces with SUScribdAPI
 to perform the network operations.
 
 This class also acts as a bridge between the server and the key-value compliant
 view. View attributes are converted to server-friendly values before being sent
 to the API interface. API errors are converted into key-value validation errors
 for appropriate use in the view.
 @ingroup helpers
 */

@interface SUUploadHelper : NSObject {
	@private
		BOOL isBusy, uploadStarted;
		NSUInteger currentlyUploadingCount;
		NSString *busyAction;
		NSString *scribdLogin, *scribdPassword;
		NSString *newUserLogin, *newUserEmail, *newUserPassword, *newUserName;
		NSError *newUserLoginError, *newUserEmailError, *newUserPasswordError, *newUserNameError;
		NSMutableSet *uploadDelegates;
		IBOutlet NSWindow *loginSheet;
		IBOutlet SUDatabaseHelper *db;
}


#pragma mark Log in/sign up sheet bindings
/** @name Log in/sign up sheet bindings */
//@{

/*!
 @brief The login to use when creating a new user.
 */

@property (retain) NSString *newUserLogin;

/*!
 @brief The email address to use when creating a new user.
 */

@property (retain) NSString *newUserEmail;

/*!
 @brief The password to use when creating a new user.
 */

@property (retain) NSString *newUserPassword;

/*!
 @brief The real name to use when creating a new user.
 */

@property (retain) NSString *newUserName;

/*!
 @brief The username used when signing in to an existing account.
 */

@property (retain) NSString *scribdLogin;

/*!
 @brief The password used when signing in to an existing account.
 */

@property (retain) NSString *scribdPassword;

//@}

#pragma mark Working with Scribd.com
/** @name Working with Scribd.com */
//@{

/*!
 @brief Logs in to Scribd.com with the login and password stored in the user
 defaults.
 @result @c YES if the operation was successful, @c NO if not.
 @details The login and password are stored under the defaults keys of
 @c scribdLogin and @c scribdPassword.
 */

- (BOOL) authenticate;

/*!
 @brief Creates a new Scribd account using the values of the @c newUser*
 properties.
 @result @c YES if the operation was successful, @c NO if not.
 */

- (BOOL) createAccount;


/*!
 @brief Uploads all files in the file list.
 */

- (void) uploadFiles;

//@}

#pragma mark Getting state information
/** @name Getting state information */
//@{

/*!
 @brief Returns @c YES if all uploads are complete (if
 @link SUUploadHelper::currentlyUploadingCount currentlyUploadingCount
 @endlink is zero).
 @result @c YES if all uploads are complete; @c NO if some uploads are still
 ongoing or if uploads have not yet been started.
 */

- (BOOL) uploadComplete;

/*!
 @brief Set by this class when a network operation is in progress, so that a
 visual indication of such is available to the view.
 */

@property (assign) BOOL isBusy;

/*!
 @brief The number of files simultaneously being uploaded at this moment.
 @details @c 0 when no uploading is currently in progress.
 */

@property (assign) NSUInteger currentlyUploadingCount;

/*!
 @brief @c YES if uploads are currently in progress (if
 @link SUUploadHelper::currentlyUploadingCount currentlyUploadingCount @endlink
 is at least @c 1).
 */

@property (readonly) BOOL isUploading;

/*!
 @brief @c YES if at least one upload has occurred and no files are currently
 being transferred; @c NO otherwise.
 */

@property (readonly) BOOL uploadComplete;

/*!
 @brief A description of what network operation this helper is currently
 performing (if any).
 @details Values can be @c NULL, @c login, or @c signup.
 */

@property (retain) NSString *busyAction;

//@}
@end
