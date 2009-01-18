#import "NSError_SUAdditions.h"

@implementation NSError (SUAdditions)

- (void) addMessagesForAction:(NSString *)action sender:(id)sender {
	if (![[self domain] isEqualToString:SUScribdAPIErrorDomain]) return;
	
	NSDictionary *messages = [NSDictionary dictionaryWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"ScribdAPI" ofType:@"plist"]];
	NSDictionary *errorSettings = [messages valueForKeyPath:[NSString stringWithFormat:@"ErrorMessages.%@.%i", action, [self code]]];
	NSMutableDictionary *newUserInfo = [[NSMutableDictionary alloc] initWithDictionary:[self userInfo]];
	
	if (errorSettings) {
		NSString *invalidateProperty = [errorSettings objectForKey:@"Invalidate"];
		if (invalidateProperty) {
			[sender setValue:self forKey:[NSString stringWithFormat:@"%@Error", invalidateProperty]];
			// in order to get the view to recognize the error and invalid property, we need to pretend to have changed it
			[sender willChangeValueForKey:invalidateProperty];
			[sender didChangeValueForKey:invalidateProperty];
		}
		[newUserInfo setObject:[NSString stringWithFormat:[errorSettings objectForKey:@"Message"], (invalidateProperty ? [sender valueForKey:invalidateProperty] : NULL)] forKey:NSLocalizedDescriptionKey];
	} else {
		[newUserInfo setObject:[NSString stringWithFormat:[messages valueForKeyPath:[NSString stringWithFormat:@"ErrorMessages.%@.Default", action]], [[self userInfo] objectForKey:NSLocalizedFailureReasonErrorKey]] forKey:NSLocalizedDescriptionKey];
	}
	
	[newUserInfo setObject:[messages valueForKeyPath:[NSString stringWithFormat:@"RecoverySuggestions.%@", action]] forKey:NSLocalizedRecoverySuggestionErrorKey];
	[newUserInfo setObject:action forKey:SUActionErrorKey];
	
	[self setValue:newUserInfo forKey:@"userInfo"];
}

- (void) addMessagesForAction:(NSString *)action title:(NSString *)docTitle {
	if (![[self domain] isEqualToString:SUScribdAPIErrorDomain]) return;
	
	NSDictionary *messages = [NSDictionary dictionaryWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"ScribdAPI" ofType:@"plist"]];
	NSDictionary *errorSettings = [messages valueForKeyPath:[NSString stringWithFormat:@"ErrorMessages.%@.%i", action, [self code]]];
	NSMutableDictionary *newUserInfo = [[NSMutableDictionary alloc] initWithDictionary:[self userInfo]];
	
	if (errorSettings) {
		[newUserInfo setObject:[NSString stringWithFormat:[errorSettings objectForKey:@"Message"], docTitle] forKey:NSLocalizedDescriptionKey];
	} else {
		[newUserInfo setObject:[NSString stringWithFormat:[messages valueForKeyPath:[NSString stringWithFormat:@"ErrorMessages.%@.Default", action]], docTitle, [[self userInfo] objectForKey:NSLocalizedFailureReasonErrorKey]] forKey:NSLocalizedDescriptionKey];
	}
	
	[newUserInfo setObject:[messages valueForKeyPath:[NSString stringWithFormat:@"RecoverySuggestions.%@", action]] forKey:NSLocalizedRecoverySuggestionErrorKey];
	[newUserInfo setObject:action forKey:SUActionErrorKey];
	
	[self setValue:newUserInfo forKey:@"userInfo"];
}

@end
