#import "NSApplication_SUAdditions.h"

@implementation NSApplication (SUAdditions)

- (void) getSystemVersionMajor:(NSUInteger *)major minor:(NSUInteger *)minor bugfix:(NSUInteger *)bugfix {
	SInt32 systemVersion, versionMajor, versionMinor, versionBugfix;
	OSErr err = Gestalt(gestaltSystemVersion, &systemVersion);
	if (err == noErr) {
		if (systemVersion < 0x1040) {
			if (major) *major = ((systemVersion & 0xF000) >> 12) * 10 + ((systemVersion & 0x0F00) >> 8);
			if (minor) *minor = (systemVersion * 0x00F0) >> 4;
			if (bugfix) *bugfix = (systemVersion & 0x000F);
			return;
		}
		else {
			err = Gestalt(gestaltSystemVersionMajor, &versionMajor);
			if (err == noErr) {
				err = Gestalt(gestaltSystemVersionMinor, &versionMinor);
				if (err == noErr) {
					err = Gestalt(gestaltSystemVersionBugFix, &versionBugfix);
					if (err == noErr) {
						if (major) *major = versionMajor;
						if (minor) *minor = versionMinor;
						if (bugfix) *bugfix = versionBugfix;
						return;
					}
				}
			}
		}
	}
	
	NSLog(NSLocalizedString(@"Unable to obtain system version: %ld", NULL), (long)err);
	if (major) *major = 10;
	if (minor) *minor = 0;
	if (bugfix) *bugfix = 0;
}

@end
