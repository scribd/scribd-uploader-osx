#import "SUDocument+Generators.h"

@implementation SUDocument (Generators)

#pragma mark Creating new records

+ (SUDocument *) createFromPath:(NSString *)path inManagedObjectContext:(NSManagedObjectContext *)managedObjectContext {
	NSURL *pathURL = [[NSURL alloc] initFileURLWithPath:[path stringByStandardizingPath]];
	NSURL *absoluteURL = [pathURL absoluteURL];
	[pathURL release];
	SUDocument *existingDocument = NULL;
	if (existingDocument = [SUDocument findByPath:[absoluteURL absoluteString] inManagedObjectContext:managedObjectContext])
		[managedObjectContext deleteObject:existingDocument];
	SUDocument *file = [NSEntityDescription insertNewObjectForEntityForName:@"Document" inManagedObjectContext:managedObjectContext];
	[file setValue:[absoluteURL absoluteString] forKey:@"path"];
	if ([[NSUserDefaults standardUserDefaults] objectForKey:SUDefaultKeyUploadPrivateDefault]) [file setValue:[NSNumber numberWithBool:YES] forKey:@"hidden"];	
	return file;
}

+ (SUDocument *) createFromURL:(NSURL *)URL inManagedObjectContext:(NSManagedObjectContext *)managedObjectContext {
	NSURL *absoluteURL = [URL absoluteURL];
	SUDocument *existingDocument = NULL;
	if (existingDocument = [SUDocument findByPath:[absoluteURL absoluteString] inManagedObjectContext:managedObjectContext])
		[managedObjectContext deleteObject:existingDocument];
	SUDocument *file = [NSEntityDescription insertNewObjectForEntityForName:@"Document" inManagedObjectContext:managedObjectContext];
	[file setValue:[absoluteURL absoluteString] forKey:@"path"];
	if ([[NSUserDefaults standardUserDefaults] objectForKey:SUDefaultKeyUploadPrivateDefault]) [file setValue:[NSNumber numberWithBool:YES] forKey:@"hidden"];	
	return file;
}

+ (SUDocument *) createFromURLString:(NSString *)URLString inManagedObjectContext:(NSManagedObjectContext *)managedObjectContext {
	NSURL *URL = [[NSURL alloc] initWithString:URLString];
	SUDocument *doc = [self createFromURL:URL inManagedObjectContext:managedObjectContext];
	[URL release];
	return doc;
}

@end
