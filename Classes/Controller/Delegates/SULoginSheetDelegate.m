#import "SULoginSheetDelegate.h"

@implementation SULoginSheetDelegate

/*
 Initializes value transformers used by the login sheet.
 */

+ (void) initialize {
	[NSValueTransformer setValueTransformer:[[[SUBusyActionValueTransformer alloc] init] autorelease] forName:@"SUBusyAction"];
}

/*
 Animates a window resize when the tab changes. Going from Sign Up to Log In, we
 want to resize the tab view after we draw the new content (to avoid clipping
 during animation), so this is in the did-select method.
 */

- (void) tabView:(NSTabView *)tabView didSelectTabViewItem:(NSTabViewItem *)tabViewItem {
	int height = 0;
	if ([[tabViewItem identifier] isEqualTo:@"login"]) {
		height = 248;
		[loginSignupButton setTitle:@"Log In"];
		[loginSignupButton setAction:@selector(login:)];
		NSRect frame = [[tabView window] frame];
		frame.origin.y -= (height - frame.size.height);
		frame.size.height = height;
		//[[[tabView window] animator] setFrame:frame display:YES];
		[[tabView window] setFrame:frame display:YES animate:YES];
	}
}

/*
 Animates a window resize when the tab changes. Going from Sign Up to Log In, we
 want to resize the tab view after we draw the new content (to avoid clipping
 during animation), so this is in the will-select method.
 */

- (void) tabView:(NSTabView *)tabView willSelectTabViewItem:(NSTabViewItem *)tabViewItem {
	int height = 0;
	if ([[tabViewItem identifier] isEqualTo:@"signup"]) {
		height = 365;
		[loginSignupButton setTitle:@"Sign Up"];
		[loginSignupButton setAction:@selector(signup:)];
		NSRect frame = [[tabView window] frame];
		frame.origin.y -= (height - frame.size.height);
		frame.size.height = height;
		//[[[tabView window] animator] setFrame:frame display:YES];
		[[tabView window] setFrame:frame display:YES animate:YES];
		// we can't use an animator because that creates a separate thread; we
		// need to force the redraw to wait until the animation is complete
	}
}

/*
 Called when the sheet is closed. The contextual info includes a string with the
 type of upload we are performing ("selection" or "all"), or "login" if we are
 logging in without moving to an upload.
 */

- (void) sheetDidEnd:(NSWindow *)endingSheet returnCode:(int)returnCode contextInfo:(void *)contextInfo {
	if (returnCode != NSRunContinuesResponse) {
		[sheet orderOut:self];
		return;
	}
	
	NSString *action = (NSString *)contextInfo;
	if (![action isEqualToString:@"login"]) [uploader uploadFiles]; //TODO "selection" or "all"
	[sheet orderOut:self];
}

- (IBAction) signup:(id)sender {
	if (sender) [NSThread detachNewThreadSelector:@selector(signup:) toTarget:self withObject:NULL];
	else {
		NSAutoreleasePool *pool = [[NSAutoreleasePool alloc] init];
		if ([uploader createAccount]) [[NSApplication sharedApplication] endSheet:sheet returnCode:NSRunContinuesResponse];
		[pool release];
	}
}

- (IBAction) login:(id)sender {
	if (sender) [NSThread detachNewThreadSelector:@selector(login:) toTarget:self withObject:NULL];
	else {
		NSAutoreleasePool *pool = [[NSAutoreleasePool alloc] init];
		if ([uploader authenticate]) [[NSApplication sharedApplication] endSheet:sheet returnCode:NSRunContinuesResponse];
		[pool release];
	}
}

- (IBAction) cancel:(id)sender {
	[[NSApplication sharedApplication] endSheet:sheet returnCode:NSRunStoppedResponse];
}

- (IBAction) showHelp:(id)sender {
	NSString *selectedTab = [[tabs selectedTabViewItem] identifier];
	NSString *anchor;
	if ([selectedTab isEqualToString:@"login"]) anchor = @"existing_account";
	else if ([selectedTab isEqualToString:@"signup"]) anchor = @"new_account";
	[[NSHelpManager sharedHelpManager] openHelpAnchor:anchor inBook:@"Scribd Uploader Help"];
}

@end
