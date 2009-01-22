/*!
 @class SUUploadErrorController
 @abstract This class displays upload errors. Its
 @link displayError: displayError: @/link method is invoked when the error
 button next to a file is clicked. This class is linked to a window that the
 error sheets will be modal for.
 */

@interface SUUploadErrorController : NSObject {
	IBOutlet NSWindow *window;
	IBOutlet SUDocumentArrayController *documentController;
}

/*!
 @method displayError:
 @abstract Runs the alert sheet for an error.
 @param errors An array of all upload errors.
 @param index The index of the error to display.
 @discussion The error's localized description will become the main alert text,
 and the error's localized recovery suggestion will become the alert's
 informative text.
 */

- (void) displayError:(NSArray *)errors atIndex:(NSNumber *)index;

@end
