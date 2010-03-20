/*
 A unit and its multiplicative factor as used by
 SUHumanizeDimensionValueTransformer. Units of the same system are joined as a
 linked list, from smallest to largest, using the next field. The first unit of
 a system's linked list must have a value of 1.
 */

typedef struct _SUHumanizeUnit {
	/* The unit's name. */
	NSString *name;
	/*
	 The multiplicative factor of the unit, relative to the first unit
	 of the system's linked list.
	 */
	double value;
	/* A pointer to the the next largest unit in the system. */
	struct _SUHumanizeUnit *next;
} SUHumanizeUnit;

/*!
 @brief Converts a value in a root unit (such as seconds or bytes) into a value
 in an appropriate unit, returning a string consisting of the value (number
 formatted) and the unit appended together). The appropriate is unit is chosen
 as the unit whose value is the smallest while still being at least 1.
 @details Before it can be used, an instance must first have its units properly
 defined. The root unit is defined using the
 @link SUHumanizeDimensionValueTransformer::initWithRootUnit: designated initializer @endlink.
 Use of the empty initializer init will raise an exception.
 
 Once the instance is created with a root unit, additional units are added using
 @link SUHumanizeDimensionValueTransformer::addUnitWithName:sizeInRootUnits: addUnitWithName:sizeInRootUnits: @endlink.
 At this point the value transformer is ready to take input.
 @ingroup transformers
 */

@interface SUHumanizeDimensionValueTransformer : NSObject {
	@protected
		SUHumanizeUnit *firstUnit; // linked list of unit structs arranged in decreasing order of value
		NSNumberFormatter *numberFormatter;
}

#pragma mark Initializing and deallocating
/** @name Initializing and deallocating */
//@{

/*!
 @brief The designated initializer creates a new instance and creates the root
 unit, the unit all other units will be in reference to.
 @param name The name of the root unit, singular, such as @c second for time.
 @result The initialized instance.
 @details You must use this and only this method to initialize your instance.
 */

- (id) initWithRootUnit:(NSString *)name;

//@}

#pragma mark Configuring
/** @name Configuring */
//@{

/*!
 @brief Adds a unit relative to the root unit.
 @param name The name of the unit, singular, such as @c minute.
 @param value The value of the unit in root units. If you were creating a
 time-dimension value transformer whose root unit was seconds, and you were
 defining the @e minute unit, you would use 60.
 */

- (void) addUnitWithName:(NSString *)name sizeInRootUnits:(double)value;

//@}
@end
