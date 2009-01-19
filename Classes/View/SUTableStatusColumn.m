#import "SUTableStatusColumn.h"

@implementation SUTableStatusColumn

/*
 Registers this instance as an observer of the data source's status attribute.
 */

- (void) awakeFromNib {
	[[[self tableView] dataSource] addObserver:self forKeyPath:@"arrangedObjects.errorLevel" options:NSKeyValueObservingOptionNew context:NULL];
}

/*
 Refreshes the icons of the buttons based on the new file statuses.
 */

- (void) observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary *)change context:(void *)context {
	if ([keyPath isEqualToString:@"arrangedObjects.errorLevel"]) {
		NSArray *levels = [object valueForKeyPath:keyPath];
		NSValueTransformer *buttonImageTransformer = [NSValueTransformer valueTransformerForName:@"SUFileStatusButtonImage"];
		NSInteger row;
		for (row = 0; row != [levels count]; row++)
			[(NSButtonCell *)([self dataCellForRow:row]) setImage:[buttonImageTransformer transformedValue:[levels objectAtIndex:row]]];
	}
	else [super observeValueForKeyPath:keyPath ofObject:object change:change context:context];
}

@end
