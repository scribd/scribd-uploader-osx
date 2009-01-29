#import "SUDirectoryScanner.h"

@implementation SUDirectoryScanner

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
	NSOperation *operation = [[SUDirectoryScanOperation alloc] initWithPath:path inManagedObjectContext:db.managedObjectContext];
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
	}
	
	[operationQueue run];
	[[NSNotificationCenter defaultCenter] postNotificationName:SUScanningStartedNotification object:NULL];
}

/*
 Called when the operation queue completes; closes the sheet.
 */

- (void) deferredQueueDidComplete:(SUDeferredOperationQueue *)queue {
	self.isScanning = NO;
	
	[operationQueue release];
	operationQueue = NULL;
	pool = NULL;
	
	[[NSNotificationCenter defaultCenter] postNotificationName:SUScanningDoneNotification object:NULL];
	
	[pool release];
}

- (IBAction) cancelScanning:(id)sender {
	@synchronized(self) {
		if (!self.isScanning) return;
		[operationQueue cancelAllOperations];
		[operationQueue release];
		operationQueue = NULL;
		self.isScanning = NO;
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

