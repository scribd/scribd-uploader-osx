#import "NSError+SUAdditions.h"

@implementation NSError (SUAdditions)

#pragma mark Adding info

- (NSError *) addMessagesForAction:(NSString *)action sender:(id)sender {
	if (![[self domain] isEqualToString:SUScribdAPIErrorDomain]) return self;
	
	NSDictionary *messages = [[NSDictionary alloc] initWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"ScribdAPI" ofType:@"plist"]];
	NSString *messageLocation = [[NSString alloc] initWithFormat:@"ErrorMessages.%@.%i", action, [self code]];
	NSDictionary *errorSettings = [messages valueForKeyPath:messageLocation];
	[messageLocation release];
	NSMutableDictionary *newUserInfo = [[NSMutableDictionary alloc] initWithDictionary:[self userInfo]];
	
	if (errorSettings) {
		NSString *invalidateProperty = [errorSettings objectForKey:@"Invalidate"];
		if (invalidateProperty) {
			NSString *errorStringLocation = [[NSString alloc] initWithFormat:@"%@Error", invalidateProperty];
			[sender setValue:self forKey:errorStringLocation];
			[errorStringLocation release];
			// in order to get the view to recognize the error and invalid property, we need to pretend to have changed it
			[sender willChangeValueForKey:invalidateProperty];
			[sender didChangeValueForKey:invalidateProperty];
		}
		
		NSString *description;
		@try {
			description = [[NSString alloc] initWithFormat:[errorSettings objectForKey:@"Message"], (invalidateProperty ? [sender valueForKey:invalidateProperty] : NULL)];
		}
		@catch (NSException *e) {
			NSLog(@"Received unexpected error code %@.%i", action, [self code]);
			exit(1);
		}
		[newUserInfo setObject:description forKey:NSLocalizedDescriptionKey];
		[description release];
	}
	else {
		NSString *messageLocation = [[NSString alloc] initWithFormat:@"ErrorMessages.%@.Default", action];
		NSString *description = [[NSString alloc] initWithFormat:[messages valueForKeyPath:messageLocation], [[self userInfo] objectForKey:NSLocalizedFailureReasonErrorKey]];
		[messageLocation release];
		[newUserInfo setObject:description forKey:NSLocalizedDescriptionKey];
		[description release];
	}
	
	NSString *recoverySuggestion = [[NSString alloc] initWithFormat:@"RecoverySuggestions.%@", action];
	[newUserInfo setObject:[messages valueForKeyPath:recoverySuggestion] forKey:NSLocalizedRecoverySuggestionErrorKey];
	[recoverySuggestion release];
	[newUserInfo setObject:action forKey:SUActionErrorKey];
	
	[self setValue:newUserInfo forKey:@"userInfo"];
	
	[newUserInfo release];
	[messages release];
	return self;
}

- (NSError *) addMessagesForAction:(NSString *)action title:(NSString *)docTitle {
	if (![[self domain] isEqualToString:SUScribdAPIErrorDomain]) {
		NSString *description = [[NSString alloc] initWithFormat:NSLocalizedString(@"Your document was not configured because of a problem: %@", NULL), [self localizedDescription]];
		NSMutableDictionary *info = [[NSMutableDictionary alloc] initWithDictionary:[self userInfo]];
		[info setObject:description forKey:NSLocalizedDescriptionKey];
		[description release];
		[info setObject:NSLocalizedString(@"Your file uploaded successfully, however. You will have to visit Scribd.com to change its metadata.", NULL) forKey:NSLocalizedRecoverySuggestionErrorKey];
		[info setObject:SUChangeSettingsAction forKey:SUActionErrorKey];
		NSError *newError = [NSError errorWithDomain:SUScribdAPIErrorDomain code:1 userInfo:info];
		[info release];
		return newError;
	}
	
	NSDictionary *messages = [[NSDictionary alloc] initWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"ScribdAPI" ofType:@"plist"]];
	NSString *settingsLocation = [[NSString alloc] initWithFormat:@"ErrorMessages.%@.%i", action, [self code]];
	NSDictionary *errorSettings = [messages valueForKeyPath:settingsLocation];
	[settingsLocation release];
	NSMutableDictionary *newUserInfo = [[NSMutableDictionary alloc] initWithDictionary:[self userInfo]];
	
	if (errorSettings) {
		NSString *description = [[NSString alloc] initWithFormat:[errorSettings objectForKey:@"Message"], docTitle];
		[newUserInfo setObject:description forKey:NSLocalizedDescriptionKey];
		[description release];
	}
	else {
		NSString *descLocation = [[NSString alloc] initWithFormat:@"ErrorMessages.%@.Default", action];
		NSString *description = [[NSString alloc] initWithFormat:[messages valueForKeyPath:descLocation], docTitle, [[self userInfo] objectForKey:NSLocalizedFailureReasonErrorKey]];
		[descLocation release];
		[newUserInfo setObject:description forKey:NSLocalizedDescriptionKey];
		[description release];
	}
	
	NSString *suggestionLocation = [[NSString alloc] initWithFormat:@"RecoverySuggestions.%@", action];
	[newUserInfo setObject:[messages valueForKeyPath:suggestionLocation] forKey:NSLocalizedRecoverySuggestionErrorKey];
	[suggestionLocation release];
	[newUserInfo setObject:action forKey:SUActionErrorKey];
	
	[self setValue:newUserInfo forKey:@"userInfo"];
	
	[newUserInfo release];
	[messages release];
	return self;
}

@end
