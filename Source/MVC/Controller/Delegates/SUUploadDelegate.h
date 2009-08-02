/*!
 @class SUUploadDelegate
 @abstract Receives asynchronous events pertaining to a file's upload progress,
 updates the view, and handles post-processing after the upload is complete. It
 is initialized and given a document, and assigned as the delegate to the
 ASIHTTPRequest handling the upload.
 @discussion This class receives events about an upload's progress and updates
 the @link SUDocument SUDocument's @/link progress attribute as appropriate. In
 order to be compatible with ASIHTTPRequest, this class duck-types
 @link //apple_ref/occ/cl/NSProgressIndicator NSProgressIndicator @/link.
 
 Once the upload is complete, this class parses the response XML and handles any
 errors by archiving them and storing them in the SUDocument instance. It then
 begins the two post-upload tasks: assigning properties and creating an
 @link SUConversionStatusTracker SUConversionStatusTracker @/link task.
 */

@interface SUUploadDelegate : NSObject {
	@private
		SUDocument *document;
		double progress, progressMax;
		NSManagedObjectContext *managedObjectContext;
		NSDateFormatter *dateFormatter;
}

#pragma mark Initializing and deallocating

/*!
 @method initWithDocument:
 @abstract Initializes a new instance that manages the upload process for a
 given document.
 @param doc The document being uploaded.
 @param context The managed object context the document lives in.
 @result The initialized instance.
 @discussion This is the designated initializer.
 */

- (id) initWithDocument:(SUDocument *)doc inManagedObjectContext:(NSManagedObjectContext *)context;

#pragma mark Delegate responders (ASIHTTPRequest)

/*!
 @method requestFinished:
 @abstract Called when the upload is complete. Updates the document's status
 (with the error if it failed, or with YES if it succeeded).
 @param request The upload request.
 */

- (void) requestFinished:(ASIHTTPRequest *)request;

/*!
 @method requestFailed:
 @abstract Called if the upload fails. Adds the error to the document's status.
 @param request The upload request.
 */

- (void) requestFailed:(ASIHTTPRequest *)request;

@end
