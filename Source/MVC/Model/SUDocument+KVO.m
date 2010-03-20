#import "SUDocument+KVO.h"

static NSOperationQueue *titleCleaningQueue = NULL;

@implementation SUDocument (KVO)

/*
 Initializes the title-cleaning queue.
 */

+ (void) initialize {
	titleCleaningQueue = [[NSOperationQueue alloc] init];
}

#pragma mark KVO

/*
 When the path changes, we need to check the title cleaner and suggest a title
 if one hasn't been added yet, and deallocate the kind so it can be recreated.
 */

- (void) observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary *)change context:(void *)context {
	if ([keyPath isEqualToString:@"path"]) {
		if (kind) [kind release];
		kind = NULL;
		
		if ([change objectForKey:NSKeyValueChangeNewKey] && [[change objectForKey:NSKeyValueChangeNewKey] isNotEqualTo:[NSNull null]]) {
			[titleCleaningQueue addOperationWithBlock:^{
				if (self.path && (!self.title || [self.title isEmpty])) {
					NSString *suggestedTitle = [[SUScribdAPI sharedAPI] titleForFilename:self.filename];
					if (suggestedTitle)
						[self performSelectorOnMainThread:@selector(setTitle:) withObject:suggestedTitle waitUntilDone:NO];
				}
			}];
		}
	}
	else [super observeValueForKeyPath:keyPath ofObject:object change:change context:context];
}

+ (NSSet *) keyPathsForValuesAffectingURL {
	return [NSSet setWithObject:@"path"];
}

+ (NSSet *) keyPathsForValuesAffectingFileSystemPath {
	return [NSSet setWithObject:@"path"];
}

+ (NSSet *) keyPathsForValuesAffectingFilename {
	return [NSSet setWithObject:@"path"];
}

+ (NSSet *) keyPathsForValuesAffectingKind {
	return [NSSet setWithObject:@"path"];
}

+ (NSSet *) keyPathsForValuesAffectingIcon {
	return [NSSet setWithObject:@"path"];
}

+ (NSSet *) keyPathsForValuesAffectingDiscoverability {
	return [NSSet setWithObjects:@"title", @"summary", @"category", @"hidden", NULL];
}

+ (NSSet *) keyPathsForValuesAffectingErrorLevel {
	return [NSSet setWithObjects:@"error", @"success", @"errorIsUnrecoverable", NULL];
}

+ (NSSet *) keyPathsForValuesAffectingRemoteFile {
	return [NSSet setWithObject:@"URL"];
}

+ (NSSet *) keyPathsForValuesAffectingScribdURL {
	return [NSSet setWithObject:@"scribdID"];
}

+ (NSSet *) keyPathsForValuesAffectingUploaded {
	return [NSSet setWithObject:@"scribdID"];
}

+ (NSSet *) keyPathsForValuesAffectingPostProcessing {
	return [NSSet setWithObjects:@"scribdID", @"converting", @"assigningProperties", NULL];
}

+ (NSSet *) keyPathsForValuesAffectingBytesUploaded {
	return [NSSet setWithObjects:@"hasSize", @"progress", @"totalBytes", NULL];
}

+ (NSSet *) keyPathsForValuesAffectingTotalBytes {
	return [NSSet setWithObjects:@"remoteFile", @"path", NULL];
}

+ (NSSet *) keyPathsForValuesAffectingHasSize {
	return [NSSet setWithObject:@"totalBytes"];
}

+ (NSSet *) keyPathsForValuesAffectingEstimatedSecondsRemaining {
	return [NSSet setWithObjects:@"hasSize", @"uploading", @"startTime", @"bytesUploaded", @"totalBytes", NULL];
}

+ (NSSet *) keyPathsForValuesAffectingUploading {
	return [NSSet setWithObjects:@"startTime", @"uploaded", NULL];
}

+ (NSSet *) keyPathsForValuesAffectingPending {
	return [NSSet setWithObject:@"startTime"];
}

@end
