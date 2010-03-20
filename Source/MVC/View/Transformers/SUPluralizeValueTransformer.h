/*!
 @brief Receives an integer number of objects and returns either the singular or
 plural form of a phrase depending on the value received.
 @details This transformer must be initialized with the singular and plural
 versions of the phrase to be returned.
 @ingroup transformers
 */

@interface SUPluralizeValueTransformer : NSObject {
	@protected
		NSString *singular, *plural;
}

#pragma mark Initializing and deallocating
/** @name Initializing and deallocating */
//@{

/*!
 @brief Creates a new transformer with the given singular and plural phrases.
 @param sing The singular version of the phrase.
 @param plu the plural version of the phrase.
 @result The initialized instance.
 */

- (id) initWithSingular:(NSString *)sing plural:(NSString *)plu;

//@}
@end
