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
	
	[super dealloc];
}

- (void) addDirectoryPath:(NSString *)path {
	NSOperation *operation = [[SUDirectoryScanOperation alloc] initWithPath:path inManagedObjectContext:db.managedObjectContext];
	[pendingQueue addOperation:operation];
	[operation release];
}

- (void) beginScanning {
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
	[operationQueue release];
	operationQueue = NULL;
	
	self.isScanning = NO;
	[[NSNotificationCenter defaultCenter] postNotificationName:SUScanningDoneNotification object:NULL];
}

- (IBAction) cancelScanning:(id)sender {
	[operationQueue cancelAllOperations];
	[operationQueue release];
	operationQueue = NULL;
	
	self.isScanning = NO;
	[[NSNotificationCenter defaultCenter] postNotificationName:SUScanningDoneNotification object:NULL];
}

/*
 Removes the sheet once it closes.
 */

- (void) sheetDidEnd:(NSWindow *)endingSheet returnCode:(int)returnCode contextInfo:(void *)contextInfo {
	[endingSheet orderOut:self];
}

@end

