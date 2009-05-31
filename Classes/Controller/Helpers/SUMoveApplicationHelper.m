#import "SUMoveApplicationHelper.h"

static NSString *SUDefaultKeyHasCheckedApplicationFolder = @"SUHasCheckedApplicationFolder";
static NSString *newPath = NULL;

@interface SUMoveApplicationHelper (Private)

- (BOOL) shouldCheckApplicationFolder;
- (BOOL) applicationIsInApplicationsFolder;
- (void) displayAlert;
- (void) moveApplication;
- (void) displayMoveError:(NSError *)error;
- (void) setHasCheckedFolder;
- (void) relaunch;

- (NSString *) currentPath;
- (NSString *) newPath;

@end

@implementation SUMoveApplicationHelper

- (void) checkApplicationFolder {
	if ([self shouldCheckApplicationFolder]) {
		if (![self applicationIsInApplicationsFolder]) [self displayAlert];
		[self setHasCheckedFolder];
	}
}

@end

@implementation SUMoveApplicationHelper (Private)

- (BOOL) shouldCheckApplicationFolder {
	return ![[NSUserDefaults standardUserDefaults] boolForKey:SUDefaultKeyHasCheckedApplicationFolder];
}

- (BOOL) applicationIsInApplicationsFolder {
	NSArray *appPath = [[self currentPath] pathComponents];
	return ([[appPath objectAtIndex:([appPath count] - 2)] isEqualToString:@"Applications"]);
}

- (void) displayAlert {
	NSAlert *alert = [[NSAlert alloc] init];
	[alert setMessageText:NSLocalizedString(@"Would you like to place Scribd Uploader in the Applications folder?", NULL)];
	[alert setInformativeText:NSLocalizedString(@"Most applications are installed into this folder, but you can run this program from any folder if you wish.", @"this = the Applications folder")];
	[alert setAlertStyle:NSInformationalAlertStyle];
	[alert addButtonWithTitle:NSLocalizedString(@"Move", @"this program to a different folder")];
	[alert addButtonWithTitle:NSLocalizedString(@"Don't Move", @"this program to a different folder")];
	[alert setShowsHelp:YES];
	[alert setHelpAnchor:@"move_application"];
	NSInteger result = [alert runModal];
	if (result == NSAlertFirstButtonReturn) [self moveApplication];
	[alert release];
}

- (void) moveApplication {
	NSError *error = NULL;
	BOOL result = [[NSFileManager defaultManager] copyItemAtPath:[self currentPath] toPath:[self newPath] error:&error];
	if (result) {
		NSArray *files = [[NSArray alloc] initWithObject:[[self currentPath] lastPathComponent]];
		NSInteger tag = 0;
		[[NSWorkspace sharedWorkspace] performFileOperation:NSWorkspaceRecycleOperation source:[[self currentPath] stringByDeletingLastPathComponent] destination:@"" files:files tag:&tag];
		[files release];
		[self relaunch];
	}
	else [self displayMoveError:error];
	
}

- (void) displayMoveError:(NSError *)error {
	NSAlert *alert = [[NSAlert alloc] init];
	[alert setAlertStyle:NSCriticalAlertStyle];
	[alert setMessageText:NSLocalizedString(@"Scribd Uploader could not be copied to the Applications folder.", NULL)];
	[alert setInformativeText:[error localizedDescription]];
	[alert addButtonWithTitle:NSLocalizedString(@"OK", @"command")];
	[alert runModal];
	[alert release];
}

- (void) setHasCheckedFolder {
	[[NSUserDefaults standardUserDefaults] setBool:YES forKey:SUDefaultKeyHasCheckedApplicationFolder];
}

- (void) relaunch {
	[[NSWorkspace sharedWorkspace] openFile:[self newPath]];
	[[NSApplication sharedApplication] terminate:self];
}

- (NSString *) currentPath {
	return [[NSBundle mainBundle] bundlePath];
}

- (NSString *) newPath {
	if (!newPath) {
		NSString *bundleName = [[self currentPath] lastPathComponent];
		newPath = [[@"/Applications" stringByAppendingPathComponent:bundleName] retain];
	}
	return newPath;
}

@end
