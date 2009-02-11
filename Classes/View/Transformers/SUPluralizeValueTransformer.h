/*!
 @class SUPluralizeValueTransformer
 @abstract Receives an integer number of objects and returns either the singular
 or plural form of a phrase depending on the value received.
 @discussion This transformer must be initialized with the singular and plural
 versions of the phrase to be returned.
 */

@interface SUPluralizeValueTransformer : NSObject {
	NSString *singular, *plural;
}

#pragma mark Initializing and deallocating

/*!
 @method initWithSingular:plural:
 @abstract Creates a new transformer with the given singular and plural phrases.
 @param sing The singular version of the phrase.
 @param plu the plural version of the phrase.
 @result The initialized instance.
 */

- (id) initWithSingular:(NSString *)sing plural:(NSString *)plu;

@end
