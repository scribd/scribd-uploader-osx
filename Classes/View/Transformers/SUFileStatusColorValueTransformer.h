/*!
 @class SUFileStatusColorValueTransformer
 @abstract Converts a file's upload status into a color value.
 @discussion Red indicates an error, green indicates success, and all other
 statuses are black.
 */

@interface SUFileStatusColorValueTransformer : NSValueTransformer {
	NSColor *successColor, *errorColor, *otherColor;
}

@end
