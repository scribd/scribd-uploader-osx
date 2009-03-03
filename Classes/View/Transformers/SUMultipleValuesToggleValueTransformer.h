/*!
 @class SUMultipleValuesToggleValueTransformer
 @abstract Similr to
 @link SUToggleValueTransformer SUToggleValueTransformer @/link, but takes an
 array of boolean values. Returns a string that depends on the incoming boolean
 values (whether they are all true, all false, or mixed) and is also
 appropriately worded in the singular or plural depending on the number of
 incoming boolean values (given as an array).
 
 An output string is specified using tokens such as "%{0}", "%{1}", etc. where
 the number refers to an index in the insertions array. The string at that index
 will be substituted for the token to generate the output string.
 */

@interface SUMultipleValuesToggleValueTransformer : NSValueTransformer {
	NSArray *singularInsertions, *pluralInsertions;
	NSString *trueValue, *falseValue, *emptyValue, *mixedValue;
}

#pragma mark Properties

/*!
 @property singularInsertions
 @abstract An array of strings to act as replacements for tokens in the output
 string, in the event that the value transformer receives an array of size one.
 */

@property (retain) NSArray *singularInsertions;

/*!
 @property pluralInsertions
 @abstract An array of strings to act as replacements for tokens in the output
 string, in the event that the value transformer receives an array of size other
 than one.
 */

@property (retain) NSArray *pluralInsertions;

/*!
 @property trueValue
 @abstract The string to return when asked to transform an array of all true
 values. This string will have tokens replaced with insertions according to the
 class docs.
 */

@property (retain) NSString *trueValue;

/*!
 @property falseValue
 @abstract The string to return when asked to transform an array of all false
 values. This string will have tokens replaced with insertions according to the
 class docs.
 */

@property (retain) NSString *falseValue;

/*!
 @property emptyValue
 @abstract The string to return when asked to transform an empty array. This
 string is not scanned for tokens.
 */

@property (retain) NSString *emptyValue;

/*!
 @property mixedValue
 @abstract The string to return when asked to transform a heterogeneous array.
 This string is not scanned for tokens.
 */

@property (retain) NSString *mixedValue;

@end
