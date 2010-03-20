/*!
 @brief Value transformer that returns one value if given a true or
 true-equivalent value, and false if given a false or false-equivalent value.
 @ingroup transformers
 */

@interface SUToggleValueTransformer : NSValueTransformer {
	@protected
		NSObject *trueValue, *falseValue;
}

#pragma mark Properties

/*!
 @brief Value returned by the value transformer when given true or not null.
 */

@property (retain) NSObject *trueValue;

/*!
 @brief Value returned by the value transformer when given false or @c NULL.
 */

@property (retain) NSObject *falseValue;

#pragma mark Initializing and deallocating
/** @name Initializing and deallocating */
//@{

/*!
 @brief Creates a new value transformer that returns the given values for true
 or false, respectively.
 @param whenTrue Returned when the value transformer receives true values.
 @param whenFalse Returned when the value transformer receives false values.
 @result The initialized instance.
 */

- (id) initWithTrueValue:(NSObject *)whenTrue falseValue:(NSObject *)whenFalse;

//@}
@end
