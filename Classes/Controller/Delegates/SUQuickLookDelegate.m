#import "SUQuickLookDelegate.h"

#define QLPreviewPanel NSClassFromString(@"QLPreviewPanel")

@implementation SUQuickLookDelegate

/*
 Checks for Quick Look support and observes changes in file selection.
 */

- (void) awakeFromNib {
	if ([[NSBundle bundleWithPath:@"/System/Library/PrivateFrameworks/QuickLookUI.framework"] load]) useQuickLook = YES;
	else useQuickLook = NO;
	
	if (useQuickLook) {
		[filesController addObserver:self forKeyPath:@"selectedObjects" options:NSKeyValueObservingOptionNew context:NULL];
		[[[QLPreviewPanel sharedPreviewPanel] windowController] setDelegate:self];
	}
}

/*
 Returns the rect that the Quick Look panel will animate from when opened. The
 rectOfRow method gives us a rect relative to the file list view. We need to
 first convert that to a rect relative to the window's content, then convert
 THAT to a rect of screen bounds.
 */

- (NSRect) previewPanel:(NSPanel*)panel frameForURL:(NSURL*)URL {
	NSRect rect = [table convertRectToBase:[table rectOfRow:[filesController selectionIndex]]];
	rect.origin = [[table window] convertBaseToScreen:rect.origin];
	return rect;
}

/*
 Updates the Quick Look source list.
 */

- (void) observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary *)change context:(void *)context {
	if (!useQuickLook) {
		if (![keyPath isEqualToString:@"selectedObjects"]) [super observeValueForKeyPath:keyPath ofObject:object change:change context:context];
		return;
	}
	if ([keyPath isEqualToString:@"selectedObjects"]) {
		NSMutableArray *URLs = [NSMutableArray arrayWithCapacity:[filesController.arrangedObjects count]];
		for (NSString *path in [filesController valueForKeyPath:@"arrangedObjects.path"]) [URLs addObject:[NSURL fileURLWithPath:path]];
		if ([filesController selectionIndex] == NSNotFound)
			[[QLPreviewPanel sharedPreviewPanel] setURLs:URLs currentIndex:-1 preservingDisplayState:YES];
		else
			[[QLPreviewPanel sharedPreviewPanel] setURLs:URLs currentIndex:[filesController selectionIndex] preservingDisplayState:YES];
	}
	else [super observeValueForKeyPath:keyPath ofObject:object change:change context:context];
}

- (void) toggleDisplay {
	if (!useQuickLook) return;
	if ([[QLPreviewPanel sharedPreviewPanel] isOpen])
		[[QLPreviewPanel sharedPreviewPanel] closeWithEffect:2];
	else
		[[QLPreviewPanel sharedPreviewPanel] makeKeyAndOrderFrontWithEffect:2];
}



@end
