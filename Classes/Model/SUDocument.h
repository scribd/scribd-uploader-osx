/*!
 @class SUDocument
 @abstract Core Data object representing a document to be uploaded. Its entity
 name is "Document".
 @discussion This class adds file-specific operations and derived properties to
 the basic Core Data entity type, as well as some derived properties from the
 path and the metadata.
 */

@interface SUDocument : NSManagedObject {
	NSFileWrapper *wrapper;
	NSString *kind;
	NSObject *status;
}

#pragma mark First-order properties

/*!
 @property path
 @abstract The filesystem path to the file being uploaded.
 */

@property (copy) NSString *path;

/*!
 @property progress
 @abstract The fraction of the file which has been uploaded, as a value from 0.0
 to 1.0.
 */

@property (copy) NSNumber *progress;

/*!
 @property success
 @abstract YES if the file has been uploaded without error, NO if an error
 occurred, and NULL if the file has not completed upload yet.
 */

@property (copy) NSNumber *success;

/*!
 @property error
 @abstract A serialized @link //apple_ref/occ/cl/NSError NSError @/link with the
 last error returned by the server upon upload.
 */

@property (copy) NSData *error;

/*!
 @property errorIsUnrecoverable
 @abstract YES if the error was bad enough that the document was not uploaded;
 NO if the document was uploaded but another problem occurred.
 */

@property (copy) NSNumber *errorIsUnrecoverable;

/*!
 @property scribdID
 @abstract The Scribd.com ID given to this document, once it has been
 successfully uploaded.
 */

@property (copy) NSNumber *scribdID;

/*!
 @property hidden
 @abstract If YES, the document will be uploaded as private. If no, the document
 will be publically viewable.
 */

@property (copy) NSNumber *hidden;

/*!
 @property title
 @abstract The title to use for the Scribd document.
 */

@property (copy) NSString *title;

/*!
 @property summary
 @abstract The description to use for the Scribd document.
 */

@property (copy) NSString *summary;

/*!
 @property tags
 @abstract A comma-delimited list of tags to assign to the document.
 */

@property (copy) NSString *tags;

#pragma mark Relationships

/*!
 @property category
 @abstract The Category assigned to this document.
 */

@property (retain) SUCategory *category;

#pragma mark Derived properties

/*!
 @property filename
 @abstract The name of the file, derived from the path.
 @discussion This is a calculated property, and is not written to the persistent
 store.
 */

@property (readonly) NSString *filename;

/*!
 @property icon
 @abstract The icon for the file, derived from the path.
 @discussion This is a calculated property, and is not written to the persistent
 store.
 */

@property (readonly) NSImage *icon;

/*!
 @property kind
 @abstract The Finder description of the file's type, derived from the path.
 @discussion This is a calculated property, and is not written to the persistent
 store.
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
 @property isUploaded
 @abstract True if the file has been uploaded to Scribd.com; false if it hasn't
 yet been uploaded successfully.
 */

@property (readonly) BOOL isUploaded;

#pragma mark Class methods

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
 @method scribdFileTypes
 @abstract Returns an array of strings, each containing a valid file extension
 accepted by Scribd.
 @result An array of acceptable file types.
 */

+ (NSArray *) scribdFileTypes;

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

/*!
 @method createFromPath:inManagedObjectContext:
 @abstract Creates a new document record from a path.
 @param path The path to the file.
 @param managedObjectContext The managed object context to insert the document into.
 @result The newly created, unsaved document managed object.
 */

+ (SUDocument *) createFromPath:(NSString *)path inManagedObjectContext:(NSManagedObjectContext *)managedObjectContext;

#pragma mark Instance methods

/*!
 @method wrapper
 @abstract Returns an @link //apple_ref/occ/cl/NSFileWrapper NSFileWrapper @/link
 for the file pointed to by this object.
 @result A file wrapper for the file.
 */

- (NSFileWrapper *) wrapper;

/*!
 @method pointsToActualFile:
 @abstract Tests if a file actually exists at the path stored by the document.
 @result YES if the path yields an actual file.
 */

- (BOOL) pointsToActualFile;

@end
