/*!
 @brief Utility additions to the @c NSDictionary class.
 @ingroup categories
 */

@interface NSDictionary (SUAdditions)

#pragma mark Initializing an NSDictionary Instance
/** @name Initializing an NSDictionary Instance */
//@{

/*!
 @brief Creates a new dictionary with a single key-value pair.
 @param object The value for the key.
 @param key The key name.
 @result The initialized instance.
 */

- (NSDictionary *) initWithObject:(id)object forKey:(NSString *)key;

//@}
@end
