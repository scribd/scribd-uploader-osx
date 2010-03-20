/*!
 @brief An Objective-C interface to the Scribd HTTP API.
 @details This singleton class acts as a basic library to communicate with the
 Scribd API server. It constructs valid API URLs, sends them to the Scribd API
 server, and parses the resulting XML.
 
 API information must be specified in a plist file titled "SUScribdAPI" in the
 root resources directory. This plist file must contain the following keys:
 
 - @c BaseURL: The base URL of the Scribd API server, including a trailing
   question mark.
 - @c APIKey: Your Scribd API key.
 - @c APISecret: Your Scribd API secret. These are available from your settings
   page.
 @ingroup network
 */

@interface SUScribdAPI : NSObject {
	@protected
		NSOperationQueue *uploadQueue;
}

#pragma mark Working with the singleton instance
/** @name Working with the singleton instance */
//@{

/*!
 @brief Returns the singleton instance.
 @result The singleton instance.
 */

+ (SUScribdAPI *) sharedAPI;

//@}

#pragma mark Calling Scribd API methods
/** @name Calling Scribd API methods */
//@{

/*!
 @brief Makes an HTTP call to the Scribd API server and parses the response.
 @details The HTTP call will be made synchronously.
 @param method The Scribd API method.
 @param parameters A dictionary of API method parameters. Both keys and values
 should be <tt>NSString</tt>s.
 @param error This variable will contain a pointer to an @c NESError if
 something goes wrong. The error's domain will be
 @link SUScribdAPIErrorDomain @endlink and the error code will be the error code
 given from the Scribd API. For a malformed XML response, the error code will be
 -1. A human-readable description of the error is given with the error's user
 info, mapped to the @c NSLocalizedFailureReasonErrorKey key.
 @result A dictionary containing the names and values of the nodes in the
 returned XML.
 */

- (NSDictionary *) callAPIMethod:(NSString *)method parameters:(NSDictionary *)parameters error:(NSError **)error;

/*!
 @brief Makes an HTTP call to the Scribd API server, with future events handled
 by a given delegate.
 @details The HTTP call will be made asynchronously using ASIHTTPRequest.
 Information, such as progress and errors, are passed to an SUUploadDelegate.
 @param method The Scribd API method.
 @param parameters A dictionary of API method parameters. Both keys and values
 should be <tt>NSString</tt>s.
 @param delegate The delegate object that receives progress updates and other
 events about the HTTP call.
 */

- (void) asynchronouslyCallAPIMethod:(NSString *)method parameters:(NSDictionary *)parameters delegate:(id)delegate;

/*!
 @brief Uploads a file to Scribd via an API method.
 @details The HTTP call will be made asynchronously using @c ASIHTTPRequest.
 Information, such as progress and errors, are passed to an SUUploadDelegate.
 @param file The file to upload.
 @param method The Scribd API method.
 @param parameters A dictionary of API method parameters. Both keys and values
 should be <tt>NSString</tt>s.
 @param delegate The delegate object that receives progress updates and other
 events about the download.
 */

- (void) submitFile:(SUDocument *)file toAPIMethod:(NSString *)method parameters:(NSDictionary *)parameters delegate:(id)delegate;

/*!
 @brief Converts a Scribd XML response to an @c NSDictionary and constructs an
 @c NSError if necessary. Returns @c NULL if the XML cannot be parsed.
 @param xml The XML returned by Scribd.com.
 @param error Upon exit, will contain an error if the response contains an
 error code. The error code will be equal to the error code returned in the XML,
 and its localized failure reason will be taken from the XML error description.
 If the XML could not be parsed, the error code will be -1.
 @result A dictionary describing the response. The dictionary's keys and values
 will be pulled from the response XML.
 */

- (NSDictionary *) parseResponseXML:(NSXMLDocument *)xml error:(NSError **)error;

//@}

#pragma mark Using other Scribd.com features
/** @name Using other Scribd.com features */
//@{

/*!
 @brief Returns a list of predefined tag names beginning with a substring.
 @details A remote call to the Scribd server is made synchronously. Tag names
 are returned as strings ordered by their frequency of appearance in normal
 English use.
 @param substring The string to search for tags by.
 @result An ordered list of tag names beginning with the substring.
 */

- (NSArray *) autocompletionsForSubstring:(NSString *)substring;

/*!
 @brief Given the name of a file, returns a "cleaned up" title with spaces
 added, file extension removed, and other formatting improvements.
 @details A remote call to the Scribd server is made.
 @param filename The name of the file.
 @result A title suggestion for the file, or @c NULL if no suggestion could be
 made.
 */

- (NSString *) titleForFilename:(NSString *)filename;

/*!
 @brief Downloads an XML list of categories from the server and populates the
 persistent store with the categories.
 @param managedObjectContext The managed object context to load the categories
 into.
 @details Clears out existing categories, if any, before replacing them with the
 new category list.
 */

- (void) loadCategoriesIntoManagedObjectContext:(NSManagedObjectContext *)managedObjectContext;

//@}
@end
