#import "SUImagePreviewView.h"

@implementation SUImagePreviewView

- (void) awakeFromNib {
	background = [[NSImage alloc] initWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"Preview Background" ofType:@"png"]];
	
	NSSize originalSize = NSMakeSize(692, 894);
	CGFloat originalShadowWidth = 80;
	shadowOffsetFactor = NSMakePoint(originalShadowWidth/originalSize.width,
									 originalShadowWidth/originalSize.height);
	contentSizeFactor = NSMakeSize((originalSize.width - originalShadowWidth*2)/originalSize.width,
								   (originalSize.height - originalShadowWidth*2)/originalSize.height);
}
	
- (void) dealloc {
	[background release];
	[super dealloc];
}

- (void) drawRect:(NSRect)rect {
	if ([self image]) {
		[background drawInRect:rect fromRect:NSZeroRect operation:NSCompositeSourceOver fraction:1.0];
		NSRect contentRect = NSMakeRect(shadowOffsetFactor.x*rect.size.width,
										shadowOffsetFactor.y*rect.size.height,
										contentSizeFactor.width*rect.size.width,
										contentSizeFactor.height*rect.size.height);
		[[self image] drawInRect:contentRect fromRect:NSZeroRect operation:NSCompositeSourceOver fraction:1.0];
	}
	else [super drawRect:rect];
}

@end
