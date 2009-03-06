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

#pragma mark Working with the singleton instance

/*!
 @method sharedAPI
 @abstract Returns the singleton instance.
 @result The singleton instance.
 */

+ (SUScribdAPI *) sharedAPI;

#pragma mark Calling Scribd API methods

/*!
 @method callAPIMethod:parameters:error:
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

- (NSDictionary *) callAPIMethod:(NSString *)method parameters:(NSDictionary *)parameters error:(NSError **)error;

/*!
 @method asynchronouslyCallAPIMethod:parameters:error:
 @abstract Makes an HTTP call to the Scribd API server, with future events
 handled by a given delegate.
 @discussion The HTTP call will be made asynchronously using ASIHTTPRequest.
 Information, such as progress and errors, are passed to an
 @link SUUploadDelegate SUUploadDelegate @/link.
 @param method The Scribd API method.
 @param parameters A dictionary of API method parameters. Both keys and values
 should be @link //apple_ref/occ/cl/NSString NSStrings @/link.
 @param delegate The delegate object that receives progress updates and other
 events about the HTTP call.
 */

- (void) asynchronouslyCallAPIMethod:(NSString *)method parameters:(NSDictionary *)parameters delegate:(id)delegate;

/*!
 @method submitFile:toAPIMethod:parameters:error:
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

- (void) submitFile:(SUDocument *)file toAPIMethod:(NSString *)method parameters:(NSDictionary *)parameters delegate:(id)delegate;

#pragma mark Using other Scribd.com features

/*!
 @method autocompletionsForSubstring:
 @abstract Returns a list of predefined tag names beginning with a substring.
 @discussion A remote call to the Scribd server is made. Tag names are returned
 as strings ordered by their frequency of appearance in normal English use.
 @param substring The string to search for tags by.
 @result An ordered list of tag names beginning with the substring.
 */

- (NSArray *) autocompletionsForSubstring:(NSString *)substring;

/*!
 @method titleForFilename:
 @abstract Given the name of a file, returns a "cleaned up" title with spaces
 added, file extension removed, and other formatting improvements.
 @discussion A remote call to the Scribd server is made.
 @param filename The name of the file.
 @result A title suggestion for the file, or NULL if no suggestion could be
 made.
 */

- (NSString *) titleForFilename:(NSString *)filename;

/*!
 @method loadCategoriesIntoManagedObjectContext:
 @abstract Downloads an XML list of categories from the server and populates the
 persistent store with the categories.
 @param managedObjectContext The managed object context to load the categories
 into.
 @discussion Clears out existing categories, if any, before replacing them with
 the new category list.
 */

- (void) loadCategoriesIntoManagedObjectContext:(NSManagedObjectContext *)managedObjectContext;

@end
