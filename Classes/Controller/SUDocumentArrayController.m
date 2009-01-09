#import "SUDocumentArrayController.h"

@implementation SUDocumentArrayController

/*
 Validates a drop, returning whether the items to be dropped can be dropped in
 the file view.
 */

- (NSDragOperation) tableView:(NSTableView *)tableView validateDrop:(id<NSDraggingInfo>)info proposedRow:(int)row proposedDropOperation:(NSTableViewDropOperation)operation {
	if (!uploader.currentlyUploadingCount && [[[info draggingPasteboard] types] containsObject:NSFilenamesPboardType])
		return NSDragOperationGeneric;
	else return NSDragOperationNone;
}

/*
 Accepts a drop, adding the dropped files to the file list.
 */

- (BOOL) tableView:(NSTableView *)tableView acceptDrop:(id<NSDraggingInfo>)info row:(int)row dropOperation:(NSTableViewDropOperation)operation {
	NSArray *files = [[info draggingPasteboard] propertyListForType:NSFilenamesPboardType];
	BOOL atLeastOneWasAdded = NO;
	for (NSString *path in files) {
		if ([[[SUDocumentHelper documentManager] scribdFileTypes] containsObject:[path pathExtension]]) {
			SUDocument *existingDocument = NULL;
			if (existingDocument = [[SUDocumentHelper documentManager] findDocumentByPath:path inManagedObjectContext:db.managedObjectContext])
				[db.managedObjectContext deleteObject:existingDocument];
			NSManagedObject *file = [NSEntityDescription insertNewObjectForEntityForName:@"Document" inManagedObjectContext:db.managedObjectContext];
			[file setValue:[path stringByStandardizingPath] forKey:@"path"];
			atLeastOneWasAdded = YES;
		}
	}
	return atLeastOneWasAdded;
}

@end
