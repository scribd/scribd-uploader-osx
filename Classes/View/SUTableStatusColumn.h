/*!
 @class SUTableStatusColumn
 @abstract A customized
 @link //apple_ref/occ/cl/NSTableColumn NSTableColumn @/link that displays small
 transparent status buttons. These buttons have their icons bound to an
 @link SUDocument SUDocument's @/link status.
 @discussion This subclass sets images as well as alternate images, something
 that cannot be accomplished with bindings alone.
 */

@interface SUTableStatusColumn : NSTableColumn {
	NSMutableDictionary *cells;
}

@end
