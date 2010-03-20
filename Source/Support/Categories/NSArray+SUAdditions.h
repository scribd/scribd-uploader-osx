/*!
 @brief Utility additions to the @c NSArray class.
 @ingroup categories
 */

@interface NSArray (SUAdditions)

#pragma mark Initializing an Array
/** @name Initializing an Array */
//@{

/*!
 @brief Initializes an array containing a single object.
 @param object The object to place in the new array.
 @result The initialized array.
 */

- (NSArray *) initWithObject:(id)object;

//@}

#pragma mark Deriving New Arrays
/** @name Deriving New Arrays */
//@{

/*!
 @brief Returns an array whose elements are in the reverse order of this array.
 @result A copy of this array with its elements reversed.
 */

- (NSArray *) reversedArray;

/*!
 @brief Returns a new array created by applying block to each element in this
 array.
 @param block The operation to perform on each element.
 @result A new array resulting from the map operation.
 */

- (NSArray *) map:(id (^)(id value))block;

//@}
@end
