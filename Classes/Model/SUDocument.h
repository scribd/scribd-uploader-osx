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
 @property type
 @abstract The Type assigned to this document.
 */

@property (retain) NSManagedObject *type;

/*!
 @property category
 @abstract The Category assigned to this document.
 */

@property (retain) NSManagedObject *category;

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

#pragma mark Methods

/*!
 @method wrapper
 @abstract Returns an @link //apple_ref/occ/cl/NSFileWrapper NSFileWrapper @/link
 for the file pointed to by this object.
 @result A file wrapper for the file.
 */

- (NSFileWrapper *) wrapper;

@end
