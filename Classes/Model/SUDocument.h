#import <CoreData/CoreData.h>

/*!
 @class SUDocument
 @discussion Core Data object describing a document to be uploaded. This
 class adds file-specific operations and derived properties to the basic
 Core Data entity type.
 */


@interface SUDocument : NSManagedObject {
	NSFileWrapper *wrapper;
	NSString *kind;
	NSObject *status;
}

/*!
 @method wrapper
 @abstract Returns an @link //apple_ref/occ/cl/NSFileWrapper NSFileWrapper @/link
 for the file pointed to by this object.
 @result A file wrapper for the file.
 */

- (NSFileWrapper *) wrapper;

/*!
 @property path
 @abstract The filesystem path to the file being uploaded.
 */

@property (retain) NSString *path;

/*!
 @property progress
 @abstract The fraction of the file which has been uploaded, as a value from 0.0
 to 1.0.
 */

@property (retain) NSNumber *progress;

/*!
 @property success
 @abstract YES if the file has been uploaded without error, NO if an error
 occurred, and NULL if the file has not completed upload yet.
 */

@property (retain) NSNumber *success;

/*!
 @property error
 @abstract A serialized @link //apple_ref/occ/cl/NSError NSError @/link with the
 last error returned by the server upon upload.
 */

@property (retain) NSData *error;

/*!
 @property filename
 @abstract The name of the file, derived from the path.
 @discussion This is a calculated property, and is not written to the persistent
 store.
 */

@property (nonatomic, readonly) NSString *filename;

/*!
 @property icon
 @abstract The icon for the file, derived from the path.
 @discussion This is a calculated property, and is not written to the persistent
 store.
 */

@property (nonatomic, readonly) NSImage *icon;

/*!
 @property kind
 @abstract The Finder description of the file's type, derived from the path.
 @discussion This is a calculated property, and is not written to the persistent
 store.
 */

@property (nonatomic, readonly) NSString *kind;

@end
