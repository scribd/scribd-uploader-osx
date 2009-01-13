/*!
 @class SUAboutWindowDelegate
 @abstract Responder for events in the About window.
 */

@interface SUAboutWindowDelegate : NSObject {

}

/*!
 @method showAboutHelp:
 @abstract Opens the help window with the About page open, where the user can
 then navigate to contact, license, and version history information.
 @param sender The object that called this method.
 */

- (IBAction) showAboutHelp:(id)sender;

@end
