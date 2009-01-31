/*!
 @category NSIndexPath(SUAdditions)
 @abstract Utility additions to
 @link //apple_ref/occ/cl/NSIndexPath NSIndexPath @/link.
 */

@interface NSIndexPath (SUAdditions)

/*!
 @method indexPathByRemovingFirstIndex
 @abstract Returns an index path identical to the receiver, except with the
 first index removed.
 @result The stripped index path.
 */

- (NSIndexPath *) indexPathByRemovingFirstIndex;

@end
