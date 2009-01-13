/*!
 @class SUFileNotFoundAlertDelegate
 @discussion This class displays an alert when the upload list contains files
 that no longer exist.
 */

@interface SUFileNotFoundAlertDelegate : NSObject {
	IBOutlet NSWindow *window;
}

/*!
 @method showAlertFor:singleFileName:
 @abstract Displays an alert warning the users that files were removed from
 the list.
 @param deletedFiles The number of files that were removed from the list.
 @param filename If only one file was deleted, this parameter should contain
 the name of the deleted file.
 */

- (void) showAlertFor:(int)deletedFiles singleFileName:(NSString *)filename;

@end
