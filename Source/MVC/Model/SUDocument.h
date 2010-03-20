#define SUPreviewIconSize 32.0

/*!
 @brief Core Data object representing a document to be uploaded. Its entity name
 is @c Document. Document paths are URLs (either filesystem or remote) that
 refer to a document.
 @details This class adds file- and URL-specific operations and derived
 properties to the basic Core Data entity type, as well as some derived
 properties from the path and the metadata.
 
 If the path is a filesystem URL (<tt>file://<i>...</i></tt>), the file manager
 is used for many derived properties. If it is a remote URL
 (<tt>http://<i>...</i></tt>), path splicing and network operations are used.
 @ingroup model
 */

@interface SUDocument : NSManagedObject {
	@protected
		NSString *kind;
		NSURL *URL;
		NSNumber *size;
		NSImage *icon;
}

#pragma mark Defining properties
/** @name Defining properties */
//@{

/*!
 @brief The URL string to the file being uploaded.
 @details This attribute is required and uniquely identifies a document. For
 files on the user's hard drive, it is a filesystem URL. For files over a
 network or on the Internet, it is a remote URL.
 @see URL
 @see fileSystemPath
 */

@property (copy) NSString *path;

/*!
 @brief The Scribd.com ID given to this document, once it has been successfully
 uploaded.
 @details This attribute is @c NULL by default.
 */

@property (copy) NSNumber *scribdID;

//@}

#pragma mark User-configurable properties
/** @name User-configurable properties */
//@{

/*!
 @brief If @c YES, the document will be uploaded as private. If @c NO, the
 document will be publically viewable.
 @details This attribute is set to @c NO by default.
 */

@property (copy) NSNumber *hidden;

/*!
 @brief The title to use for the Scribd document.
 @details This optional attribute is part of the document metadata.
 */

@property (copy) NSString *title;

/*!
 @brief The description to use for the Scribd document.
 @details This optional attribute is part of the document metadata.
 */

@property (copy) NSString *summary;

/*!
 @brief A comma-delimited list of tags to assign to the document.
 @details This optional attribute is part of the document metadata.
 */

@property (copy) NSString *tags;

/*!
 @brief The original author of this work.
 @details This optional attribute is part of the document publisher metadata.
 */

@property (copy) NSString *author;

/*!
 @brief The publisher of this edition of the work.
 @details This optional attribute is part of the document publisher metadata.
 */

@property (copy) NSString *publisher;

/*!
 @brief The edition name or number of this publication of the work.
 @details This optional attribute is part of the document publisher metadata.
 */

@property (copy) NSString *edition;

/*!
 @brief The date this edition of the work was first published.
 @details Only the day portion of this date will be sent to the Scribd.com
 server. The time portion will be stripped.
 
 This optional attribute is part of the document publisher metadata.
 */

@property (copy) NSDate *datePublished;

/*!
 @brief The license under which this work is distributed.
 @details This is either a Creative Commons abbreviated license name (e.g.,
 @c by-sa for Attribution share alike), @c pd for public domain, or @c c for
 traditional copyright.
 
 This attribute is part of the document publisher metadata.
 */

@property (copy) NSString *license;

//@}

#pragma mark Upload status
/** @name Upload status */
//@{

/*!
 @brief The total number of bytes uploaded so far, calculated from the
 @link progress @endlink and the @link totalBytes @endlink.
 @details The number will be an <tt>unsigned long long</tt> value. Returns
 @c NULL if the value could not be calculated.
 */

/*!
 @brief The time at which the upload began.
 @details This transient attribute is set to @c NULL if the upload has not yet
 begun. It must be set by an outside object. The @c SUDocument instance does not
 maintain this attribute.
 */

@property (copy) NSDate *startTime;

/*!
 @brief The fraction of the file which has been uploaded, as a value from 0.0 to
 1.0.
 @details This attribute is set to 0.0 by default.
 */

@property (copy) NSNumber *progress;

/*!
 @brief The amount of data uploaded to Scribd thus far from this file, in bytes.
 @details The number will be an <tt>unsigned long long</tt> value. For remote
 files, returns @c NULL.
 @see hasSize
 */

@property (readonly) NSNumber *bytesUploaded;

/*!
 @brief The size of the file in bytes. For local files, uses the file manager to
 determine the size. For remote files, returns @c NULL.
 @details The number will be an <tt>unsigned long long</tt> value. Returns
 @c NULL if the size could not be calculated.
 @see hasSize
 */

@property (readonly) NSNumber *totalBytes;

/*!
 @brief Returns an estimate of the number of seconds remaining until the file
 is finished uploading. This value is calculated from @link progress @endlink
 and @link startTime @endlink.
 @details The number will be an <tt>unsigned long long</tt> value. Returns
 @c NULL if the time could not be calculated.
 */

@property (readonly) NSNumber *estimatedSecondsRemaining;

//@}

#pragma mark Relationships
/** @name Relationships */
//@{

/*!
 @brief The @c Category assigned to this document.
 */

@property (retain) SUCategory *category;

//@}

#pragma mark File properties
/** @name File properties */
//@{

/*!
 @brief The URL object for the path.
 @details This is a calculated property, and is not written to the persistent
 store.
 */

@property (readonly) NSURL *URL;

/*!
 @brief The path to the file as used by the file system.
 @details This is a calculated property, and is not written to the persistent
 store.
 */

@property (readonly) NSString *fileSystemPath;

