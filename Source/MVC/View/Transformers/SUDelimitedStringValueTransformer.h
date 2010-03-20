/*!
 @brief Two-way value transformer that splits strings and joins arrays on a
 delimiting character.
 @details For the model-to-view transformation, a string of tags is split on the
 character to make an array. For the view-to-model transformation, an array of
 strings is joined using the delimiter.
 @ingroup transformers
 */

@interface SUDelimitedStringValueTransformer : NSValueTransformer {
	@protected
		NSString *delimiter;
}

#pragma mark Properties

/*!
 @brief The character this value transformer splits and joins strings and arrays
 on.
 */

@property (copy) NSString *delimiter;

#pragma mark Initializating and deallocating
/** @name Initializating and deallocating */
//@{

/*!
 @brief Initializes this value transformer using the comma as the delimiter.
 @result The initialized object.
 */

- (id) init;

/*!
 @brief Initializes this value transformer with a custom string delimiter.
 @param delim The string delimiter.
 @result The initialized object.
 @details This is the designated initializer.
 */

- (id) initWithDelimiter:(NSString *)delim;

//@}
@end
