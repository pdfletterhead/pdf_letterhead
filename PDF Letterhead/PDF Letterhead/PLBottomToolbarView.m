//
//  PLBottomToolbarView.m
//  PDF Letterhead
//
//  Created by Pim Snel on 11-12-12.
//  Copyright (c) 2012 Pim Snel. All rights reserved.
//

#import "PLBottomToolbarView.h"

@implementation PLBottomToolbarView

- (id)initWithFrame:(NSRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code here.
    }
    
    return self;
}
- (BOOL)isFlipped
{
    return YES;
}

/*
- (void)setImage:(NSImage *)newImage
{
 //   [newImage retain];
  //  [image release];
    image = newImage;
    
    [image setFlipped:YES];
    [self setNeedsDisplay:YES];
}
 */

- (void)drawRect:(NSRect)rect
{
    NSBundle* myBundle = [NSBundle mainBundle];


    NSImage *newImage = [[NSImage alloc] initWithContentsOfFile: [myBundle pathForResource:@"bottomtoolbar" ofType:@"png"]];

    //[newImage drawAtPoint:NSZeroPoint fromRect:NSZeroRect operation:NSCompositeSourceOver fraction:1];
    
    // Or stretch image to fill view
    [newImage drawInRect:[self bounds] fromRect:NSZeroRect operation:NSCompositeSourceOver fraction:1];
}


@end
