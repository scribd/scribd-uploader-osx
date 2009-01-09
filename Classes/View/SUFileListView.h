#import <Cocoa/Cocoa.h>
#import "SUQuickLookDelegate.h"

/*!
 @class SUFileListView
 @abstract A simple subclass of
 @link //apple_ref/occ/cl/NSScrollView NSScrollView @/link that checks key-down
 events for a spacebar press. If detected, it tells the
 @link SUQuickLookDelegate SUQuickLookDelegate @/link to toggle the Quick Look
 preview pane.
 */

@interface SUFileListView : NSScrollView {
	IBOutlet SUQuickLookDelegate *quickLook;
}

@end
