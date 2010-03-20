#pragma mark Constants

/*!
 @brief The amount of time that must pass before categories are considered stale
 and are reloaded from the server.
 */

const NSTimeInterval SUTimeBetweenCategoryLoads;

#pragma mark Error domains
/** @defgroup errors Constants - Errors */
//@{

/*!
 @brief The domain that @c NSError instances are initialized with, when
 pertaining to internal Scribd Uploader errors.
 */

NSString *SUErrorDomain;

/*!
 @brief The domain that @c NSError instances are initialized with, when
 pertaining to Scribd.com API errors.
 */

NSString *SUScribdAPIErrorDomain;

#pragma mark Error codes

/*!
 @brief Enumeration of error codes defined in the SUErrorDomain error domain.
 */

enum SUErrorDomainCode {
	/*! @brief The upload failed to complete. */
	SUErrorCodeUploadFailed = 1
};

#pragma mark Error user-info keys

/*!
 @brief The key of an  <tt>NSError</tt>'s user-info dictionary containing the
 property whose value is invalid.
 */

NSString *SUInvalidatePropertyErrorKey;

/*!
 @brief The key of an <tt>NSError</tt>'s user-info dictionary containing the API
 action that was performed when the error occurred .
 */

NSString *SUActionErrorKey;

/*!
 @brief The key of an object that was determined to be invalid.
 */

NSString *SUInvalidObjectErrorKey;

/*!
 @brief The key of a SUDocument instance that had the error.
 */

NSString *SUDocumentErrorKey;

#pragma mark Exceptions

/*!
 @brief Raised by
 SUReversibleMappingValueTransformer
 if given a dictionary that is not symmetrically perfect.
 */

NSString *SUExceptionDictionaryMustBePerfect;

/*!
 @brief Raised by SUHumanizeDimensionValueTransformer if given the empty
 initializer.
 */

NSString *SUExceptionMustHaveRootUnit;

//@}

#pragma mark Actions
/** @defgroup constants Constants */
//@{

/*!
 @brief A string representing the action of logging in. Scribd error codes are
 organized by the action that could cause the error.
 */

NSString *SULogInAction;

/*!
 @brief A string representing the action of signing up. Scribd error codes are
 organized by the action that could cause the error.
 */

NSString *SUSignUpAction;

/*!
 @brief A string representing the action of uploading. Scribd error codes are
 organized by the action that could cause the error.
 */

NSString *SUUploadAction;

/*!
 @brief A string representing the action of setting a document's metadata.
 Scribd error codes are organized by the action that could cause the error.
 */

NSString *SUChangeSettingsAction;

#pragma mark User defaults keys

/*!
 @brief The User Defaults key for the login or email address of the currently
 logged in user.
 @details @c NULL if no user is currently logged in. The session key is stored
 in the keychain.
 */

NSString *SUDefaultKeySessionUsername;

/*!
 @brief The User Defaults key for the last time that the category list was
 downloaded from the server.
 */

NSString *SUDefaultKeyLastCategoryLoad;

/*!
 @brief The User Defaults key for the boolean which indicates if newly added
 documents should be marked to upload as private by default.
 */

NSString *SUDefaultKeyUploadPrivateDefault;

/*!
 @brief The User Defaults key for the boolean which indicates if the user
 manually opens and closes the Information drawer. If false, the program opens
 the information drawer only when one or more files are selected.
 */

NSString *SUDefaultKeyManualMetadataDrawer;

//@}

#pragma mark Notifications
/** @defgroup notifications Constants - Notifications */
//@{

/*!
 @brief Posted when a file completes or fails uploading. The included object is
 the SUUploadDelegate for the upload.
 */

NSString *SUUploadDidCompleteNotification;

/*!
 @brief Posted when a file uploads successfully. The included object is the
 SUUploadDelegate for the upload.
 */

NSString *SUUploadDidSucceedNotification;

/*!
 @brief Posted when a file fails to upload. The included object is the
 SUUploadDelegate for the upload.
 */

NSString *SUUploadDidFailNotification;

/*!
 @brief Posted by SUDirectoryScanner when a directory scan commences.
 */

NSString *SUScanningDidBeginNotification;
/*!
 @brief Posted by SUDirectoryScanner when a directory scan completes.
 */

NSString *SUScanningDidCompleteNotification;

//@}

#pragma mark Info.plist keys
/** @defgroup infoPlistKeys Constants - Info.plist keys */
//@{

/*!
 @brief @c Info.plist dictionary key whose value is the URL for the Scribd.com
 My Docs page.
 */

NSString *SUMyDocsURLInfoKey;

/*!
 @brief @c Info.plist dictionary key whose value is the format of a document's
 URL on Scribd.com.
 */

NSString *SUDocumentURLInfoKey;

/*!
 @brief @c Info.plist dictionary key whose value is the format of a document's
 bulk-edit URL on Scribd.com.
 */

NSString *SUDocumentEditURLInfoKey;

//@}
