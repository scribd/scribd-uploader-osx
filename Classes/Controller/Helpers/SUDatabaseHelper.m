#import "SUDatabaseHelper.h"

@interface SUDatabaseHelper (Private)

/*
 Returns the support folder for the application, used to store the Core Data
 store file. This code uses a folder named "Scribd Uploader" for
 the content, either in the NSApplicationSupportDirectory location or (if the
 former cannot be found), the system's temporary directory.
 */

- (NSString *) applicationSupportFolder;

/*
 Removes documents from the list that are no longer on the hard drive.
 */

- (void) purgeNonexistentDocuments;

/*
 Removes documents from the list that have been successfully uploaded.
 */

- (void) purgeCompletedDocuments;

/*
 Resets the progress to zero of any document whose upload was aborted partway through.
 */

- (void) resetProgresses;

@end

@implementation SUDatabaseHelper

@dynamic managedObjectModel;
@dynamic managedObjectContext;
@dynamic persistentStoreCoordinator;

/*
 Removes documents from the list that have since been deleted.
 */

- (void) awakeFromNib {
	[self purgeNonexistentDocuments];
	[self resetProgresses];
	[self purgeCompletedDocuments];
}

/*
 Lazily initializes the NSManagedObjectModel application schema.
 */

- (NSManagedObjectModel *) managedObjectModel {
	if (managedObjectModel != NULL) {
		return managedObjectModel;
	}
	
	managedObjectModel = [[NSManagedObjectModel mergedModelFromBundles:NULL] retain];
	return managedObjectModel;
}

/*
 Lazily initializes the NSPersistentStoreCoordinator save-file interface.
 */

- (NSPersistentStoreCoordinator *) persistentStoreCoordinator {
	if (persistentStoreCoordinator != NULL) {
		return persistentStoreCoordinator;
	}
	
	NSFileManager *fileManager;
	NSString *applicationSupportFolder = NULL;
	NSURL *url;
	NSError *error = NULL;
	
	fileManager = [NSFileManager defaultManager];
	applicationSupportFolder = [self applicationSupportFolder];
	if ( ![fileManager fileExistsAtPath:applicationSupportFolder isDirectory:NULL] ) {
		[fileManager createDirectoryAtPath:applicationSupportFolder attributes:NULL];
	}
	
	url = [NSURL fileURLWithPath:[applicationSupportFolder stringByAppendingPathComponent: @"Queue.xml"]];
	persistentStoreCoordinator = [[NSPersistentStoreCoordinator alloc] initWithManagedObjectModel:self.managedObjectModel];
	
	NSDictionary *options = [NSDictionary dictionaryWithObject:[NSNumber numberWithBool:YES] forKey:NSMigratePersistentStoresAutomaticallyOption];
	if (![persistentStoreCoordinator addPersistentStoreWithType:NSXMLStoreType configuration:NULL URL:url options:options error:&error]){
		[[NSApplication sharedApplication] presentError:error];
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

/*
 Releases retained variables.
 */

- (void) dealloc {
	if (managedObjectContext) [managedObjectContext release];
	if (persistentStoreCoordinator) [persistentStoreCoordinator release];
	if (managedObjectModel) [managedObjectModel release];
	[super dealloc];
}

@end

@implementation SUDatabaseHelper (Private)

- (NSString *) applicationSupportFolder {
	NSArray *paths = NSSearchPathForDirectoriesInDomains(NSApplicationSupportDirectory, NSUserDomainMask, YES);
	NSString *basePath = ([paths count] > 0) ? [paths objectAtIndex:0] : NSTemporaryDirectory();
	return [basePath stringByAppendingPathComponent:@"Scribd Uploader"];
}

- (void) purgeNonexistentDocuments {
	NSError *error = NULL;
	NSArray *objects = [[SUDocumentHelper documentManager] allDocumentsInManagedObjectContext:self.managedObjectContext error:&error];
	int deleteCount = 0;
	NSString *singleFileName;
	if (objects) {
		for (SUDocument *doc in objects) {
			if (![[SUDocumentHelper documentManager] documentPointsToActualFile:doc]) {
				// store the name of the file in case it's the only one
				if (deleteCount == 0) singleFileName = [doc filename];
				[self.managedObjectContext deleteObject:doc];
				deleteCount++;
			}
		}
	}
	
	if (deleteCount) {
		[fileNotFoundAlertDelegate showAlertFor:deleteCount singleFileName:singleFileName];
	}
}

- (void) purgeCompletedDocuments {
	NSError *error = NULL;
	NSArray *objects = [[SUDocumentHelper documentManager] completedDocumentsInManagedObjectContext:self.managedObjectContext error:&error];
	if (objects)
		for (SUDocument *doc in objects) [self.managedObjectContext deleteObject:doc];
}

- (void) resetProgresses {
	NSEntityDescription *docEntity = [NSEntityDescription entityForName:@"Document" inManagedObjectContext:self.managedObjectContext];
	NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] init];
	[fetchRequest setEntity:docEntity];
	[fetchRequest setPredicate:[NSPredicate predicateWithFormat:@"progress != %@" argumentArray:[NSArray arrayWithObject:[NSNumber numberWithFloat:0.0]]]];
	
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
