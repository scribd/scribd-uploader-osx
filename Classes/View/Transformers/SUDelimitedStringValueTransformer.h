/*!
 @class SUDelimitTagsValueTransformer
 @abstract Two-way value transformer that splits strings and joins arrays on a
 delimiting character.
 @discussion For the model-to-view transformation, a string of tags is split on
 the character to make an array. For the view-to-model transformation, an array
 of strings is joined using the delimiter.
 */

@interface SUDelimitedStringValueTransformer : NSValueTransformer {
	NSString *delimiter;
}

/*!
 @property delimiter
 @abstract The character this value transformer splits and joins strings and
 arrays on.
 */

@property (copy) NSString *delimiter;

/*!
 @method init
 @abstract Initializes this value transformer using the comma as the delimiter.
 @result The initialized object.
 */

- (id) init;

/*!
 @method initWithDelimiter:
 @abstract Initializes this value transformer with a custom string delimiter.
 @param delim The string delimiter.
 @result The initialized object.
 @discussion This is the designated initializer.
 */

- (id) initWithDelimiter:(NSString *)delim;

@end
