#import <Cocoa/Cocoa.h>
#import "SUDocument.h"

/*!
 @class SUDocumentHelper
 @abstract Controller-level functions that work with documents.
 */

@interface SUDocumentHelper : NSObject {
	
}

/*!
 @method documentManager
 @abstract Returns the singleton instance.
 @result The singleton instance.
 */

+ (SUDocumentHelper *) documentManager;

/*!
 @method findDocumentByPath:inManagedObjectContext:
 @abstract Finds a document by its path. Assumes that only one or zero
 document object(s) will exist with that path.
 @param path The path to search by.
 @param managedObjectContext The managed object context to search in.
 @result The @link SUDocument @/link with that path, or NULL if no such
 document was found.
 */

- (SUDocument *) findDocumentByPath:(NSString *)path inManagedObjectContext:(NSManagedObjectContext *)managedObjectContext;

/*!
 @method documentpointsToActualFile:
 @abstract Tests if a file actually exists at the path stored by the document.
 @result True if the path yields an actual file.
 */

- (BOOL) documentPointsToActualFile:(SUDocument *)document;

/*!
 @method scribdFileTypes
 @abstract Returns an array of strings, each containing a valid file extension
 accepted by Scribd.
 @result An array of acceptable file types.
*/

- (NSArray *) scribdFileTypes;

/*!
 @method allDocumentsInManagedObjectContext:error:
 @abstract Returns an array of every document in the context.
 @param managedObjectContext The managed object context.
 @param error Stores any errors in fetching the documents.
 @result An array of @link SUDocument SUDocument @/link instances.
 */

- (NSArray *) allDocumentsInManagedObjectContext:(NSManagedObjectContext *)managedObjectContext error:(NSError **)error;

/*!
 @method pendingDocumentsInManagedObjectContext:error:
 @abstract Returns an array of every document in the context which has not yet
 been successfully uploaded.
 @param managedObjectContext The managed object context.
 @param error Stores any errors in fetching the documents.
 @result An array of @link SUDocument SUDocument @/link instances.
 */

- (NSArray *) pendingDocumentsInManagedObjectContext:(NSManagedObjectContext *)managedObjectContext error:(NSError **)error;

/*!
 @method completedDocumentsInManagedObjectContext:error:
 @abstract Returns an array of every document in the context which has been
 successfully uploaded.
 @param managedObjectContext The managed object context.
 @param error Stores any errors in fetching the documents.
 @result An array of @link SUDocument SUDocument @/link instances.
 */

- (NSArray *) completedDocumentsInManagedObjectContext:(NSManagedObjectContext *)managedObjectContext error:(NSError **)error;

@end
