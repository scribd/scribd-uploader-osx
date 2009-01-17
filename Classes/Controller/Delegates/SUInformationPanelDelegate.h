/*!
 @class SUInformationPanelDelegate
 @abstract Receives events from the information panel. This class is also the
 delegate for the Tags token field.
 */

@interface SUInformationPanelDelegate : NSObject {
	IBOutlet SUDocumentArrayController *documentsController;
	IBOutlet NSPanel *categoriesPanel;
	IBOutlet NSTokenField *tagsField;
}

/*!
 @method changeCategory:
 @abstract Called when the Change category button is clicked. Displays a window
 where the currently selected document's category can be changed from a
 browsable hierarchy of categories.
 @param sender The object that sent the action.
 */

- (IBAction) changeCategory:(id)sender;

/*!
 @method showHelp:
 @abstract Displays a relevant help topic.
 @param sender The object that sent the action.
 */

- (IBAction) showHelp:(id)sender;

@end
