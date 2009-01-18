/*!
 @class SUInformationPanelDelegate
 @abstract Receives events from the information panel. This class is also the
 delegate for the Tags token field.
 */

@interface SUInformationPanelDelegate : NSObject {
	IBOutlet SUDocumentArrayController *documentsController;
	IBOutlet NSTokenField *tagsField;
	IBOutlet NSDrawer *drawer;
	IBOutlet NSMenuItem *toggleDrawerItem;
}

/*!
 @method showHelp:
 @abstract Displays a relevant help topic.
 @param sender The object that sent the action.
 */

- (IBAction) showHelp:(id)sender;

/*!
 @method toggleMenuItem:
 @abstract Toggles the visibility of the information drawer and updates the
 title of the menu item.
 @param sender The object that sent the action.
 */

- (IBAction) toggleMenuItem:(id)sender;

@end
