#import "SUDocumentArrayController.h"

@implementation SUDocumentArrayController

#pragma mark Initializing and deallocating

/*
 Initializes value transformers.
 */

+ (void) initialize {
	[NSValueTransformer setValueTransformer:[[[SUSingleSelectionOnlyValueTransformer alloc] init] autorelease] forName:@"SUSingleOnly"];
	SUPluralizeValueTransformer *uploadedCopySummary = [[SUPluralizeValueTransformer alloc] initWithSingular:@"This document has" plural:@"These documents have"];
	[NSValueTransformer setValueTransformer:[uploadedCopySummary autorelease] forName:@"SUPluralizeThisDocumentHas"];
	SUPluralizeValueTransformer *uploadCopyDescription = [[SUPluralizeValueTransformer alloc] initWithSingular:@"It can" plural:@"They can"];
	[NSValueTransformer setValueTransformer:[uploadCopyDescription autorelease] forName:@"SUPluralizeItCan"];
}

#pragma mark Delegate responders

/*
 Validates a drop, returning whether the items to be dropped can be dropped in
 the file view.
 */

- (NSDragOperation) tableView:(NSTableView *)tableView validateDrop:(id<NSDraggingInfo>)info proposedRow:(int)row proposedDropOperation:(NSTableViewDropOperation)operation {
	if (!uploader.isUploading && [[[info draggingPasteboard] types] containsObject:NSFilenamesPboardType])
		return NSDragOperationGeneric;
	else return NSDragOperationNone;
}

/*
 Accepts a drop, adding the dropped files to the file list.
 */

- (BOOL) tableView:(NSTableView *)tableView acceptDrop:(id<NSDraggingInfo>)info row:(int)row dropOperation:(NSTableViewDropOperation)operation {
	NSArray *files = [[info draggingPasteboard] propertyListForType:NSFilenamesPboardType];
	return [db addFiles:files] > 0;
}

#pragma mark Actions

- (IBAction) viewOnWebsite:(id)sender {
	if ([[self selectedObjects] count] == 1) {
		SUDocument *document = [[self selectedObjects] objectAtIndex:0];
		if (document.isUploaded) [[NSWorkspace sharedWorkspace] openURL:document.scribdURL];
	}
}

- (IBAction) editOnWebsite:(id)sender {
	if ([[self selectedObjects] count] == 1) {
		SUDocument *document = [[self selectedObjects] objectAtIndex:0];
		if (document.isUploaded) [[NSWorkspace sharedWorkspace] openURL:document.editURL];
	}
}

@end
