#import "SUDocumentArrayController.h"

@implementation SUDocumentArrayController

#pragma mark Initializing and deallocating

/*
 Initializes value transformers.
 */

+ (void) initialize {
	[NSValueTransformer setValueTransformer:[[[SUSingleSelectionOnlyValueTransformer alloc] init] autorelease] forName:@"SUSingleOnly"];
	SUPluralizeValueTransformer *uploadedCopySummary = [[SUPluralizeValueTransformer alloc] initWithSingular:NSLocalizedString(@"This document has", @"already been uploaded") plural:NSLocalizedString(@"These documents have", @"already been uploaded")];
	[NSValueTransformer setValueTransformer:[uploadedCopySummary autorelease] forName:@"SUPluralizeThisDocumentHas"];
	SUPluralizeValueTransformer *uploadCopyDescription = [[SUPluralizeValueTransformer alloc] initWithSingular:NSLocalizedString(@"It can", @"be viewed") plural:NSLocalizedString(@"They can", @"be viewed")];
	[NSValueTransformer setValueTransformer:[uploadCopyDescription autorelease] forName:@"SUPluralizeItCan"];
}

#pragma mark Actions

- (IBAction) viewOnWebsite:(id)sender {
	if ([[self selectedObjects] count] == 1) {
		SUDocument *document = [[self selectedObjects] objectAtIndex:0];
		if (document.uploaded) [[NSWorkspace sharedWorkspace] openURL:document.scribdURL];
	}
}

- (IBAction) editOnWebsite:(id)sender {
	if ([[self selectedObjects] count] == 1) {
		SUDocument *document = [[self selectedObjects] objectAtIndex:0];
		if (document.uploaded) [[NSWorkspace sharedWorkspace] openURL:document.editURL];
	}
}

@end
