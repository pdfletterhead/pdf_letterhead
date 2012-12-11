//
//  PLBackgroundDropZoneContainer.m
//  PDF Letterhead
//
//  Created by Pim Snel on 11-12-12.
//  Copyright (c) 2012 Pim Snel. All rights reserved.
//

#import "PLBackgroundDropZoneContainer.h"

@implementation PLBackgroundDropZoneContainer

- (id)initWithFrame:(NSRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code here.
    }
    
    return self;
}

- (void)drawRect:(NSRect)dirtyRect
{
    NSBundle* myBundle = [NSBundle mainBundle];
    if([[self identifier] isEqualToString:@"sourceContainer"]){
        NSImage *newImage = [[NSImage alloc] initWithContentsOfFile: [myBundle pathForResource:@"contentbg" ofType:@"png"]];
        [newImage drawInRect:[self bounds] fromRect:NSZeroRect operation:NSCompositeSourceOver fraction:1];

    }
    else{
        NSImage *newImage = [[NSImage alloc] initWithContentsOfFile: [myBundle pathForResource:@"dropzonebg" ofType:@"png"]];
        [newImage drawInRect:[self bounds] fromRect:NSZeroRect operation:NSCompositeSourceOver fraction:1];

    }

    
    
    
    
    //[newImage drawAtPoint:NSZeroPoint fromRect:NSZeroRect operation:NSCompositeSourceOver fraction:1];
    
    // Or stretch image to fill view
  //  [newImage drawInRect:[self bounds] fromRect:NSZeroRect operation:NSCompositeSourceOver fraction:1];
    // Drawing code here.
}

@end
