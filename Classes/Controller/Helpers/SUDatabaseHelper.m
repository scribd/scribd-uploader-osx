#import "SUDatabaseHelper.h"

@implementation SUDatabaseHelper

#pragma mark Properties

@dynamic managedObjectModel;
@dynamic managedObjectContext;
@dynamic persistentStoreCoordinator;
@dynamic applicationSupportFolder;

#pragma mark Initializing and deallocating

/*
 Releases retained variables.
 */

- (void) dealloc {
	if (managedObjectContext) [managedObjectContext release];
	if (persistentStoreCoordinator) [persistentStoreCoordinator release];
	if (managedObjectModel) [managedObjectModel release];
	[super dealloc];
}

#pragma mark Dynamic properties

/*
 Lazily initializes the NSManagedObjectModel application schema.
 */

- (NSManagedObjectModel *) managedObjectModel {
	if (managedObjectModel != NULL) {
		return managedObjectModel;
	}
	
	NSURL *modelURL = [[NSURL alloc] initFileURLWithPath:[[NSBundle mainBundle] pathForResource:@"Scribd_Uploader_DataModel 210" ofType:@"mom" inDirectory:@"Scribd_Uploader_DataModel.momd"]];
	managedObjectModel = [[NSManagedObjectModel alloc] initWithContentsOfURL:modelURL];
	[modelURL release];
	return managedObjectModel;
}

/*
 Lazily initializes the NSPersistentStoreCoordinator save-file interface.
 */

- (NSPersistentStoreCoordinator *) persistentStoreCoordinator {
	if (persistentStoreCoordinator != NULL) return persistentStoreCoordinator;
	
	NSURL *url;
	NSError *error = NULL;
	NSString *applicationSupportFolder = self.applicationSupportFolder;
	
	if (![[NSFileManager defaultManager] fileExistsAtPath:applicationSupportFolder isDirectory:NULL]) {
		[[NSFileManager defaultManager] createDirectoryAtPath:applicationSupportFolder attributes:NULL];
	}
	
	url = [NSURL fileURLWithPath:[applicationSupportFolder stringByAppendingPathComponent: @"Queue.xml"]];
	persistentStoreCoordinator = [[NSPersistentStoreCoordinator alloc] initWithManagedObjectModel:self.managedObjectModel];
	
	NSDictionary *options = [NSDictionary dictionaryWithObject:[NSNumber numberWithBool:YES] forKey:NSMigratePersistentStoresAutomaticallyOption];
	if (![persistentStoreCoordinator addPersistentStoreWithType:NSXMLStoreType configuration:NULL URL:url options:options error:&error]) {
		if ([error code] == NSPersistentStoreIncompatibleVersionHashError) {
			NSAlert *alert = [[NSAlert alloc] init];
			[alert setMessageText:NSLocalizedString(@"It appears you are using an out-of-date version of Scribd Uploader. Please upgrade to the latest version of Scribd Uploader.", NULL)];
			[alert setInformativeText:NSLocalizedString(@"You can alternatively remove the Home > Library > Application Support > Scribd Uploader folder to use this version of Scribd Uploader.", NULL)];
			[alert setAlertStyle:NSCriticalAlertStyle];
			[alert addButtonWithTitle:NSLocalizedString(@"Quit", @"command")];
			[alert runModal];
			[alert release];
			exit(1); // can't call terminate: because we'll just see this error over and over
		}
		else NSLog(NSLocalizedString(@"Couldn’t add persistent store: %@", NULL), error);
	}
	
	return persistentStoreCoordinator;
}

/*
 Lazily initializes a new NSManagedObjectContext memory workspace.
 */

- (NSManagedObjectContext *) managedObjectContext {
	if (managedObjectContext != NULL) {
		return managedObjectContext;
	}
	
	NSPersistentStoreCoordinator *coordinator = self.persistentStoreCoordinator;
	if (coordinator != NULL) {
		managedObjectContext = [[NSManagedObjectContext alloc] init];
		[managedObjectContext setPersistentStoreCoordinator:coordinator];
	}
	
	return managedObjectContext;
}

- (NSString *) applicationSupportFolder {
	NSArray *paths = NSSearchPathForDirectoriesInDomains(NSApplicationSupportDirectory, NSUserDomainMask, YES);
	NSString *basePath = ([paths count] > 0) ? [paths objectAtIndex:0] : NSTemporaryDirectory();
	return [basePath stringByAppendingPathComponent:[[[NSBundle mainBundle] infoDictionary] objectForKey:@"CFBundleName"]];
}

#pragma mark Adding files

- (NSUInteger) addFiles:(NSArray *)files {
	BOOL willScan = NO;
	NSUInteger filesAdded = 0;
	
	for (NSString *path in files) {
		BOOL directory = NO;
		if ([[NSFileManager defaultManager] fileExistsAtPath:path isDirectory:&directory]) {
			if (directory) {
				[directoryScanner addDirectoryPath:path];
				willScan = YES;
				filesAdded++;
			}
			else {
				if ([[SUDocument scribdFileTypes] containsObject:[path pathExtension]])
					[SUDocument createFromPath:path inManagedObjectContext:self.managedObjectContext];
			}
			filesAdded++;
		}
	}
	if (willScan) [directoryScanner beginScanning];
	return filesAdded;
}

#pragma mark Housekeeping

- (NSUInteger) purgeNonexistentDocuments:(NSString **)singleFileName {
	NSError *error = NULL;
	NSArray *objects = [SUDocument findAllInManagedObjectContext:self.managedObjectContext error:&error];
	int deleteCount = 0;
	if (objects) {
		for (SUDocument *doc in objects) {
			if (![doc pointsToActualFile]) {
				// store the name of the file in case it's the only one
				if (deleteCount == 0) *singleFileName = [doc filename];
				[self.managedObjectContext deleteObject:doc];
				deleteCount++;
			}
		}
	}
	
	return deleteCount;
}

- (void) purgeCompletedDocuments {
	NSError *error = NULL;
	NSArray *objects = [SUDocument findUploadedInManagedObjectContext:self.managedObjectContext error:&error];
	if (objects)
		for (SUDocument *doc in objects) [self.managedObjectContext deleteObject:doc];
}

- (void) resetProgresses {
	NSEntityDescription *docEntity = [NSEntityDescription entityForName:@"Document" inManagedObjectContext:self.managedObjectContext];
	NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] init];
	[fetchRequest setEntity:docEntity];
	
	NSExpression *lhs = [NSExpression expressionForKeyPath:@"progress"];
	NSExpression *rhs = [NSExpression expressionForConstantValue:[NSNumber numberWithFloat:0.0]];
	NSPredicate *atLeastSomeProgress = [[NSComparisonPredicate alloc] initWithLeftExpression:lhs
																			 rightExpression:rhs
																					modifier:NSDirectPredicateModifier
																						type:NSNotEqualToPredicateOperatorType
																					 options:0]; // progress != 0.0
	[fetchRequest setPredicate:atLeastSomeProgress];
	[atLeastSomeProgress release];
	
	NSError *error = NULL;
	NSArray *objects = [self.managedObjectContext executeFetchRequest:fetchRequest error:&error];
	if (objects) {
		for (SUDocument *doc in objects) {
			[doc setProgress:[NSNumber numberWithFloat:0.0]];
		}
		[self.managedObjectContext save:&error];
	}
	
	[fetchRequest release];
}

@end
