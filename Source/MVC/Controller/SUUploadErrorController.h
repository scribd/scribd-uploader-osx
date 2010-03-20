/*!
 @brief This class displays upload errors. Its
 @link SUUploadErrorController::displayError: displayError: @endlink method is
 invoked when the error button next to a file is clicked. This class is linked
 to a window that the error sheets will be modal for.
 @ingroup controller
 */

@interface SUUploadErrorController : NSObject {
	@private
		IBOutlet NSWindow *window;
}

#pragma mark Displaying an error
/** @name Displaying an error */
//@{

/*!
 @brief Runs the alert sheet for an document.
 @param document The document to display an error for.
 @details The error's localized description will become the main alert text,
 and the error's localized recovery suggestion will become the alert's
 informative text.
 
 If the document has been successfully uploaded (and thus the error button is a
 green arrow), this method opens the document's Scribd.com web page.
 @todo Use warning or critical alert styles depending on metadata for the error.
 */

- (IBAction) displayError:(SUDocument *)document;

//@}
@end
