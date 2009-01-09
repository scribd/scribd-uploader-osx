#import <Cocoa/Cocoa.h>

#import "SUConstants.h"
#import "SUDocument.h"
#import "ASIHTTPRequest.h"
#import "SUUploadDelegate.h"

/*!
 @class SUScribdAPI
 @abstract An Objective-C interface to the Scribd HTTP API.
 @discussion
 This singleton class acts as a basic library to communicate with the Scribd API
 server. It constructs valid API URL's, sends them to the Scribd API server, and
 parses the resulting XML.
 
 API information must be specified in a plist file titled "SUScribdAPI" in the
 root resources directory. This plist file must contain the following keys:
 
 BaseURL: The base URL of the Scribd API server, including a trailing question
 mark.
 
 APIKey: Your Scribd API key.
 
 APISecret: Your Scribd API secret. These are available from your settings page.
 */

@interface SUScribdAPI : NSObject {
	NSOperationQueue *uploadQueue;
}

/*!
 @method sharedAPI
 @abstract Returns the singleton instance.
 @result The singleton instance.
 */

+ (SUScribdAPI *) sharedAPI;

/*!
 @method callApiMethod:parameters:error:
 @abstract Makes an HTTP call to the Scribd API server and parses the response.
 @discussion The HTTP call will be made synchronously.
 @param method The Scribd API method.
 @param parameters A dictionary of API method parameters. Both keys and values
 should be @link //apple_ref/occ/cl/NSString NSStrings @/link.
 @param error This variable will contain a pointer to an
 @link //apple_ref/occ/cl/NSError @/link if something goes wrong. The error's
 domain will be @link SUScribdAPIErrorDomain @/link and the error code will be
 the error code given from the Scribd API. For a malformed XML response, the
 error code will be -1. A human-readable description of the error is given with
 the error's user info, mapped to the
 @link //apple_ref/doc/c_ref/NSLocalizedFailureReasonErrorKey NSLocalizedFailureReasonErrorKey @/link
 key.
 @result A dictionary containing the names and values of the nodes in the
 returned XML.
 */

- (NSDictionary *) callApiMethod:(NSString *)method parameters:(NSDictionary *)parameters error:(NSError **)error;

/*!
 @method apiSubmitFile:apiMethod:parameters:error:
 @abstract Uploads a file to Scribd via an API method.
 @discussion The HTTP call will be made asynchronously using ASIHTTPRequest.
 Information, such as progress and errors, are passed to an
 @link SUUploadDelegate SUUploadDelegate @/link.
 @param file The file to upload.
 @param method The Scribd API method.
 @param parameters A dictionary of API method parameters. Both keys and values
 should be @link //apple_ref/occ/cl/NSString NSStrings @/link.
 @param delegate The delegate object that receives progress updates and other
 events about the download.
 */

- (void) apiSubmitFile:(SUDocument *)file apiMethod:(NSString *)method parameters:(NSDictionary *)parameters delegate:(id)delegate;

@end
