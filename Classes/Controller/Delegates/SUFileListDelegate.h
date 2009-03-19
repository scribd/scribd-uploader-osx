/*!
 @class SUFileListDelegate
 @abstract Delegate class for the
 @link //apple_ref/occ/cl/NSTableView NSTableView @/link that lists the file
 queue.
 @discussion This delegate prepares the status cells, binding their image and
 alternate image values to their respective documents' errorLevel attributes.
 */

@interface SUFileListDelegate : NSObject {
	IBOutlet SUDocumentArrayController *documents;
}

@end
