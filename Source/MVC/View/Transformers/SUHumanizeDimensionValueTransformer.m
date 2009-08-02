#import "SUHumanizeDimensionValueTransformer.h"

@implementation SUHumanizeDimensionValueTransformer

#pragma mark Properties

@synthesize units;
@synthesize rootUnit;

#pragma mark Initializing and deallocating

/*
 Initialize instance variables.
 */

- (id) init {
	if (self = [super init]) {
		units = [[NSDictionary alloc] init];
		numberFormatter = [[NSNumberFormatter alloc] init];
		[numberFormatter setFormatterBehavior:[NSNumberFormatter defaultFormatterBehavior]];
	}
	return self;
}

/*
 Releases instance variables.
 */

- (void) dealloc {
	[units release];
	[rootUnit release];
	[numberFormatter release];
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
 Converts a number in the root unit to a number in a more appropriate unit. The
 unit chosen will be the largest unit for which its value is greater than or
 equal to one.
 */

- (id) transformedValue:(id)value {
	if ([value isKindOfClass:[NSNumber class]]) {
		double scalar = [(NSNumber *)value doubleValue];
		if (scalar <= 0.0) return NSLocalizedString(@"?", @"unknown numeric value");
		
		NSString *largestUnit = NULL;
		double largestUnitScalar;
		
		if (scalar <= 1.0) {
			largestUnit = self.rootUnit;
			largestUnitScalar = scalar;
		}
		else {
			for (NSString *unit in self.units) {
				double thisUnitScalar = scalar/[[self.units objectForKey:unit] doubleValue];
				if ((!largestUnit || thisUnitScalar < largestUnitScalar) && thisUnitScalar >= 1.0) {
					largestUnitScalar = thisUnitScalar;
					largestUnit = unit;
				}
			}
		}
		
		NSString *valueString = [numberFormatter stringFromNumber:[NSNumber numberWithLongLong:round(largestUnitScalar)]];
		return [NSString stringWithFormat:NSLocalizedString(@"%@ %@", @"number and its unit"), valueString, largestUnit];
	}
	else if (!value || value == [NSNull null]) return NSLocalizedString(@"?", @"unknown numeric value");
	else return value;
}

@end
