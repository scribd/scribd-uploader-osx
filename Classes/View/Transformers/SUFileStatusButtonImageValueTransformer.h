/*!
 @class SUFileStatusButtonImageValueTransformer
 @abstract Converts a file status object into an icon representing the status of
 that document.
 @discussion A file status can either be NULL (no status), an
 @link //apple_ref/occ/cl/NSNumber NSNumber @/link equal to true (successfully
 uploaded), or an @link //apple_ref/occ/cl/NSError NSError @/link with info on
 the upload error that occurred. These possibilities will be translated into the
 "Go," "Caution" or "Error" icon resources, or NULL for no status.
 
 This value transformer can optionally be initialized with a suffix that will be
 appended to the file names; for instance, the suffix "Clicked" will yield
 "Error Clicked" when the file has an error.
 */

@interface SUFileStatusButtonImageValueTransformer : NSValueTransformer {
	NSImage *successImage, *cautionImage, *errorImage;
}

#pragma mark Initializing and deallocating

/*!
 @method initWithSuffix:
 @abstract Initializes the value transformer with a given suffix to append to
 image names.
 @param suffix The suffix to append to the base image names, or NULL if you wish
 to use no suffix.=.
 @result The initialized instance.
 @discussion This is the designated initializer.
 */

- (id) initWithSuffix:(NSString *)suffix;

@end
