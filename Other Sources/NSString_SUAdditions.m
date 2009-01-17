#import "NSString_SUAdditions.h"

@implementation NSString (SUAdditions)

- (BOOL) isEmpty {
	return [self isEqualToString:@""];
}

- (NSUInteger) lineCount {
	//TODO there has got to be a more efficient way of doing this
	return [[self componentsSeparatedByCharactersInSet:[NSCharacterSet newlineCharacterSet]] count];
}

@end
