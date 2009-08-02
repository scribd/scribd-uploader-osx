@class SUDocument;

/*!
 @class SUTitleCleanerOperation
 @abstract Operation that calls Scribd's title cleaner providing a document's
 filename, receives a title suggestion, and applies that suggestion to the
 document's title.
 */

@interface SUTitleCleanerOperation : NSOperation {
	@protected
		SUDocument *document;
}

#pragma mark Properties

/*!
 @property document
 @abstract The document whose title will be cleaned.
 */

@property (retain) SUDocument *document;

#pragma mark Initializing and deallocating

/*!
 @method initWithDocument:
 @abstract The designated initializer takes a document whose title will be
 cleaned.
 @param doc The document.
 @result The initialized instance.
 */

- (id) initWithDocument:(SUDocument *)doc;

@end
