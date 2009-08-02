/*!
 @class SUConversionStatusTracker
 @abstract Asynchronously and periodically polls Scribd.com for the conversion
 status of a document, updating its converting attribute as appropriate.
 @discussion The conversion tracking begins as soon as an instance is created
 with a document. This class should be autoreleased to ensure it doesn't go out
 of scope.
 
 This class sends a request to Scribd.com every second. Multiple simultaneous
 instances do not throttle their requests.
 */

@interface SUConversionStatusTracker : NSObject {
	SUDocument *document;
	NSTimer *timer;
}

#pragma mark Properties

/*!
 @property document
 @abstract The document whose conversion status this instance is tracking and
 updating.
 */

@property (retain) SUDocument *document;

#pragma mark Initializing and deallocating

/*!
 @property initWithDocument:
 @abstract Creates a new instance that tracks a given document.
 @param doc The document to track.
 @result The initialized instance.
 @discussion This is the designated initializer.
 */

- (id) initWithDocument:(SUDocument *)doc;

@end
