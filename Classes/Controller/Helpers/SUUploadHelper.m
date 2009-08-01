#import "SUUploadHelper.h"

@interface SUUploadHelper (Private)

#pragma mark Dynamic properties

/*
 Returns YES if at least one upload has been started since last launch.
 */

- (BOOL) uploadStarted;

#pragma mark Delegate responders

/*
 Called when a file finishes uploading. Changes the currentlyUploadingCount and
 handles the case when all files are finished.
 */

- (void) uploadComplete:(SUUploadDelegate *)delegate;

@end

#pragma mark -

@implementation SUUploadHelper

#pragma mark Properties

@synthesize isBusy;
@synthesize currentlyUploadingCount;
@dynamic isUploading;
@dynamic uploadComplete;
@synthesize busyAction;
@synthesize newUserLogin;
@synthesize newUserEmail;
@synthesize newUserPassword;
@synthesize newUserName;
@synthesize scribdLogin;
@synthesize scribdPassword;

#pragma mark Initializing and deallocating

/*
 Called when the object is first unpacked; initializes instances variables.
 */

- (void) awakeFromNib {
	uploadStarted = NO;
	self.isBusy = NO;
	self.currentlyUploadingCount = 0;
	self.scribdLogin = [[SUSessionHelper sessionHelper] username];
	newUserLoginError = newUserPasswordError = newUserEmailError = newUserNameError = NULL;
	uploadDelegates = [[NSMutableSet alloc] init]; // just used to retain delegates which are created in transient autorelease pools
	[[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(uploadComplete:) name:SUUploadCompleteNotification object:NULL];
}

/*
 Releases retained objects.
 */

- (void) dealloc {
	if (newUserLoginError) [newUserLoginError release];
	if (newUserPasswordError) [newUserPasswordError release];
	if (newUserEmailError) [newUserEmailError release];
	if (newUserNameError) [newUserNameError release];
	[uploadDelegates release];
	[super dealloc];
}

#pragma mark Working with Scribd.com

- (BOOL) authenticate {
	NSDictionary *params = [[NSDictionary alloc] initWithObjectsAndKeys:
							self.scribdLogin, @"username",
							self.scribdPassword, @"password",
							NULL];
	NSError *error = NULL;
	
	self.busyAction = @"login";
	self.isBusy = YES;
	NSDictionary *result = [[SUScribdAPI sharedAPI] callAPIMethod:[[SUAPIHelper helper].settings objectForKey:@"APILogInMethod"] parameters:params error:&error];
	self.isBusy = NO;
	
	if (error) {
		error = [error addMessagesForAction:SULogInAction sender:self];
		NSAlert *alert = [[NSAlert alloc] init];
		[alert setAlertStyle:NSCriticalAlertStyle];
		[alert setMessageText:[error localizedDescription]];
		[alert setInformativeText:[error localizedRecoverySuggestion]];
		[alert addButtonWithTitle:NSLocalizedString(@"OK", @"command")];
		[alert setShowsHelp:YES];
		NSString *anchor = [[NSString alloc] initWithFormat:@"login_%d", [error code]];
		[alert setHelpAnchor:anchor];
		[anchor release];
		
		[alert beginSheetModalForWindow:loginSheet modalDelegate:self didEndSelector:@selector(alertDidEnd:returnCode:contextInfo:) contextInfo:NULL];
		
		[params release];
		return NO;
	}
	
	[[SUSessionHelper sessionHelper] storeSessionKey:[result objectForKey:@"session_key"] username:self.scribdLogin];
	
	[params release];
	return YES;
}

- (void) uploadFiles {
	if (![[SUSessionHelper sessionHelper] sessionStored]) {
		NSAlert *alert = [[NSAlert alloc] init];
		[alert setMessageText:NSLocalizedString(@"I was unable to log you into Scribd.", NULL)];
		[alert setInformativeText:NSLocalizedString(@"You can’t upload files to Scribd without first logging in. You can try uploading your files again later.", NULL)];
		[alert addButtonWithTitle:NSLocalizedString(@"OK", @"command")];
		[alert setAlertStyle:NSCriticalAlertStyle];
		[alert setShowsHelp:YES];
		[alert setHelpAnchor:@"existing_account"];
		[alert runModal];
		[alert release];
	}
	
	uploadStarted = YES;
	
	NSDictionary *parameters = [[NSDictionary alloc] initWithObjectsAndKeys:
								[SUSessionHelper sessionHelper].key, @"session_key",
								NULL];
	NSError *error = NULL;
	NSArray *documents = [SUDocument findUploadableInManagedObjectContext:db.managedObjectContext error:&error];
	if (documents && [documents count]) {
		for (SUDocument *document in documents) {
			self.currentlyUploadingCount++;
			
			SUUploadDelegate *delegate = [[SUUploadDelegate alloc] initWithDocument:document inManagedObjectContext:db.managedObjectContext];
			[uploadDelegates addObject:delegate];
			
			NSMutableDictionary *docParams = [[NSMutableDictionary alloc] initWithDictionary:parameters];
			[docParams setObject:([document.hidden boolValue] ? @"private" : @"public") forKey:@"access"];
			if (![document remoteFile]) [[SUScribdAPI sharedAPI] submitFile:document toAPIMethod:[[SUAPIHelper helper].settings objectForKey:@"APIUploadMethod"] parameters:docParams delegate:delegate];
			else {
				[docParams setObject:document.path forKey:@"url"];
				[[SUScribdAPI sharedAPI] asynchronouslyCallAPIMethod:[[SUAPIHelper helper].settings objectForKey:@"APIUploadURLMethod"] parameters:docParams delegate:delegate];
			}
			
			[delegate release]; // the uploadDelegates set will retain it past the life of this thread's autorelease pool
			[docParams release];
		}
	}
	
	[parameters release];
}

- (BOOL) createAccount {
	NSDictionary *params = [[NSDictionary alloc] initWithObjectsAndKeys:
							newUserLogin, @"username",
							newUserPassword, @"password",
							newUserEmail, @"email",
							newUserName, @"name",
							NULL];
	NSError *error = NULL;
	
	self.busyAction = @"signup";
	self.isBusy = YES;
	NSDictionary *result = [[SUScribdAPI sharedAPI] callAPIMethod:[[SUAPIHelper helper].settings objectForKey:@"APISignUpMethod"] parameters:params error:&error];
	self.isBusy = NO;
	
	if (error) {
		error = [error addMessagesForAction:SUSignUpAction sender:self];
		NSAlert *alert = [[NSAlert alloc] init];
		[alert setAlertStyle:NSCriticalAlertStyle];
		[alert setMessageText:[error localizedDescription]];
		[alert setInformativeText:[error localizedRecoverySuggestion]];
		[alert addButtonWithTitle:@"OK"];
		[alert setShowsHelp:YES];
		NSString *anchor = [[NSString alloc] initWithFormat:@"signup_%d", [error code]];
		[alert setHelpAnchor:anchor];
		[anchor release];

		[alert beginSheetModalForWindow:loginSheet modalDelegate:self didEndSelector:@selector(alertDidEnd:returnCode:contextInfo:) contextInfo:NULL];
		
		[params release];
		return NO;
	}
	
	[[SUSessionHelper sessionHelper] storeSessionKey:[result objectForKey:@"session_key"] username:newUserLogin];
	
	[params release];
	return YES;
}

#pragma mark Getting state information

- (BOOL) uploadComplete {
	return uploadStarted && self.currentlyUploadingCount == 0;
}

#pragma Dynamic properties

- (BOOL) isUploading {
	return self.currentlyUploadingCount != 0;
}

/*
 When the current upload count changes the isUploading bool must change as well.
 */

+ (NSSet *) keyPathsForValuesAffectingIsUploading {
	return [NSSet setWithObject:@"currentlyUploadingCount"];
}

/*
 The upload complete flag is based on the number of files currently uploading
 and whether at least one upload has occurred.
 */

+ (NSSet *) keyPathsForValuesAffectingUploadComplete {
	return [NSSet setWithObjects:@"currentlyUploadingCount", @"uploadStarted", NULL];
}

#pragma mark Validation

/*
 Key-value coding compliant validator for newUserLogin; checks if the server has
 indicated that the login is in error.
 */

- (BOOL) validateNewUserLogin:(id *)login error:(NSError **)error {
	if (newUserLoginError) {
		if (!error) *error = [newUserLoginError autorelease];
		return NO;
	}
	else return YES;
}

/*
 Key-value coding compliant validator for newUserPassword; checks if the server
 has indicated that the password is in error.
 */

- (BOOL) validateNewUserPassword:(id *)password error:(NSError **)error {
	if (newUserPasswordError) {
		if (!error) *error = [newUserPasswordError autorelease];
		return NO;
	}
	else return YES;
}

/*
 Key-value coding compliant validator for newUserEmail; checks if the server has
 indicated that the email is in error.
 */

- (BOOL) validateNewUserEmail:(id *)email error:(NSError **)error {
	if (newUserEmailError) {
		if (!error) *error = [newUserEmailError autorelease];
		return NO;
	}
	else return YES;
}

/*
 Key-value coding compliant validator for newUserName; checks if the server has
 indicated that the name is in error.
 */

- (BOOL) validateNewUserName:(id *)name error:(NSError **)error {
	if (newUserNameError) {
		if (!error) *error = [newUserNameError autorelease];
		return NO;
	}
	else return YES;
}

#pragma mark Delegate responders

/*
 Called when any alert created by this class ends. Releases the alert.
 */

- (void) alertDidEnd:(NSAlert *)alert returnCode:(int)returnCode contextInfo:(void *)contextInfo {
	[alert release];
}

@end

#pragma mark -

@implementation SUUploadHelper (Private)

#pragma mark Dynamic properties

- (BOOL) uploadStarted {
	return uploadStarted;
}

#pragma mark Delegate responders

- (void) uploadComplete:(SUUploadDelegate *)delegate {
	[uploadDelegates removeObject:delegate];
	
	self.currentlyUploadingCount--;
	if ([self uploadComplete]) {
		if (![[NSApplication sharedApplication] isActive])
			[[NSApplication sharedApplication] requestUserAttention:NSInformationalRequest];
			[GrowlApplicationBridge notifyWithTitle:NSLocalizedString(@"All uploads have completed.", NULL)
										description:NSLocalizedString(@"Your files are now ready to be viewed on Scribd.com.", NULL)
								   notificationName:@"All uploads complete"
										   iconData:NULL
										   priority:0
										   isSticky:NO 
									   clickContext:NULL];
		[[NSSound soundNamed:@"Upload Complete"] play];
	}	
}

@end
