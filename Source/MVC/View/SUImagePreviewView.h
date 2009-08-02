/*!
 @class SUImagePreviewView
 @abstract A subclass of @link //apple_ref/occ/cl/NSImageView NSImageView @/link
 that renders a blank page and drop shadow behind its image.
 @discussion The background image is pulled from the Preview Background.png
 file in the application bundle.
 */

@interface SUImagePreviewView : NSImageView {
	@protected
		NSImage *background;
		NSPoint shadowOffsetFactor;
		NSSize contentSizeFactor;
}

@end
