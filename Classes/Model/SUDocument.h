/*!
 @class SUDocument
 @abstract Core Data object representing a document to be uploaded. Its entity
 name is "Document". Document paths are URL's (either filesystem or remote) that
 refer to a document.
 @discussion This class adds file- and URL-specific operations and derived
 properties to the basic Core Data entity type, as well as some derived
 properties from the path and the metadata.
 
 If the path is a filesystem URL (file://...), the file manager is used for many
 derived properties. If it is a remote URL (e.g., http://...), path splicing is
 used.
 */

@interface SUDocument : NSManagedObject {
	NSFileWrapper *wrapper;
	NSString *kind;
	NSURL *URL;
}

#pragma mark First-order properties

/*!
 @property path
 @abstract The URL string to the file being uploaded.
 @discussion This attribute is required and uniquely identifies a document. For
 files on the user's hard drive, it is a filesystem URL. For files over a
 network or on the Internet, it is a remote URL.
 */

@property (copy) NSString *path;

/*!
 @property progress
 @abstract The fraction of the file which has been uploaded, as a value from 0.0
 to 1.0.
 @discussion This attribute is set to 0.0 by default.
 */

@property (copy) NSNumber *progress;

/*!
 @property success
 @abstract YES if the file has been uploaded without error, NO if an error
 occurred, and NULL if the file has not completed upload yet.
 @discussion This attribute is set to NO by default.
 */

@property (copy) NSNumber *success;

/*!
 @property error
 @abstract A serialized @link //apple_ref/occ/cl/NSError NSError @/link with the
 last error returned by the server upon upload.
 @discussion This attribute is optional.
 */

@property (copy) NSData *error;

/*!
 @property errorIsUnrecoverable
 @abstract YES if the error was bad enough that the document was not uploaded;
 NO if the document was uploaded but another problem occurred.
 @discussion This attribute is optional.
 */

@property (copy) NSNumber *errorIsUnrecoverable;

/*!
 @property scribdID
 @abstract The Scribd.com ID given to this document, once it has been
 successfully uploaded.
 @discussion This attribute is nil by default.
 */

@property (copy) NSNumber *scribdID;

/*!
 @property hidden
 @abstract If YES, the document will be uploaded as private. If no, the document
 will be publically viewable.
 @discussion This attribute is set to NO by default.
 */

@property (copy) NSNumber *hidden;

/*!
 @property title
 @abstract The title to use for the Scribd document.
 @discussion This optional attribute is part of the document metadata.
 */

@property (copy) NSString *title;

/*!
 @property summary
 @abstract The description to use for the Scribd document.
 @discussion This optional attribute is part of the document metadata.
 */

@property (copy) NSString *summary;

/*!
 @property tags
 @abstract A comma-delimited list of tags to assign to the document.
 @discussion This optional attribute is part of the document metadata.
 */

@property (copy) NSString *tags;

/*!
 @property author
 @abstract The original author of this work.
 @discussion This optional attribute is part of the document publisher metadata.
 */

@property (copy) NSString *author;

/*!
 @property publisher
 @abstract The publisher of this edition of the work.
 @discussion This optional attribute is part of the document publisher metadata.
 */

@property (copy) NSString *publisher;

/*!
 @property edition
 @abstract The edition name or number of this publication of the work.
 @discussion This optional attribute is part of the document publisher metadata.
 */

@property (copy) NSString *edition;

/*!
 @property datePublished
 @abstract The date this edition of the work was first published.
 @discussion Only the day portion of this date will be sent to the Scribd.com
 server. The time portion will be stripped.
 
 This optional attribute is part of the document publisher metadata.
 */

@property (copy) NSDate *datePublished;

/*!
 @property license
 @abstract The license under which this work is distributed.
 @discussion This is either a Creative Commons abbreviated license name (e.g.,
 "by-sa" for Attribution share alike), "pd" for public domain, or "c" for
 traditional copyright.
 
 This attribute is part of the document publisher metadata.
 */

@property (copy) NSString *license;

#pragma mark Relationships

/*!
 @property category
 @abstract The Category assigned to this document.
 */

@property (retain) SUCategory *category;

#pragma mark Dynamic properties

/*!
 @property URL
 @abstract The URL object for the path.
 @discussion This is a calculated property, and is not written to the persistent
 store.
 */

@property (readonly) NSURL *URL;

/*!
 @property fileSystemPath
 @abstract The path to the file as used by the file system.
 @discussion This is a calculated property, and is not written to the persistent
 store.
 */

@property (readonly) NSString *fileSystemPath;

/*!
 @property filename
 @abstract The name of the file, derived from the path.
 @discussion For local files, the file manager's default representation is used.
 For remote files, the filename portion of the path is used.
 
 This is a calculated property, and is not written to the persistent store.
 */

@property (readonly) NSString *filename;

/*!
 @property icon
 @abstract The icon for the file, derived from the path.
 @discussion For local files, the file manager is used to retrieve the icon. For
 remote files, a default image for the file extension is used.
 
 This is a calculated property, and is not written to the persistent store.
 */

@property (readonly) NSImage *icon;

