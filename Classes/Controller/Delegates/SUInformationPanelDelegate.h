/*!
 @class SUInformationPanelDelegate
 @abstract Receives events from the information panel. This class is also the
 delegate for the Tags token field.
 */

@interface SUInformationPanelDelegate : NSObject {
	IBOutlet SUDocumentArrayController *documentsController;
	IBOutlet NSTokenField *tagsField;
}

/*!
 @method showHelp:
 @abstract Displays a relevant help topic.
 @param sender The object that sent the action.
 */

- (IBAction) showHelp:(id)sender;

@end
