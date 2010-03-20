/*!
 @brief This class manages the state of and responds to events from the Add URL
 window.
 @ingroup delegates
 */

@interface SUAddURLWindowController : NSObject {
	@private
		IBOutlet NSWindow *window;
		IBOutlet SUDatabaseHelper *db;
		IBOutlet SUImagePreviewView *preview;
		NSString *URLString;
		BOOL downloading;
		NSMutableData *previewImageData;
}

#pragma mark Properties

/*!
 @brief The text entered into the URL field.
 */

@property (retain) NSString *URLString;

/*!
 @brief @c YES if an image preview is in the process of being downloaded; @c NO
 if no downloading is occurring.
 */

@property (assign) BOOL downloading;

#pragma mark Actions
/** @name Actions */
//@{

/*!
 @brief Adds a new document by remote URL to the queue.
 @param sender The object that sent the action (unused).
 @details This method also closes the Add URL window and clears the text field
 for the next entry.
 */

- (IBAction) addURL:(id)sender;

/*!
 @brief Displays a contextually relevant help book page.
 @param sender The object that sent the action (unused).
 */

- (IBAction) showHelp:(id)sender;

//@}
@end
