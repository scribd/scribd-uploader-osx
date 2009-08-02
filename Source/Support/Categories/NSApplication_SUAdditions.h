/*!
 @category NSApplication(SUAdditions)
 @abstract Scribd Uploader-specific additions to
 @link //apple_ref/occ/cl/NSApplication NSApplication @/link.
 */

@interface NSApplication (SUAdditions)

#pragma mark Getting information about the operating system

/*!
 @method getSystemVersionMajor:minor:bugfix:
 @abstract Retrieves the version of Mac OS X the user is running. Sets the given
 pass-by-reference variables equal to the system version.
 @param major A pointer to an unsigned integer that will contain the OS's major
 revision number.
 @param minor A pointer to an unsigned integer that will contain the OS's minor
 revision number.
 @param bugfix A pointer to an unsigned integer that will contain the OS's
 bugfix number.
 */

- (void) getSystemVersionMajor:(NSUInteger *)major minor:(NSUInteger *)minor bugfix:(NSUInteger *)bugfix;

@end
