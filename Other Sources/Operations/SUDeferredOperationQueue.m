@implementation SUDeferredOperationQueue

@synthesize isRunning;
@synthesize hasRun;
@synthesize delegate;

/*
 New queues start out suspended. Also initializes fields.
 */

- (id) init {
	if (self = [super init]) {
		[self setSuspended:YES];
		self.isRunning = NO;
		self.hasRun = NO;
		self.delegate = NULL;
	}
	return self;
}

/*
 Prevents operations from being added once the queue has been activated.
 */

- (void) addOperation:(NSOperation *)operation {
	@synchronized(self) {
		if (self.hasRun) return;
		[super addOperation:operation];
		[operation addObserver:self forKeyPath:@"isFinished" options:NSKeyValueObservingOptionNew context:NULL];
	}
}

- (void) run {
	@synchronized(self) {
		if (self.hasRun) return;
		self.hasRun = YES;
		self.isRunning = YES;
	}
	
	[self setSuspended:NO];
}

/*
 Received when an operation finishes. Checks to see if all operations have
 finished, and if so, calls the delegate.
 */

- (void) observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary *)change context:(void *)context {
    if ([keyPath isEqualToString:@"isFinished"]) {
		if ([self isFinished]) {
			SEL selector = @selector(deferredQueueDidComplete:);
			if ([delegate respondsToSelector:selector]) {
				NSMethodSignature *signature = [[delegate class] instanceMethodSignatureForSelector:selector];
				NSInvocation *invocation = [NSInvocation invocationWithMethodSignature:signature];
				[invocation setTarget:delegate];
				[invocation setSelector:selector];
				[invocation setArgument:&self atIndex:2];
				[invocation invoke];
			}
		}
	}
	else [super observeValueForKeyPath:keyPath ofObject:object change:change context:context];
}

- (BOOL) isFinished {
	for (NSOperation *operation in self.operations) if (![operation isFinished]) return NO;
	return YES;
}

- (BOOL) isEmpty {
	return [self.operations count] == 0;
}

@end
