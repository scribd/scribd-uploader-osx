/*!
 @brief Utility methods for the @c NSString class.
 @ingroup categories
 */

@interface NSString (SUAdditions)

#pragma mark Identifying and Comparing Strings
/** @name Identifying and Comparing Strings */
//@{

/*!
 @brief Returns whether or not the string is empty (no characters).
 @result YES if the string is empty; NO if it is not.
 */

- (BOOL) isEmpty;

/*!
 @brief Returns whether or not the string is only whitespace characters or
 empty.
 @result YES if the string is empty or is all whitespace characters; NO if it
 contains at least one printing character.
 */

- (BOOL) isBlank;

//@}

#pragma mark Determining Line and Paragraph Ranges
/** @name Determining Line and Paragraph Ranges */
//@{

/*!
 @brief Returns the number of lines in the string.
 @result The string's line count.
 @todo There has got to be a more efficient way of doing this.
 */

- (NSUInteger) lineCount;

//@}

#pragma mark Working with URLs
/** @name Working with URLs */
//@{

/*!
 @brief Returns a string where all reserved or unsafe characters have been
 encoded using a percent-escape encoding scheme.
 @param encoding The string's encoding.
 @result The URL-encoded string.
 @details Unlike @c stringByAddingPercentEscapesUsingEncoding:, this method also
 encodes URL-safe characters with special meanings, such as ampersand and
 question mark.
 */

- (NSString *) stringByURLEscapingUsingEncoding:(NSStringEncoding)encoding;

//@}
@end
