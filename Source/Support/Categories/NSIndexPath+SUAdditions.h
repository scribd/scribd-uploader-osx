/*!
 @brief Utility additions to @c NSIndexPath.
 @ingroup categories
 */

@interface NSIndexPath (SUAdditions)

#pragma mark Deriving New Index Paths
/** @name Deriving New Index Paths */
//@{

/*!
 @brief Returns an index path identical to the receiver, except with the first
 index removed.
 @result The stripped index path.
 */

- (NSIndexPath *) indexPathByRemovingFirstIndex;

//@}
@end
