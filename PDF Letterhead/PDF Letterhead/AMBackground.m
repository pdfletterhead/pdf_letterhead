//
//  AMBackground.m
//  Button
//
//  Created by ampatspell on 5/4/10.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import "AMBackground.h"


@implementation AMBackground

- (id)initWithFrame:(NSRect)frame {
    if (self = [super initWithFrame:frame]) {
    }
    return self;
}

- (void)drawRect:(NSRect)rect {
    
    NSRect bounds = self.bounds;
    
    // Draw background gradient
    NSGradient *gradient = [[NSGradient alloc] initWithColorsAndLocations:
                            [NSColor colorWithDeviceWhite:0.15f alpha:1.0f], 0.0f, 
                            [NSColor colorWithDeviceWhite:0.19f alpha:1.0f], 0.5f, 
                            [NSColor colorWithDeviceWhite:0.20f alpha:1.0f], 0.5f, 
                            [NSColor colorWithDeviceWhite:0.25f alpha:1.0f], 1.0f, 
                            nil];
    
    [gradient drawInRect:bounds angle:90.0f];
    
    // Stroke bounds
    [[NSColor blackColor] setStroke];
    [NSBezierPath strokeRect:bounds];
}

@end
