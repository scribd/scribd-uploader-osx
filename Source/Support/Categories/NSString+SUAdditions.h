/*!
 @category NSString(SUAdditions)
 @abstract Utility methods for the
 @link //apple_ref/occ/cl/NSString NSString @/link class.
 */

@interface NSString (SUAdditions)

#pragma mark Identifying and Comparing Strings

/*!
 @method isEmpty
 @abstract Returns whether or not the string is empty (no characters).
 @result YES if the string is empty; NO if it is not.
 */

- (BOOL) isEmpty;

/*!
 @method isBlank
 @abstract Returns whether or not the string is only whitespace characters or
 empty.
 @result YES if the string is empty or is all whitespace characters; NO if it
 contains at least one printing character.
 */

- (BOOL) isBlank;

#pragma mark Determining Line and Paragraph Ranges

/*!
 @method lineCount
 @abstract Returns the number of lines in the string.
 @result The string's line count.
 */

- (NSUInteger) lineCount;

#pragma mark Working with URLs

/*!
 @method stringByURLEscapingUsingEncoding:
 @abstract Returns a string where all reserved or unsafe characters have been
 encoded using a percent-escape encoding scheme.
 @param encoding The string's encoding.
 @result The URL-encoded string.
 @discussion Unlike
 @link //apple_ref/occ/instm/NSString/stringByAddingPercentEscapesUsingEncoding: stringByAddingPercentEscapesUsingEncoding: @/link,
 this method also encodes URL-safe characters with special meanings, such as
 ampersand and question mark.
 */

- (NSString *) stringByURLEscapingUsingEncoding:(NSStringEncoding)encoding;

@end
