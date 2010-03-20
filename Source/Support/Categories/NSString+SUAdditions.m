#import "NSString+SUAdditions.h"

@implementation NSString (SUAdditions)

#pragma mark Identifying and Comparing Strings

- (BOOL) isEmpty {
	return [self isEqualToString:@""];
}

- (BOOL) isBlank {
	NSUInteger index;
	for (index = 0; index != [self length]; index++)
		if (![[NSCharacterSet whitespaceCharacterSet] characterIsMember:[self characterAtIndex:index]]) return NO;
	return YES;
}

#pragma mark Determining Line and Paragraph Ranges

- (NSUInteger) lineCount {
	//TODO there has got to be a more efficient way of doing this
	return [[self componentsSeparatedByCharactersInSet:[NSCharacterSet newlineCharacterSet]] count];
}

#pragma mark Working with URLs

- (NSString *) stringByURLEscapingUsingEncoding:(NSStringEncoding)encoding {
	NSMutableString *encodedString = [[NSMutableString alloc] initWithString:[self stringByAddingPercentEscapesUsingEncoding:encoding]];
	[encodedString replaceOccurrencesOfString:@"$" withString:@"%24" options:NSLiteralSearch range:NSMakeRange(0, [encodedString length])];
	[encodedString replaceOccurrencesOfString:@"&" withString:@"%26" options:NSLiteralSearch range:NSMakeRange(0, [encodedString length])];
	[encodedString replaceOccurrencesOfString:@"+" withString:@"%2B" options:NSLiteralSearch range:NSMakeRange(0, [encodedString length])];
	[encodedString replaceOccurrencesOfString:@"," withString:@"%2C" options:NSLiteralSearch range:NSMakeRange(0, [encodedString length])];
	[encodedString replaceOccurrencesOfString:@"/" withString:@"%2F" options:NSLiteralSearch range:NSMakeRange(0, [encodedString length])];
	[encodedString replaceOccurrencesOfString:@":" withString:@"%3A" options:NSLiteralSearch range:NSMakeRange(0, [encodedString length])];
	[encodedString replaceOccurrencesOfString:@";" withString:@"%3B" options:NSLiteralSearch range:NSMakeRange(0, [encodedString length])];
	[encodedString replaceOccurrencesOfString:@"=" withString:@"%3D" options:NSLiteralSearch range:NSMakeRange(0, [encodedString length])];
	[encodedString replaceOccurrencesOfString:@"?" withString:@"%3F" options:NSLiteralSearch range:NSMakeRange(0, [encodedString length])];
	[encodedString replaceOccurrencesOfString:@"@" withString:@"%40" options:NSLiteralSearch range:NSMakeRange(0, [encodedString length])];
	
	return [encodedString autorelease];
}

@end
