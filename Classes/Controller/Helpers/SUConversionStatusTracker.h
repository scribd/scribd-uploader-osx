@interface SUConversionStatusTracker : NSObject {
	SUDocument *document;
}

@property (retain) SUDocument *document;

- (id) initWithDocument:(SUDocument *)doc;

@end
