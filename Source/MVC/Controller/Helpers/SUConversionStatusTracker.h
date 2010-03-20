/*!
 @brief Asynchronously and periodically polls Scribd.com for the conversion
 status of a document, updating its converting attribute as appropriate.
 @details The conversion tracking begins as soon as an instance is created
 with a document. This class should be autoreleased to ensure it doesn't go out
 of scope.
 
 This class sends a request to Scribd.com every two seconds. Multiple
 simultaneous instances do not throttle their requests.
 @todo Throttle requests if there are lots of instances of this class.
 @ingroup helpers
 */

@interface SUConversionStatusTracker : NSObject {
	@protected
		NSTimer *timer;
	@private
		SUDocument *document;
}

#pragma mark Initializing and deallocating
/** @name Initializing and deallocating */
//@{

/*!
 @brief Creates a new instance that tracks a given document.
 @param doc The document to track.
 @result The initialized instance.
 @details This is the designated initializer.
 */

- (id) initWithDocument:(SUDocument *)doc;

//@}

#pragma mark Configuration
/** @name Configuration */
//@{

/*!
 @brief The document whose conversion status this instance is tracking and
 updating.
 */

@property (retain) SUDocument *document;

//@}
@end
