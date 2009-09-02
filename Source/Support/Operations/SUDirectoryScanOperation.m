#import "SUDirectoryScanOperation.h"

@implementation SUDirectoryScanOperation

#pragma mark Properties

@synthesize path;
@synthesize managedObjectContext;

#pragma mark Initializing and deallocating

- (id) initWithPath:(NSString *)directoryPath inManagedObjectContext:(NSManagedObjectContext *)context {
	if (self = [super init]) {
		self.path = directoryPath;
		self.managedObjectContext = context;
	}
	return self;
}

#pragma mark NSOperation

/*
 Scans a directory for valid files and adds them to the managed object context.
 Aborts if isCancelled ever returns true.
 */

- (void) main {
	BOOL (^errorHandler)(NSURL *, NSError *) = ^(NSURL *URL, NSError *error){
		NSLog(@"An error occurred while scanning %@: %@", [self.path lastPathComponent], [error localizedDescription]);
		return YES;
	};
	NSURL *URL = [[NSURL alloc] initFileURLWithPath:self.path];
	NSDirectoryEnumerator *enumerator = [[NSFileManager defaultManager] enumeratorAtURL:URL includingPropertiesForKeys:NULL options:(NSDirectoryEnumerationSkipsPackageDescendants|NSDirectoryEnumerationSkipsHiddenFiles) errorHandler:errorHandler];
	[URL release];
	
	NSURL *fileURL;
	while (![self isCancelled] && (fileURL = [enumerator nextObject])) {
		if ([[SUDocument scribdFileTypes] containsObject:[[fileURL path] pathExtension]])
			[SUDocument createFromURL:fileURL inManagedObjectContext:self.managedObjectContext];
	}
}

@end