/*!
 @property kind
 @abstract A description of the file's type, derived from the path.
 @discussion The FileTypes.plist file is used to retrieve a description of a
 path from its file extension.
 
 This is a calculated property, and is not written to the persistent store.
 */

@property (readonly) NSString *kind;

/*!
 @property discoverability
 @abstract A numerical index of how easy it is for others to find this document
 in normal searching.
 @discussion The discoverability is based on the length of the title and summary
 as well as the presence of other metadata.
 */

@property (readonly) NSNumber *discoverability;

/*!
 @property scribdURL
 @abstract Returns a URL at which the Scribd document can be viewed.
 @discussion The URL for the Scribd document, or NULL if the document hasn't
 been uploaded yet.
 */

@property (readonly) NSURL *scribdURL;

/*!
 @property editURL
 @abstract Returns a URL at which the Scribd document can be edited.
 @discussion The URL to bulk-edit the Scribd document, or NULL if the document
 hasn't been uploaded yet.
 */

@property (readonly) NSURL *editURL;

/*!
 @property errorLevel
 @abstract A string describing the error state of this document.
 @discussion "Success" if no error has occurred, "Caution" if the document was
 uploaded but an error occurred, "Error" if an error occurred preventing the
 document from being uploaded, or "Pending" if no upload has occurred yet.
 */

@property (readonly) NSString *errorLevel;

/*!
 @property uploaded
 @abstract True if the file has been uploaded to Scribd.com; false if it hasn't
 yet been uploaded successfully.
 */

@property (readonly) BOOL uploaded;

#pragma mark Finding documents

/*!
 @method findByPath:inManagedObjectContext:
 @abstract Finds a document by its path. Assumes that only one or zero
 document object(s) will exist with that path.
 @param path The path to search by.
 @param managedObjectContext The managed object context to search in.
 @result The document with that path, or NULL if no such document was found.
 */

+ (SUDocument *) findByPath:(NSString *)path inManagedObjectContext:(NSManagedObjectContext *)managedObjectContext;

/*!
 @method findAllInManagedObjectContext:error:
 @abstract Returns an array of every document in the context.
 @param managedObjectContext The managed object context.
 @param error Stores any errors in fetching the documents.
 @result An array of all documents.
 */

+ (NSArray *) findAllInManagedObjectContext:(NSManagedObjectContext *)managedObjectContext error:(NSError **)error;

/*!
 @method findUploadableInManagedObjectContext:error:
 @abstract Returns an array of every document in the context that has not yet
 been successfully uploaded.
 @param managedObjectContext The managed object context.
 @param error Stores any errors in fetching the documents.
 @result An array of all pending documents.
 @discussion Documents that have been uploaded but have not successfully had
 their settings set will not be included in the result.
 */

+ (NSArray *) findUploadableInManagedObjectContext:(NSManagedObjectContext *)managedObjectContext error:(NSError **)error;

/*!
 @method findUploadedInManagedObjectContext:error:
 @abstract Returns an array of every document in the context that has been
 successfully uploaded.
 @param managedObjectContext The managed object context.
 @param error Stores any errors in fetching the documents.
 @result An array of all completed documents.
 */

+ (NSArray *) findUploadedInManagedObjectContext:(NSManagedObjectContext *)managedObjectContext error:(NSError **)error;

/*!
 @method numberOfUploadableInManagedObjectContext:error:
 @abstract Returns the total number of documents in the context that have not
 been successfully uploaded.
 @param managedObjectContext The managed object context.
 @param error Stores any errors in fetching the document count.
 @result The number of documents yet to be uploaded, or zero if an error
 occurred.
 @discussion Documents that were uploaded but could not have their settings
 changed will not be included in this count, as they have already been uploaded.
 */

+ (NSUInteger) numberOfUploadableInManagedObjectContext:(NSManagedObjectContext *)managedObjectContext error:(NSError **)error;

#pragma mark Creating new records

/*!
 @method createFromPath:inManagedObjectContext:
 @abstract Creates a new document record from a path.
 @param path The path to the file.
 @param managedObjectContext The managed object context to insert the document into.
 @result The newly created, unsaved document managed object.
 */

+ (SUDocument *) createFromPath:(NSString *)path inManagedObjectContext:(NSManagedObjectContext *)managedObjectContext;

#pragma mark Configuration information

/*!
 @method scribdFileTypes
 @abstract Returns an array of strings, each containing a valid file extension
 accepted by Scribd.
 @result An array of acceptable file types.
 */

+ (NSArray *) scribdFileTypes;

#pragma mark Pseudo-properties

/*!
 @method wrapper
 @abstract Returns an @link //apple_ref/occ/cl/NSFileWrapper NSFileWrapper @/link
 for the file pointed to by this object.
 @result A file wrapper for the file.
 */

- (NSFileWrapper *) wrapper;

/*!
 @method pointsToActualFile
 @abstract Tests if a file actually exists at the path stored by the document.
 @result YES if the path yields an actual file.
 */

- (BOOL) pointsToActualFile;

/*!
 @method isRemoteFile
 @abstract Tests if a file's URL is a remote URL.
 @result YES if the path refers to a remote resource; NO if the path refers to
 a local file on in the filesystem.
 */

- (BOOL) isRemoteFile;

@end
