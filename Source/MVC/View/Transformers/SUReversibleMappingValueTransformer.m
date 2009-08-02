#import "SUReversibleMappingValueTransformer.h"

@implementation SUReversibleMappingValueTransformer

/*
 This is a two-way value transformer.
 */

+ (BOOL) allowsReverseTransformation {
	return YES;
}

/*
 Looks up a key in the mappings dictionary by value. Returns NULL if no such
 value is hashed. Raises an exception if more than one key maps to the value.
 */

- (id) reverseTransformedValue:(id)value {
	if (!value) value = [NSNull null];
	NSArray *keys = [mappings allKeysForObject:value];
	if ([keys count] == 1) {
		id result = [keys objectAtIndex:0];
		if ([result isEqualTo:[NSNull null]]) return NULL;
		else return result;
	}
	if ([keys count] > 1)
		[NSException raise:SUExceptionDictionaryMustBePerfect format:@"Tried to use a non-symmetrically perfect dictionary with SUReversibleMappingValueTransformer."];
	return NULL;
}

@end
