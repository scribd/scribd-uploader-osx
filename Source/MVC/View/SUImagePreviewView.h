/*!
 @brief A subclass of @c NSImageView that renders a blank page and drop shadow
 behind its image.
 @details The background image is pulled from the <tt>Preview
 Background.png</tt> file in the application bundle.
 @ingroup view
 */

@interface SUImagePreviewView : NSImageView {
	@protected
		NSImage *background;
		NSPoint shadowOffsetFactor;
		NSSize contentSizeFactor;
}

@end
