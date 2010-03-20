/*!
 @brief Unarchives an @c NSError object from its serialized form before giving
 it to the view.
 @details In order to handle table columns, this class will also deserialize
 arrays of @c NSData into arrays of <tt>NSError</tt>s.
 @ingroup transformers
 */

@interface SUUnarchiveErrorValueTransformer : NSValueTransformer {
	
}

@end
