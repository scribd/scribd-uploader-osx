/*!
 @brief Scribd Uploader-specific additions to @c NSApplication.
 @ingroup categories
 */

@interface NSApplication (SUAdditions)

#pragma mark Getting information about the operating system
/** @name Getting information about the operating system */
//@{

/*!
 @brief Retrieves the version of Mac OS X the user is running. Sets the given
 pass-by-reference variables equal to the system version.
 @param major A pointer to an unsigned integer that will contain the OS's major
 revision number.
 @param minor A pointer to an unsigned integer that will contain the OS's minor
 revision number.
 @param bugfix A pointer to an unsigned integer that will contain the OS's
 bugfix number.
 */

- (void) getSystemVersionMajor:(NSUInteger *)major minor:(NSUInteger *)minor bugfix:(NSUInteger *)bugfix;

//@}
@end
