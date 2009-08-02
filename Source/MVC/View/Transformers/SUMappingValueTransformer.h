/*!
 @class SUMappingValueTransformer
 @abstract A basic value transformer that maps model objects to view values.
 @discussion Before using this object, assign a dictionary to the
 @link mappings mappings @/link property. This dictionary maps model values to
 view values.
 */

@interface SUMappingValueTransformer : NSValueTransformer {
	@protected
		NSDictionary *mappings;
}

#pragma mark Properties

/*!
 @property mappings
 @abstract A dictionary of model keys mapped to view values.
 */

@property (retain) NSDictionary *mappings;

#pragma mark Initializing and deallocating

/*!
 @method initWithDictionary:
 @abstract Creates a new instance with the given dictionary of mappings.
 @param dictionary A dictionary that maps model keys to view values.
 @result The initialized instance.
*/

- (id) initWithDictionary:(NSDictionary *)dictionary;

@end
