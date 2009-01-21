#import "NSDictionary_SUAdditions.h"

@implementation NSDictionary (SUAdditions)

- (NSDictionary *) initWithObject:(id)object forKey:(NSString *)key {
	return [self initWithObjectsAndKeys:object, key, NULL];
}

@end
