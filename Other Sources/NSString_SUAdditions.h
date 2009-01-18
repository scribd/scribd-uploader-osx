/*!
 @category NSString (SUAdditions)
 @abstract Utility methods for strings.
 */

@interface NSString (SUAdditions)

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

/*!
 @method lineCount
 @abstract Returns the number of lines in the string.
 @result The string's line count.
 */

- (NSUInteger) lineCount;

@end
