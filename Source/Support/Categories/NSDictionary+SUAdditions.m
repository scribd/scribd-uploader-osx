#import "NSDictionary+SUAdditions.h"

@implementation NSDictionary (SUAdditions)

#pragma mark Initializing an NSDictionary Instance

- (NSDictionary *) initWithObject:(id)object forKey:(NSString *)key {
	return [self initWithObjectsAndKeys:object, key, NULL];
}

@end
