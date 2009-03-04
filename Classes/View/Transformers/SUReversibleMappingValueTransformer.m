#import "SUReversibleMappingValueTransformer.h"

@implementation SUReversibleMappingValueTransformer

/*
 Ensures that a dictionary has a perfect hash before setting the mapping
 attribute.
 */

- (BOOL) validateMappings:(id *)dictionary error:(NSError **)error {
	if (*dictionary == NULL) return YES;
	
	// make sure dictionary is symmetric
	for (id value in [*dictionary values]) {
		if ([[*dictionary allKeysForObject:value] count] > 1) {
			NSDictionary *userInfo = [NSDictionary dictionaryWithObject:*dictionary forKey:SUInvalidObjectErrorKey];
			if (!error) *error = [NSError errorWithDomain:SUErrorDomain code:SUErrorCodeDictionaryMustBePerfect userInfo:userInfo];
			return NO;
		}
	}
	return YES;
}

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
	if ([keys count] > 1) {
		NSDictionary *userInfo = [NSDictionary dictionaryWithObject:mappings forKey:SUInvalidObjectErrorKey];
		[[NSError errorWithDomain:SUErrorDomain code:SUErrorCodeDictionaryMustBePerfect userInfo:userInfo] raise];
	}
	return NULL;
}

@end
