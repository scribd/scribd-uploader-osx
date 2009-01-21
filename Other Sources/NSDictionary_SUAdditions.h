@interface NSDictionary (SUAdditions)

/*!
 @method initWithObject:forKey:
 @abstract Creates a new dictionary with a single key-value pair.
 @param object The value for the key.
 @param key The key name.
 @result The initialized instance.
 */

- (NSDictionary *) initWithObject:(id)object forKey:(NSString *)key;

@end
