#import "SUDirectoryScanner.h"

@interface SUDirectoryScanner (Private)

/*
 Operation method that scans a path.
 */

- (void) scanPath:(NSString *)path;

@end

@implementation SUDirectoryScanner

@synthesize documentsFound;
@synthesize isScanning;

/*
 Initializes fields.
 */

- (id) init {
	if (self = [super init]) {
		@synchronized(self) {
			pendingQueue = [[SUDeferredOperationQueue alloc] init];
			[pendingQueue setDelegate:self];
			operationQueue = NULL;
			pool = NULL;
			self.documentsFound = 0;
			self.isScanning = NO;
		}
	}
	return self;
}

/*
 Releases fields.
 */

- (void) dealloc {
	@synchronized(self) {
		self.isScanning = NO;
		if (operationQueue) {
			[operationQueue cancelAllOperations];
			[operationQueue release];
			operationQueue = NULL;
		}
	}
	[pendingQueue release];
	if (pool) [pool release];
	
	[super dealloc];
}

- (void) addDirectoryPath:(NSString *)path {
	NSOperation *operation = [[NSInvocationOperation alloc] initWithTarget:self selector:@selector(scanPath:) object:path];
	[pendingQueue addOperation:operation];
	[operation release];
}

- (void) beginScanning {
	pool = [[NSAutoreleasePool alloc] init];
	
	@synchronized(self) {
		if ([pendingQueue isEmpty]) return;
		if (self.isScanning) return;
		self.isScanning = YES;
	}
	@synchronized(self) {
		operationQueue = pendingQueue;
		pendingQueue = [[SUDeferredOperationQueue alloc] init];
		[pendingQueue setDelegate:self];
		self.documentsFound = 0;
	}
	
	[operationQueue run];
	[[NSNotificationCenter defaultCenter] postNotificationName:SUScanningStartedNotification object:NULL];
}

/*
 Called when the operation queue completes; closes the sheet.
 */

- (void) deferredQueueDidComplete:(SUDeferredOperationQueue *)queue {
	@synchronized(self) {
		self.documentsFound = 0;
		self.isScanning = NO;
	}
	
	[operationQueue release];
	operationQueue = NULL;
	pool = NULL;
	
	[[NSNotificationCenter defaultCenter] postNotificationName:SUScanningDoneNotification object:NULL];
	
	[pool release];
}

- (IBAction) cancelScanning:(id)sender {
	@synchronized(self) {
		if (!operationQueue) return;
		[operationQueue cancelAllOperations];
		[operationQueue release];
		operationQueue = NULL;
		self.isScanning = NO;
		self.documentsFound = 0;
	}
	[[NSNotificationCenter defaultCenter] postNotificationName:SUScanningDoneNotification object:NULL];
}

/*
 Removes the sheet once it closes.
 */

- (void) sheetDidEnd:(NSWindow *)endingSheet returnCode:(int)returnCode contextInfo:(void *)contextInfo {
	[endingSheet orderOut:self];
}

@end

@implementation SUDirectoryScanner (Private)

- (void) scanPath:(NSString *)path {
	NSDirectoryEnumerator *enumerator = [[NSFileManager defaultManager] enumeratorAtPath:path];
	NSString *subpath;
	while (subpath = [enumerator nextObject]) {
		NSString *fullPath = [path stringByAppendingPathComponent:subpath];
		if ([[SUDocument scribdFileTypes] containsObject:[fullPath pathExtension]]) {
			[SUDocument createFromPath:fullPath inManagedObjectContext:db.managedObjectContext];
			self.documentsFound++;
		}
	}
}

@end
