#import <Cocoa/Cocoa.h>

#import "ASIFormDataRequest.h"
#import "SUDocument.h"
#import "SUScribdAPI.h"
#import "NSError_SUAdditions.h"
#import "SUConstants.h"
#import "SUUploadCompleteSheetDelegate.h"

@class SUUploadHelper;

/*!
 @class SUUploadDelegate
 @abstract Receives asynchronous events pertaining to a file's upload progress,
 updates the view, and handles post-processing after the upload is complete.
 @discussion
 This class receives events about an upload's progress and updates
 the @link SUDocument SUDocument's @/link progress attribute as appropriate.
 
 Once the upload is complete, this class parses the response XML and displays
 any appropriate errors to the user, or removes the object from the list if the
 upload was successful.
 */

@interface SUUploadDelegate : NSObject {
	SUDocument *document;
	double progress, progressMax;
	NSWindow *uploadWindow, *uploadCompleteSheet;
	SUUploadCompleteSheetDelegate *uploadCompleteSheetDelegate;
	NSManagedObjectContext *managedObjectContext;
	SUUploadHelper *uploader;
}

/*!
 @property uploadWindow
 @abstract The window containing the file list.
 @discussion This window will be the parent for error sheets displayed by this
 class.
 */

@property (retain) NSWindow *uploadWindow;

/*!
 @property uploadCompleteSheet
 @abstract The window displayed as a sheet when all uploads are complete.
 */

@property (retain) NSWindow *uploadCompleteSheet;

/*!
 @property uploadCompleteSheetDelegate
 @abstract The delegate object that will receive events from the
 @link uploadCompleteSheet uploadCompleteSheet @/link.
 */

@property (retain) SUUploadCompleteSheetDelegate *uploadCompleteSheetDelegate;

/*!
 @method initWithDocument:
 @abstract Initializes a new instance that manages the upload process for a
 given document.
 @param doc The document being uploaded.
 @param context The managed object context the document lives in.
 @param caller The upload helper that is uploading this file.
 @result The initialized instance.
 @discussion This is the designated initializer.
 */

- (id) initWithDocument:(SUDocument *)doc inManagedObjectContext:(NSManagedObjectContext *)context fromUploader:(SUUploadHelper *)caller;

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
