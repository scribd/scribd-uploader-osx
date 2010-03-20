/*!
 @brief Methods for creating new SUDocument records.
 @ingroup model
 */

@interface SUDocument (Generators)

#pragma mark Creating new records

/*!
 @brief Creates a new document record from a file system path to a local file.
 @param path The path to the file.
 @param managedObjectContext The managed object context to insert the document
 into.
 @result The newly created, unsaved document managed object.
 */

+ (SUDocument *) createFromPath:(NSString *)path inManagedObjectContext:(NSManagedObjectContext *)managedObjectContext;

/*!
 @brief Creates a new document record from a URL to either a local or remote
 file.
 @param URL The URL for the file.
 @param managedObjectContext The managed object context to insert the document
 into.
 @result The newly created, unsaved document managed object.
 */

+ (SUDocument *) createFromURL:(NSURL *)URL inManagedObjectContext:(NSManagedObjectContext *)managedObjectContext;

/*!
 @brief Creates a new document record from a URL to either a local or remote
 file.
 @param URLString The URL string for the file.
 @param managedObjectContext The managed object context to insert the document
 into.
 @result The newly created, unsaved document managed object.
 */

+ (SUDocument *) createFromURLString:(NSString *)URLString inManagedObjectContext:(NSManagedObjectContext *)managedObjectContext;

@end
