@class SUCollectionView;

/*!
 @class SUQuickLookDelegate
 @abstract Interface for the Quick Look feature of Mac OS X 10.5 that allows
 users to get floating previews of their files.
 @discussion This class uses private Apple API's to the Quick Look technology.
 If Quick Look is not available (e.g., when running on an earlier version of OS
 X, this class disables itself.
 
 Thanks go to Ciarán Walsh for most of the code.
 http://ciaranwal.sh/2007/12/07/quick-look-apis
 */

@interface SUQuickLookDelegate : NSObject {
	@private
		BOOL useQuickLook;
		IBOutlet NSArrayController *filesController;
		IBOutlet SUCollectionView *fileListView;
		IBOutlet NSScrollView *scrollView;
}

#pragma mark Displaying the Quick Look panel

/*!
 @method toggleDisplay:
 @abstract Shows and hides the Quick Look preview pane.
 */

- (void) toggleDisplay;

@end
