//
//  PLPDFPage.m
//  PDF Letterhead
//
//  Created by Pim Snel on 17-09-12.
//  Copyright (c) 2012 Pim Snel. All rights reserved.
//

#import "PLPDFPage.h"
static void fitRectInRect (NSRect *srcRect, NSRect destRect);

@implementation PLPDFPage

- (id) initWithBGImage: (NSImage *) bgimage sourceDoc: (NSImage *) sourceimage
{
	self = [super init];
	
	// Retain, assign image.
	_bgimage = [bgimage copy];
	_frontimage = [sourceimage copy];
		
	return self;

}



- (NSRect) boundsForBox: (PDFDisplayBox) box
{
	// Always return 8.5 x 11 inches (in points of course).
//	return NSMakeRect(0.0, 0.0, 612.0, 792.0);
    return NSMakeRect(0.0, 0.0, 595, 842);

}



- (void) drawWithBox: (PDFDisplayBox) box
{
	NSRect		sourceRect;
	NSRect		topHalf;
	NSRect		destRect;
	
	// Drag image.
	// ...........
	// Source rectangle.
	sourceRect.origin = NSMakePoint(0.0, 0.0);
	sourceRect.size = [_bgimage size];
	
	// Represent the top half of the page.
	topHalf = [self boundsForBox: box];
	//topHalf.origin.y += topHalf.size.height / 2.0;
	//topHalf.size.height = (topHalf.size.height / 2.0) - 36.0;
	
	// Scale and center image within top half of page.
	destRect = sourceRect;
	fitRectInRect(&destRect, topHalf);
	
	// Draw.
//	[_bgimage drawInRect: destRect fromRect: sourceRect operation: NSCompositeSourceOver fraction: 1.0];
	[_frontimage drawInRect: destRect fromRect: sourceRect operation: NSCompositeSourceOver fraction: 1.0];
	[_bgimage drawInRect: destRect fromRect: sourceRect operation: NSCompositeSourceOver fraction: 1.0];

}

static void fitRectInRect (NSRect *srcRect, NSRect destRect)
{
	NSRect		fitRect;
	
	// Assign.
	fitRect = *srcRect;
	
	// Only scale down.
	if (fitRect.size.width > destRect.size.width)
	{
		float		scaleFactor;
		
		// Try to scale for width first.
		scaleFactor = destRect.size.width / fitRect.size.width;
		fitRect.size.width *= scaleFactor;
		fitRect.size.height *= scaleFactor;
		
		// Did it pass the bounding test?
		if (fitRect.size.height > destRect.size.height)
		{
			// Failed above test -- try to scale the height instead.
			fitRect = *srcRect;
			scaleFactor = destRect.size.height / fitRect.size.height;
			fitRect.size.width *= scaleFactor;
			fitRect.size.height *= scaleFactor;
		}
	}
	else if (fitRect.size.height > destRect.size.height)
	{
		float		scaleFactor;
		
		// Scale based on height requirements.
		scaleFactor = destRect.size.height / fitRect.size.height;
		fitRect.size.height *= scaleFactor;
		fitRect.size.width *= scaleFactor;
	}
	
	// Center.
	fitRect.origin.x = destRect.origin.x + ((destRect.size.width - fitRect.size.width) / 2.0);
	fitRect.origin.y = destRect.origin.y + ((destRect.size.height - fitRect.size.height) / 2.0);
	
	// Assign back.
	*srcRect = fitRect;
}

@end
