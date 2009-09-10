typedef struct _SUHumanizeUnit {
	NSString *name;
	double value;
	struct _SUHumanizeUnit *next;
} SUHumanizeUnit;

/*!
 @class SUHumanizeDimensionValueTransformer
 @abstract Converts a value in a root unit (such as seconds or bytes) into a
 value in an appropriate unit, returning a string consisting of the value
 (number formatted) and the unit appended together). The appropriate is unit is
 chosen as the unit whose value is the smallest while still being at least 1.
 @discussion Before it can be used, an instance must first have its units
 properly defined. The root unit is defined using the
 @link initWithRootUnit: designated initializer @/link. Use of the empty
 initializer init will raise an exception.
 
 Once the instance is created with a root unit, additional units are added using
 @link addUnitWithName:sizeInRootUnits: addUnitWithName:sizeInRootUnits: @/link.
 At this point the value transformer is ready to take input.
 */

@interface SUHumanizeDimensionValueTransformer : NSObject {
	@protected
		SUHumanizeUnit *firstUnit; // linked list of unit structs arranged in decreasing order of value
		NSNumberFormatter *numberFormatter;
}

#pragma mark Initializing and deallocating

/*!
 @method initWithRootUnit:
 @abstract The designated initializer creates a new instance and creates the
 root unit, the unit all other units will be in reference to.
 @param name The name of the root unit, singular, such as "second" for time.
 @result The initialized instance.
 @discussion You must use this and only this method to initialize your instance.
 */

- (id) initWithRootUnit:(NSString *)name;

#pragma mark Configuring

/*!
 @method addUnitWithName:sizeInRootUnits:
 @abstract Adds a unit relative to the root unit.
 @param name The name of the unit, singular, such as "minute".
 @param value The value of the unit in root units. If you were creating a
 time-dimension value transformer whose root unit was seconds, and you were
 defining the "minute" unit, you would use 60.
 */

- (void) addUnitWithName:(NSString *)name sizeInRootUnits:(double)value;

@end
