/*!
 @category SUDocument(Finders)
 @abstract Methods for loading @link SUDocument SUDocument @/link records.
 */

@interface SUDocument (Finders)

#pragma mark Finding documents

/*!
 @method findByPath:inManagedObjectContext:
 @abstract Finds a document by its path. Assumes that only one or zero
 document object(s) will exist with that path.
 @param path The path to search by.
 @param managedObjectContext The managed object context to search in.
 @result The document with that path, or NULL if no such document was found.
 */

+ (SUDocument *) findByPath:(NSString *)path inManagedObjectContext:(NSManagedObjectContext *)managedObjectContext;

/*!
 @method findAllInManagedObjectContext:error:
 @abstract Returns an array of every document in the context.
 @param managedObjectContext The managed object context.
 @param error Stores any errors in fetching the documents.
 @result An array of all documents.
 */

+ (NSArray *) findAllInManagedObjectContext:(NSManagedObjectContext *)managedObjectContext error:(NSError **)error;

/*!
 @method findUploadableInManagedObjectContext:error:
 @abstract Returns an array of every document in the context that has not yet
 been successfully uploaded.
 @param managedObjectContext The managed object context.
 @param error Stores any errors in fetching the documents.
 @result An array of all pending documents.
 @discussion Documents that have been uploaded but have not successfully had
 their settings set will not be included in the result.
 */

+ (NSArray *) findUploadableInManagedObjectContext:(NSManagedObjectContext *)managedObjectContext error:(NSError **)error;

/*!
 @method findUploadedInManagedObjectContext:error:
 @abstract Returns an array of every document in the context that has been
 successfully uploaded.
 @param managedObjectContext The managed object context.
 @param error Stores any errors in fetching the documents.
 @result An array of all completed documents.
 */

+ (NSArray *) findUploadedInManagedObjectContext:(NSManagedObjectContext *)managedObjectContext error:(NSError **)error;

/*!
 @method numberOfUploadableInManagedObjectContext:error:
 @abstract Returns the total number of documents in the context that have not
 been successfully uploaded.
 @param managedObjectContext The managed object context.
 @param error Stores any errors in fetching the document count.
 @result The number of documents yet to be uploaded, or zero if an error
 occurred.
 @discussion Documents that were uploaded but could not have their settings
 changed will not be included in this count, as they have already been uploaded.
 */

+ (NSUInteger) numberOfUploadableInManagedObjectContext:(NSManagedObjectContext *)managedObjectContext error:(NSError **)error;

@end
