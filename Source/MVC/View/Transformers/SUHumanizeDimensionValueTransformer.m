#import "SUHumanizeDimensionValueTransformer.h"

void SUReleaseUnit(SUHumanizeUnit *unit) {
	if (unit->next) SUReleaseUnit(unit->next);
	unit->next = NULL;
	[unit->name release];
	free(unit);
}

@implementation SUHumanizeDimensionValueTransformer

#pragma mark Initializing and deallocating

/*
 Require the designated initializer.
 */

- (id) init {
	[[NSException exceptionWithName:SUExceptionMustHaveRootUnit reason:@"Cannot initialize a SUHumanizeDimensionValueTransformer without a root unit" userInfo:NULL] raise];
}

- (id) initWithRootUnit:(NSString *)name {
	if (self = [super init]) {
		firstUnit = malloc(sizeof(SUHumanizeUnit));
		firstUnit->name = [name retain];
		firstUnit->value = 1;
		firstUnit->next = NULL;
		
		numberFormatter = [[NSNumberFormatter alloc] init];
		[numberFormatter setFormatterBehavior:[NSNumberFormatter defaultFormatterBehavior]];
	}
	return self;
}

/*
 Releases instance variables.
 */

- (void) dealloc {
	SUReleaseUnit(firstUnit);
	firstUnit = NULL;
	[numberFormatter release];
	[super dealloc];
}

#pragma mark Configuring

- (void) addUnitWithName:(NSString *)name sizeInRootUnits:(double)value {
	SUHumanizeUnit *unit = firstUnit;
	SUHumanizeUnit *prev = NULL;
	while (unit->value > value) {
		prev = unit;
		unit = unit->next;
	}
	
	SUHumanizeUnit *new = malloc(sizeof(SUHumanizeUnit));
	new->name = [name retain];
	new->value = value;
	new->next = unit;
	if (prev) prev->next = new;
	else firstUnit = new;
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
		
		SUHumanizeUnit *unit = firstUnit;
		double scalarInUnits;
		
		while (YES) {
			scalarInUnits = scalar/unit->value;
			if (scalarInUnits >= 1.0) break; // first unit whose value is at least 1
			if (unit->next) unit = unit->next; // advance to the next-smallest unit
			else break; // end of the line; use the smallest unit we've got
		}
		
		NSString *valueString = [numberFormatter stringFromNumber:[NSNumber numberWithLongLong:round(scalarInUnits)]];
		NSString *unitString = (round(scalarInUnits) == 1 ? unit->name : [[TMInflector inflector] pluralize:unit->name]);
		return [NSString stringWithFormat:NSLocalizedString(@"%@ %@", @"number and its unit"), valueString, unitString];
	}
	else if (!value || value == [NSNull null]) return NSLocalizedString(@"?", @"unknown numeric value");
	else return value;
}

@end
