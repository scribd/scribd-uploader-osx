/*!
 @brief Controller for the Quick Look data source, acting as a link between the
 Quick Look preview panel and the files array controller. Implements the
 @c QLPreviewPanelDataSource protocol.
 @details This class receives requests for information on the data source for
 Quick Look previews and returns information it obtains from the array
 controller.
 @ingroup quickLook
 */

@interface SUQuickLookDataSource : NSObject <QLPreviewPanelDataSource> {
	@private IBOutlet NSArrayController *files;
}

@end
