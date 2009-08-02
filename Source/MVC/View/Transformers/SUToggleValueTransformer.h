/*!
 @class SUToggleValueTransformer
 @abstract Value transformer that returns one value if given a true or
 true-equivalent value, and false if given a false or false-equivalent value.
 */

@interface SUToggleValueTransformer : NSValueTransformer {
	@protected
		NSObject *trueValue, *falseValue;
}

#pragma mark Properties

/*!
 @property trueValue
 @abstract Value returned by the value transformer when given true or not null.
 */

@property (retain) NSObject *trueValue;

/*!
 @property falseValue
 @abstract Value returned by the value transformer when given false or null.
 */

@property (retain) NSObject *falseValue;

#pragma mark Initializing and deallocating

/*!
 @method initWithTrueValue:falseValue:
 @abstract Creates a new value transformer that returns the given values for
 true or false, respectively.
 @param whenTrue Returned when the value transformer receives true.
 @param whenFalse Returned when the value transformer receives false.
 @result The initialized instance.
 */

- (id) initWithTrueValue:(NSObject *)whenTrue falseValue:(NSObject *)whenFalse;

@end
