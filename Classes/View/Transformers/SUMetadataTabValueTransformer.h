/*!
 @class SUMetadataTabValueTransformer
 @abstract Decides which borderless, unlabeled tab of the metadata drawer should
 be displayed based on whether or not the selected file has been uploaded or not.
 @discussion If the file has not yet been uploaded, the value "Before Upload"
 will be returned. If the file has been uploaded, "After Upload" will be
 returned. These literals correspond to the labels of the two tabs of the tab
 view.
 */

@interface SUMetadataTabValueTransformer : NSObject {
	
}

@end
