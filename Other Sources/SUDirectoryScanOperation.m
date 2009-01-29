#import "SUDirectoryScanOperation.h"

@implementation SUDirectoryScanOperation

@synthesize path;
@synthesize managedObjectContext;

- (id) initWithPath:(NSString *)directoryPath inManagedObjectContext:(NSManagedObjectContext *)context {
	if (self = [super init]) {
		self.path = directoryPath;
		self.managedObjectContext = context;
	}
	return self;
}

/*
 Scans a directory for valid files and adds them to the managed object context.
 Aborts if isCancelled ever returns true.
 */

- (void) main {
	NSDirectoryEnumerator *enumerator = [[NSFileManager defaultManager] enumeratorAtPath:self.path];
	NSString *subpath;
	while (![self isCancelled] && (subpath = [enumerator nextObject])) {
		NSString *fullPath = [self.path stringByAppendingPathComponent:subpath];
		if ([[SUDocument scribdFileTypes] containsObject:[fullPath pathExtension]]) {
			[SUDocument createFromPath:fullPath inManagedObjectContext:self.managedObjectContext];
		}
	}
}

@end
