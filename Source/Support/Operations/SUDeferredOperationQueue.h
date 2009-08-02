/*!
 @class SUDeferredOperationQueue
 @abstract A subclass of
 @link //apple_ref/occ/cl/NSOperationQueue NSOperationQueue @/link that defers
 its operations until it is "fired," at which point operations commence.
 @discussion This operation queue is meant to be used in two stages: adding
 operations and executing them. In the first stage, the queue is suspended, and
 operations are added that will be executed later. In the second stage, the
 queue is activated and all operations are executed. No new operations can be
 added once processing commences.
 
 This class is meant to be a one-off operation queue. Once a queue has been run
 it should be discarded, as no new operations can be added.
 
 This class sends a message to a delegate to inform the delegate when processing
 has completed. The delegate should implement deferredQueueDidComplete: taking
 the operation queue that has completed.
 
 Like its superclass, this is a thread-safe class.
 */

@interface SUDeferredOperationQueue : NSOperationQueue {
	BOOL isRunning;
	BOOL hasRun;
	id delegate;
}

#pragma mark Properties

/*!
 @property isRunning
 @abstract True if the operation queue is currently processing its tasks.
 */

@property (assign) BOOL isRunning;

/*!
 @property hasRun
 @abstract True if the operation queue has been activated.
 */

@property (assign) BOOL hasRun;

/*!
 @property delegate
 @abstract This object will be sent delegate messages. It is not retained.
 */

@property (assign) id delegate;

#pragma mark Starting the queue

/*!
 @method run
 @abstract Begins processing the operations assigned to this queue. After this
 point no new operations can be added.
 */

- (void) run;

/*!
 @method isFinished
 @abstract Returns whether or not all operations have completed.
 @result YES if all operations have completed; NO if at least one operation is
 in a state other than completed.
 */

- (BOOL) isFinished;

#pragma mark Managing Operations in the Queue

/*!
 @method isEmpty
 @abstract Returns whether or not at least one operation has been added.
 @result YES if no operations have yet been added to this queue; NO if at least
 one operation has been added.
 */

- (BOOL) isEmpty;

@end
