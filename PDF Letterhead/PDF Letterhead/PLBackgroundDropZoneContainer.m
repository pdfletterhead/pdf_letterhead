//
//  PLBackgroundDropZoneContainer.m
//  PDF Letterhead
//
//  Created by Pim Snel on 11-12-12.
//  Copyright (c) 2012 Pim Snel. All rights reserved.
//

#import "PLBackgroundDropZoneContainer.h"

@implementation PLBackgroundDropZoneContainer

@synthesize background;

- (id)initWithFrame:(NSRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
     
        self.layer = _layer;   // strangely necessary
        self.wantsLayer = YES;
        self.layer.masksToBounds = YES;
        self.layer.cornerRadius = 5.0;
        
        [self.layer setBorderColor:[NSColor colorWithRed:0.765 green:0.788 blue:0.812 alpha:1].CGColor];
        [self.layer setBorderWidth:1.0];
    }
    
    return self;
}

- (void)drawRect:(NSRect)dirtyRect
{
    background = [NSColor colorWithDeviceRed: 229.0/255.0 green: 232.0/255.0 blue: 236.0/255.0 alpha: 1.0];
    [background set];
    NSRectFill([self bounds]);
    
    // Describe an inset rect
    NSRect whiteRect = NSInsetRect([self bounds], 0, 0);
    
    // Create and fill the shown path
    NSBezierPath * path = [NSBezierPath bezierPathWithRect:whiteRect];
    [path fill];
    
    // Save the graphics state for shadow
    [NSGraphicsContext saveGraphicsState];
    
    // Set the shown path as the clip
    [path setClip];
    
    // Create and stroke the shadow
    NSShadow * shadow = [[NSShadow alloc] init];
    [shadow setShadowColor:[NSColor lightGrayColor]];
    [shadow setShadowBlurRadius:3.0];
    [shadow set];
    [path stroke];
    
    // Restore the graphics state
    [NSGraphicsContext restoreGraphicsState];
    
}

@end
