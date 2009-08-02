/*!
 @class SUUploadErrorController
 @abstract This class displays upload errors. Its
 @link displayError: displayError: @/link method is invoked when the error
 button next to a file is clicked. This class is linked to a window that the
 error sheets will be modal for.
 */

@interface SUUploadErrorController : NSObject {
	@private
		IBOutlet NSWindow *window;
		IBOutlet SUDocumentArrayController *documentController;
}

#pragma mark Displaying an error

/*!
 @method displayError:
 @abstract Runs the alert sheet for an document.
 @param document The document to display an error for.
 @discussion The error's localized description will become the main alert text,
 and the error's localized recovery suggestion will become the alert's
 informative text.
 
 If the document has been successfully uploaded, this method opens the
 document's Scribd.com web page.
 */

- (IBAction) displayError:(SUDocument *)document;

@end
