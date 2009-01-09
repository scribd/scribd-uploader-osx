#import <Cocoa/Cocoa.h>

/*!
 @class SUFileStatusButtonImageValueTransformer
 @abstract Converts a file status object into an icon representing the status of
 that document.
 @discussion A file status can either be NULL (no status), an
 @link //apple_ref/occ/cl/NSNumber NSNumber @/link equal to true (successfully
 uploaded), or an @link //apple_ref/occ/cl/NSError NSError @/link with info on
 the upload error that occurred. These possibilities will be translated into the
 "success.tif" or "error.tif" icon resources, or NULL for no status.
 */

@interface SUFileStatusButtonImageValueTransformer : NSValueTransformer {
	NSImage *successImage, *errorImage;
}

@end
