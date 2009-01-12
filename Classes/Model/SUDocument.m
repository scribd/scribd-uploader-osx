#import "SUDocument.h"

@implementation SUDocument

@dynamic path;
@dynamic progress;
@dynamic success;
@dynamic error;
@dynamic scribdID;

/*
 You're not really supposed to override init for managed objects, but I see no
 other way I can ensure that wrapper is nilled out before anyone else touches it.
 */

- (id) init {
	if (self = [super init]) {
		wrapper = NULL;
		kind = NULL;
		status = NULL;
		[self addObserver:self forKeyPath:@"path" options:NSKeyValueObservingOptionNew context:NULL];
	}
	return self;
}

- (NSString *) filename {
	return [[NSFileManager defaultManager] displayNameAtPath:self.path];
}

- (NSString *) kind {
	if (!kind) {
		NSDictionary *kinds = [NSDictionary dictionaryWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"FileTypes" ofType:@"plist"]];
		kind = [[kinds objectForKey:[self.path pathExtension]] retain];
	}
	return kind;
}

- (NSImage *) icon {
	return [[self wrapper] icon];
}

/*
 Lazily initializes an NSFileWrapper for the file.
 */

- (NSFileWrapper *) wrapper {
	if (!wrapper) wrapper = [[NSFileWrapper alloc] initWithPath:self.path];
	return wrapper;
}

- (void) observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary *)change context:(void *)context {
	if ([keyPath isEqualToString:@"path"]) {
		wrapper = NULL;
		if (kind) [kind release];
		kind = NULL;
	}
	[super observeValueForKeyPath:keyPath ofObject:object change:change context:context];
}

/*
 When the path changes the filename must change as well.
 */

+ (NSSet *) keyPathsForValuesAffectingFilename {
	return [NSSet setWithObject:@"path"];
}

/*
 When the path changes the kind must change as well.
 */

+ (NSSet *) keyPathsForValuesAffectingKind {
	return [NSSet setWithObject:@"path"];
}

/*
 When the path changes the icon must change as well.
 */

+ (NSSet *) keyPathsForValuesAffectingIcon {
	return [NSSet setWithObject:@"path"];
}

/*
 Releases retained objects.
 */

- (void) dealloc {
	[wrapper release]; wrapper = NULL;
	if (kind) [kind release];
	[super dealloc];
}

@end
