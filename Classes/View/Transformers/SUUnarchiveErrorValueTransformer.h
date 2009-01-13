/*!
 @class SUUnarchiveErrorValueTransformer
 @abstract Unarchives an @link //apple_ref/occ/cl/NSError NSError @/link object
 from its serialized form before giving it to the view.
 @discussion In order to handle table columns, this class will also deserialize
 arrays of @link //apple_ref/occ/cl/NSData NSData @/link into arrays of
 NSErrors.
 */

@interface SUUnarchiveErrorValueTransformer : NSValueTransformer {
	
}

@end
