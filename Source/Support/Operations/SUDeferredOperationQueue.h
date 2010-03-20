/*!
 @brief A subclass of @c NSOperationQueue that defers its operations until it is
 "fired," at which point operations commence.
 @details This operation queue is meant to be used in two stages: adding
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
 @ingroup operations
 */

@interface SUDeferredOperationQueue : NSOperationQueue {
	@protected
		BOOL isRunning;
		BOOL hasRun;
		id delegate;
}

#pragma mark Properties

/*!
 @brief @c YES if the operation queue is currently processing its tasks.
 */

@property (assign) BOOL isRunning;

/*!
 @brief @c YES if the operation queue has been activated.
 */

@property (assign) BOOL hasRun;

/*!
 @brief This object will be sent delegate messages. It is not retained.
 */

@property (assign) id delegate;

#pragma mark Starting the queue
/** @name Starting the queue */
//@{

/*!
 @brief Begins processing the operations assigned to this queue. After this
 point no new operations can be added.
 */

- (void) run;

/*!
 @brief Returns whether or not all operations have completed.
 @result @c YES if all operations have completed; @c NO if at least one
 operation is in a state other than completed.
 */

- (BOOL) isFinished;

//@}

#pragma mark Managing Operations in the Queue
/** @name Managing Operations in the Queue */
//@{

/*!
 @brief Returns whether or not at least one operation has been added.
 @result @c YES if no operations have yet been added to this queue; @c NO if at
 least one operation has been added.
 */

- (BOOL) isEmpty;

//@}
@end
