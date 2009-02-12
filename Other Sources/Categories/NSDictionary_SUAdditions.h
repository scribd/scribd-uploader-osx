/*!
 @category NSArray(SUAdditions)
 @abstract Utility additions to the
 @link //apple_ref/occ/cl/NSDictionary NSDictionary @/link class.
 */

@interface NSDictionary (SUAdditions)

#pragma mark Initializing an NSDictionary Instance

/*!
 @method initWithObject:forKey:
 @abstract Creates a new dictionary with a single key-value pair.
 @param object The value for the key.
 @param key The key name.
 @result The initialized instance.
 */

- (NSDictionary *) initWithObject:(id)object forKey:(NSString *)key;

@end
