#import "SUQuickLookDelegate.h"

@implementation SUQuickLookDelegate

#pragma mark Quick Look

/*
 Returns the rect that the Quick Look panel will animate from when opened. The
 rectOfRow method gives us a rect relative to the file list view. We need to
 first convert that to a rect relative to the window's content, then convert
 THAT to a rect of screen bounds.
 */

- (NSRect) previewPanel:(QLPreviewPanel *)panel sourceFrameOnScreenForPreviewItem:(id <QLPreviewItem>)item {
	if (!item) return NSZeroRect;
	
	// get the rect of the item
	NSRect rect = [fileListView frameForItemAtIndex:[[controller arrangedObjects] indexOfObject:panel.currentPreviewItem]];
	// shrink the rect to be only the icon preview
	rect.origin.x += 9;
	rect.origin.y += 9;
	rect.size.width = rect.size.height = 32;
	
	// determine if the rect is visible; return if not
	NSRect visibleRect = [fileListView visibleRect];
	if (!NSIntersectsRect(visibleRect, rect)) return NSZeroRect;
	
	// convert the rect from view-local coordinates to global coordinates
	rect = [fileListView convertRectToBase:rect];
	rect.origin = [[fileListView window] convertBaseToScreen:rect.origin];
	
	return rect;
}

/*
 Uses the Quick Look thumbnail image as the transition image (used as the Quick
 Look window grows).
 */

- (id) previewPanel:(QLPreviewPanel *)panel transitionImageForPreviewItem:(id <QLPreviewItem>)item contentRect:(NSRect *)contentRect {
	return ((SUDocument *)item).icon;
}

/*
 Redirect all key-down events to the parent view.
 */

- (BOOL) previewPanel:(QLPreviewPanel *)panel handleEvent:(NSEvent *)event {
	if ([event type] == NSKeyDown) {
		[fileListView keyDown:event];
		return YES;
	}
	return NO;
}

@end
