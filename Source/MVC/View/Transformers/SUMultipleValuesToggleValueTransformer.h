/*!
 @brief Similar to SUToggleValueTransformer, but takes an array of boolean
 values. Returns a string that depends on the incoming boolean values (whether
 they are all true, all false, or mixed) and is also appropriately worded in the
 singular or plural depending on the number of incoming boolean values (given as
 an array).
 @details An output string is specified using tokens such as @c {0}, @c {1},
 etc. where the number refers to an index in the insertions array. The string at
 that index will be substituted for the token to generate the output string.
 @ingroup transformers
 */

@interface SUMultipleValuesToggleValueTransformer : NSValueTransformer {
	@protected
		NSArray *singularInsertions, *pluralInsertions;
		NSString *trueValue, *falseValue, *emptyValue, *mixedValue;
}

#pragma mark Properties

/*!
 @brief An array of strings to act as replacements for tokens in the output
 string, in the event that the value transformer receives an array of size one.
 */

@property (retain) NSArray *singularInsertions;

/*!
 @brief An array of strings to act as replacements for tokens in the output
 string, in the event that the value transformer receives an array of size other
 than one.
 */

@property (retain) NSArray *pluralInsertions;

/*!
 @brief The string to return when asked to transform an array of all true
 values. This string will have tokens replaced with insertions according to the
 class docs.
 */

@property (retain) NSString *trueValue;

/*!
 @brief The string to return when asked to transform an array of all false
 values. This string will have tokens replaced with insertions according to the
 class docs.
 */

@property (retain) NSString *falseValue;

/*!
 @brief The string to return when asked to transform an empty array. This string
 is not scanned for tokens.
 */

@property (retain) NSString *emptyValue;

/*!
 @brief The string to return when asked to transform a heterogeneous array. This
 string is not scanned for tokens.
 */

@property (retain) NSString *mixedValue;

@end
