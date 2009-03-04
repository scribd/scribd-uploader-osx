#import "SUAllowNilDateFormatter.h"

@implementation SUAllowNilDateFormatter

#pragma mark Converting Objects

/*
 Returns NULL if the string is blank, otherwise calls the superclass method.
 */

- (NSDate *) dateFromString:(NSString *)string {
	if (!string || [string isBlank]) return NULL;
	else return [super dateFromString:string];
}

/*
 Returns an empty string if the date is NULL, otherwise calls the superclass
 method.
 */

- (NSString *) stringFromDate:(NSDate *)date {
	if (!date) return @"";
	else return [super stringFromDate:date];
}

/*
 Sets the object pointed to by obj to NULL if the string is blank, otherwise
 calls the superclass method.
 */

- (BOOL) getObjectValue:(id *)obj forString:(NSString *)string range:(inout NSRange *)rangep error:(NSError **)error {
	if (!string || [string isBlank]) {
		*obj = NULL;
		return YES;
	}
	else return [super getObjectValue:obj forString:string range:rangep error:error];
}

@end
