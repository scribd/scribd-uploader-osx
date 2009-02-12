@interface NSApplication (SUAdditions)

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