/*!
 @brief The name of the file, derived from the path.
 @details For local files, the file manager's default representation is used.
 For remote files, the filename portion of the path is used.
 
 This is a calculated property, and is not written to the persistent store.
 */

@property (readonly) NSString *filename;

/*!
 @brief The icon for the file, derived from the path.
 @details For local files, the file manager is used to generate the icon. For
 remote files, a default icon for the file's extension is used.
 
 For local files only, the first time this property is accessed, a separate
 thread is spawned that uses Quick Look to generate a preview icon. The property
 is changed when the thread exits successfully.
 
 This is a calculated property, and is not written to the persistent store.
 */

@property (readonly) NSImage *icon;

/*!
 @brief A description of the file's type, derived from the path.
 @details The @c FileTypes.plist file is used to retrieve a description of a
 path from its file extension.
 
 This is a calculated property, and is not written to the persistent store.
 */

@property (readonly) NSString *kind;

/*!
 @brief A numerical index of how easy it is for others to find this document
 in normal searching.
 @details The discoverability is based on the length of the title and summary as
 well as the presence of other metadata.
 */

@property (readonly) NSNumber *discoverability;

/*!
 @brief Returns a URL at which the Scribd document can be viewed.
 @details The URL for the Scribd document, or @c NULL if the document hasn't
 been uploaded yet.
 */

//@}

#pragma mark Scribd URLs
/** @name Scribd URLs */
//@{

/*!
 @brief Returns a URL at which the Scribd document can be viewed.
 @details @c NULL if the document hasn't been uploaded yet.
 */

@property (readonly) NSURL *scribdURL;

/*!
 @brief Returns a URL at which the Scribd document can be edited.
 @details @c NULL if the document hasn't been uploaded yet.
 */

@property (readonly) NSURL *editURL;

//@}

#pragma mark Errors
/** @name Errors */
//@{

/*!
 @brief A serialized @c NSError with the last error returned by the server upon
 upload.
 @details This attribute is optional.
 @see errorIsUnrecoverable
 */

@property (copy) NSData *error;

/*!
 @brief @c YES if the error was bad enough that the document was not uploaded;
 @c NO if the document was uploaded but another problem occurred.
 @details This attribute is optional.
 @see error
 */

@property (copy) NSNumber *errorIsUnrecoverable;


/*!
 @brief A string describing the error state of this document.
 @details @c Success if no error has occurred, @c Caution if the document was
 uploaded but an error occurred, @c Error if an error occurred preventing the
 document from being uploaded, or @c Pending if no upload has occurred yet.
 */

@property (readonly) NSString *errorLevel;

//@}

#pragma mark States
/** @name States */
//@{

/*!
 @brief Whether or not this document has not begun uploading.
 */

@property (readonly) BOOL pending;

/*!
 @brief @c YES if the file is currently being uploaded, or @c NO if it has
 either finished or has not yet started.
 */

@property (readonly) BOOL uploading;

/*!
 @brief @c YES if the file has been uploaded to Scribd.com; @c NO if it hasn't
 yet been uploaded successfully.
 */

@property (readonly) BOOL uploaded;

/*!
 @brief Returns @c YES if the document has been uploaded and is undergoing
 post-upload processing (setting attributes and converting). Returns @c NO if
 this process is complete or if the document has not yet been uploaded.
 @see converting
 @see assigningProperties
 */

@property (readonly) BOOL postProcessing;

/*!
 @brief @c YES if the document is being converted by Scribd.com. The conversion
 process begins once the document has finished uploading.
 @details This transient attribute is set to @c NO when the document has
 finished converting or before it has been uploaded.
 */

@property (copy) NSNumber *converting;

/*!
 @brief @c YES if the document has been uploaded, and conversion has either
 completed or failed.
 */

@property (copy) NSNumber *conversionComplete;

/*!
 @brief @c YES if the document has been uploaded and the metadata is being sent
 to Scribd.com. This process occurs immediately after upload is complete.
 @details This transient attribute is set to @c NO when the document has its
 attributes set or before it has been uploaded.
 */

@property (copy) NSNumber *assigningProperties;

/*!
 @brief @c YES if the file has been uploaded without error, @c NO if an error
 occurred, and @c NULL if the file has not completed upload yet.
 @details Obviously @c YES and @c NO are represented as @c NSNumber instances,
 and @c NULL is a pointer to address @c 0x0.
 @details This attribute is set to @c NO by default.
 */

@property (copy) NSNumber *success;

//@}

#pragma mark Configuration information
/** @name Configuration information */
//@{

/*!
 @brief Returns an array of strings, each containing a valid file extension
 accepted by Scribd.
 @result An array of acceptable file types.
 */

+ (NSArray *) scribdFileTypes;

//@}

#pragma mark Predicate methods
/** @name Predicate methods */
//@{

/*!
 @brief Tests if a file actually exists at the path stored by the document.
 @result @c YES if the path yields an actual file.
 */

- (BOOL) pointsToActualFile;

/*!
 @brief Tests if a file's URL is a remote URL.
 @result @c YES if the path refers to a remote resource; @c NO if the path
 refers to a local file on in the filesystem.
 @see URL
 */

- (BOOL) remoteFile;

/*!
 @brief Returns @c YES if the file is local and has a nonzero file size.
 @result @c YES if the file has a size suitable for calculations, @c NO if
 calculations on the file size should not be performed.
 @see totalBytes
 */

- (BOOL) hasSize;

//@}
@end
