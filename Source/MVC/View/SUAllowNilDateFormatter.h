/*!
 @brief A subclass of the date formatter that accepts empty strings as
 placeholders for nil dates.
 @details If this class is asked to translate an empty or blank string, it will
 return nil for the date. If it is asked to give the string representation of a
 nil date, it will return an empty string.
 @ingroup view
 */

@interface SUAllowNilDateFormatter : NSDateFormatter {
	
}

@end
