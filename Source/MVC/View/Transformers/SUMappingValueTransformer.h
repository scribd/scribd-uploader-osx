/*!
 @brief A basic value transformer that maps model objects to view values.
 @details Before using this object, assign a dictionary to the
 @link SUMappingValueTransformer::mappings mappings @endlink property. This
 dictionary maps model values to view values.
 @ingroup transformers
 */

@interface SUMappingValueTransformer : NSValueTransformer {
	@protected
		NSDictionary *mappings;
}

#pragma mark Properties

/*!
 @brief A dictionary of model keys mapped to view values.
 */

@property (retain) NSDictionary *mappings;

#pragma mark Initializing and deallocating
/** @name Initializing and deallocating */
//@{

/*!
 @brief Creates a new instance with the given dictionary of mappings.
 @param dictionary A dictionary that maps model keys to view values.
 @result The initialized instance.
*/

- (id) initWithDictionary:(NSDictionary *)dictionary;

//@}
@end
