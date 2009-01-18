#import "SUUploadHelper.h"

@implementation SUUploadHelper

@synthesize isBusy;
@synthesize currentlyUploadingCount;
@dynamic isUploading;
@synthesize busyAction;
@synthesize newUserLogin;
@synthesize newUserEmail;
@synthesize newUserPassword;
@synthesize newUserName;

/*
 Called when the object is first unpacked; initializes instances variables.
 */

- (void) awakeFromNib {
	self.isBusy = NO;
	self.currentlyUploadingCount = 0;
	newUserLoginError = newUserPasswordError = newUserEmailError = newUserNameError = NULL;
}

- (BOOL) authenticate {
	NSString *login = [[NSUserDefaults standardUserDefaults] stringForKey:@"scribdLogin"];
	NSString *password = [[NSUserDefaults standardUserDefaults] stringForKey:@"scribdPassword"];
	
	NSDictionary *params = [[NSDictionary alloc] initWithObjectsAndKeys:
							login, @"username",
							password, @"password",
							NULL];
	NSError *error = NULL;
	
	self.busyAction = @"login";
	self.isBusy = YES;
	NSDictionary *result = [[SUScribdAPI sharedAPI] callApiMethod:@"user.login" parameters:params error:&error];
	self.isBusy = NO;
	
	if (error) {
		[error addMessagesForAction:SULogInAction sender:self];
		NSAlert *alert = [[NSAlert alloc] init];
		[alert setAlertStyle:NSCriticalAlertStyle];
		[alert setMessageText:[error localizedDescription]];
		[alert setInformativeText:[error localizedRecoverySuggestion]];
		[alert addButtonWithTitle:@"OK"];
		[alert setShowsHelp:YES];
		[alert setHelpAnchor:[NSString stringWithFormat:@"login_%d", [error code]]];
		[alert beginSheetModalForWindow:loginSheet modalDelegate:self didEndSelector:@selector(alertDidEnd:returnCode:contextInfo:) contextInfo:NULL];
		[params release];
		return NO;
	}
	
	[[SUSessionHelper sessionHelper] storeSessionKey:[result objectForKey:@"session_key"] username:login];
	
	[params release];
	return YES;
}

- (void) uploadFiles {
	if (![[SUSessionHelper sessionHelper] sessionStored]) {
		NSAlert *alert = [[NSAlert alloc] init];
		[alert setMessageText:@"I was unable to log you into Scribd."];
		[alert setInformativeText:@"You can’t upload files to Scribd without first logging in. You can try uploading your files again later."];
		[alert addButtonWithTitle:@"OK"];
		[alert setAlertStyle:NSCriticalAlertStyle];
		[alert setShowsHelp:YES];
		[alert setHelpAnchor:@"existing_account"];
		[alert runModal];
	}
	
	NSDictionary *parameters = [NSDictionary dictionaryWithObjectsAndKeys:
								[SUSessionHelper sessionHelper].key, @"session_key",
								NULL];
	NSError *error = NULL;
	NSArray *documents = [SUDocument findPendingInManagedObjectContext:db.managedObjectContext error:&error];
	if (documents && [documents count]) {
		for (SUDocument *document in documents) {
			SUUploadDelegate *delegate = [[SUUploadDelegate alloc] initWithDocument:document inManagedObjectContext:db.managedObjectContext fromUploader:self];
			delegate.uploadWindow = uploadWindow;
			delegate.uploadCompleteSheet = uploadCompleteSheet;
			delegate.uploadCompleteSheetDelegate = uploadCompleteSheetDelegate;
			self.currentlyUploadingCount++;
			NSMutableDictionary *docParams = [[NSMutableDictionary alloc] initWithDictionary:parameters];
			[docParams setObject:([document.hidden boolValue] ? @"private" : @"public") forKey:@"access"];
			[[SUScribdAPI sharedAPI] apiSubmitFile:document apiMethod:@"docs.upload" parameters:docParams delegate:delegate];
			[docParams release];
		}
	}
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
	NSDictionary *result = [[SUScribdAPI sharedAPI] callApiMethod:@"user.signup" parameters:params error:&error];
	self.isBusy = NO;
	
	if (error) {
		[error addMessagesForAction:SUSignUpAction sender:self];
		NSAlert *alert = [[NSAlert alloc] init];
		[alert setAlertStyle:NSCriticalAlertStyle];
		[alert setMessageText:[error localizedDescription]];
		[alert setInformativeText:[error localizedRecoverySuggestion]];
		[alert addButtonWithTitle:@"OK"];
		[alert setShowsHelp:YES];
		[alert setHelpAnchor:[NSString stringWithFormat:@"signup_%d", [error code]]];
		[alert beginSheetModalForWindow:loginSheet modalDelegate:self didEndSelector:@selector(alertDidEnd:returnCode:contextInfo:) contextInfo:NULL];
		[params release];
		return NO;
	}
	
	[[SUSessionHelper sessionHelper] storeSessionKey:[result objectForKey:@"session_key"] username:newUserLogin];
	
	[params release];
	return YES;
}

- (BOOL) isUploading {
	return self.currentlyUploadingCount != 0;
}

/*
 When the current upload count changes the isUploading bool must change as well.
 */

+ (NSSet *) keyPathsForValuesAffectingIsUploading {
	return [NSSet setWithObject:@"currentlyUploadingCount"];
}

- (BOOL) uploadComplete {
	return self.currentlyUploadingCount == 0;
}

/*
 Key-value coding compliant validator for newUserLogin; checks if the server has
 indicated that the login is in error.
 */

- (BOOL) validateNewUserLogin:(id *)login error:(NSError **)error {
	if (newUserLoginError) {
		*error = [newUserLoginError autorelease];
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
		*error = [newUserPasswordError autorelease];
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
		*error = [newUserEmailError autorelease];
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
		*error = [newUserNameError autorelease];
		return NO;
	}
	else return YES;
}

/*
 Releases retained objects.
 */

- (void) dealloc {
	if (newUserLoginError) [newUserLoginError release];
	if (newUserPasswordError) [newUserPasswordError release];
	if (newUserEmailError) [newUserEmailError release];
	if (newUserNameError) [newUserNameError release];
	[super dealloc];
}

/*
 Called when any alert created by this class ends. Releases the alert.
 */

- (void) alertDidEnd:(NSAlert *)alert returnCode:(int)returnCode contextInfo:(void *)contextInfo {
	[alert release];
}

@end
