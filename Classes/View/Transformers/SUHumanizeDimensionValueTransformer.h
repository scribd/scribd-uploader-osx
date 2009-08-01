/*!
 @class SUHumanizeDimensionValueTransformer
 @abstract Converts a value in a root unit (such as seconds or bytes) into a
 value in an appropriate unit, returning a string consisting of the value
 (number formatted) and the unit appended together). The appropriate is unit is
 chosen as the unit whose value is the smallest while still being at least 1.
 @discussion Before it can be used, an instance must first have its
 @link units units @/link property defined, as well as the
 @link rootUnit rootUnit @/link property. See the properties documentation for
 more information. 
 */

@interface SUHumanizeDimensionValueTransformer : NSObject {
	NSDictionary *units;
	NSString *rootUnit;
	NSNumberFormatter *numberFormatter;
}

#pragma mark Properties

/*!
 @property units
 @abstract A dictionary mapping unit names (or abbreviations, depending on how
 you want the units to appear in the view) with the the inverse of the
 conversion factor. Stated another way, the value for each key is the quantity
 of root units necessary to equal one of the key unit.
 @discussion As an example, if we were constructing a time humanizer, the keys
 might be "minute", "hour", and "day", and the values would be, respectively,
 60, 3600, and 86400, as these are the number of seconds in each of the key
 units.
 */

@property (retain) NSDictionary *units;

/*!
 @property rootUnit
 @abstract The key in the @link units units @/link dictionary that corresponds
 to a value of 1. This is the root unit in the unit system and must exist in the
 dictionary.
 */

@property (retain) NSString *rootUnit;

@end
