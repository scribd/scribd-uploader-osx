#import "NSString_SUAdditions.h"

@implementation NSString (SUAdditions)

- (BOOL) isEmpty {
	return [self isEqualToString:@""];
}

- (BOOL) isBlank {
	NSUInteger index;
	for (index = 0; index != [self length]; index++)
		if (![[NSCharacterSet whitespaceCharacterSet] characterIsMember:[self characterAtIndex:index]]) return NO;
	return YES;
}

- (NSUInteger) lineCount {
	//TODO there has got to be a more efficient way of doing this
	return [[self componentsSeparatedByCharactersInSet:[NSCharacterSet newlineCharacterSet]] count];
}

@end
