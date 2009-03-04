#import "SUMultipleValuesToggleValueTransformer.h"

@implementation SUMultipleValuesToggleValueTransformer

#pragma mark Properties

@synthesize trueValue;
@synthesize falseValue;
@synthesize emptyValue;
@synthesize mixedValue;
@synthesize singularInsertions;
@synthesize pluralInsertions;

#pragma mark Initialization and deallocation

/*
 Releases local memory usage.
 */

- (void) dealloc {
	[trueValue release];
	[falseValue release];
	[emptyValue release];
	[mixedValue release];
	[singularInsertions release];
	[pluralInsertions release];
	[super dealloc];
}

#pragma mark Value transformer

/*
 This transformer converts between different subclasses of NSObject.
 */

+ (Class) transformedValueClass {
	return [NSObject class];
}

/*
 This is a one-directional transformer.
 */

+ (BOOL) allowsReverseTransformation {
	return NO;
}

/*
 Returns either trueValue or falseValue depending on the incoming value. The
 returned string has the plural or singular substitutions inserted depending on
 the size of the incoming value array.
 */

- (id) transformedValue:(id)value {
	NSArray *values = (NSArray *)value;
	
	if (!values || [values count] == 0) return emptyValue;
	
	BOOL allTrue = YES;
	BOOL allFalse = YES; // assume both are true; one or both will be disproven next
	for (NSNumber *booleanObject in values) {
		if ([booleanObject boolValue]) allFalse = NO;
		else allTrue = NO;
	}
	
	NSString *output;
	if (allTrue) output = trueValue;
	else if (allFalse) output = falseValue;
	else return mixedValue;
	
	NSArray *insertions;
	if ([values count] == 1) insertions = singularInsertions;
	else insertions = pluralInsertions;
	
	NSAutoreleasePool *pool = [[NSAutoreleasePool alloc] init]; // create a new pool cuz we're going to be autoreleasing a bunch of strings
	NSUInteger index;
	for (index = 0; index != [insertions count]; index++) {
		NSString *token = [NSString stringWithFormat:@"{%u}", index];
		output = [output stringByReplacingOccurrencesOfString:token withString:[insertions objectAtIndex:index]];
	}
	[output retain]; // don't release the output string with the pool
	[pool release];
	
	return [output autorelease]; // autorelease it because we've retained it and no one else has;
}


@end
