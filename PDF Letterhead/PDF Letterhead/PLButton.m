//
//  PLButton.m
//  PDF Letterhead
//
//  Created by Richard Vollebregt on 17/12/15.
//  Copyright © 2015 Pim Snel. All rights reserved.
//

#import "PLButton.h"

@implementation PLButton

@synthesize startingColor;
@synthesize endingColor;
@synthesize angle;

- (id)initWithFrame:(NSRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code here.
        [self setStartingColor:[NSColor colorWithCalibratedRed:252.0 green:252.0 blue:252.0 alpha:1.0]];
        [self setEndingColor:[NSColor colorWithCalibratedRed:234.0 green:237.0 blue:242.0 alpha:1.0]];
        [self setAngle:90];
    }
    return self;
}

- (void)drawRect:(NSRect)dirtyRect {
    [super drawRect:dirtyRect];
    
    // Drawing code here.
    self.layer = _layer;   // strangely necessary
    self.wantsLayer = YES;
    self.layer.masksToBounds = YES;
    self.layer.cornerRadius = 5.0;
    [[self layer] setBorderColor:CGColorCreateGenericRGB(194.0,201.0,208.0,1.0)];
    [[self layer] setBorderWidth:1.0];
    
    // Fill view with a top-down gradient
    // from startingColor to endingColor
    NSGradient* aGradient = [[NSGradient alloc]
                             initWithStartingColor:startingColor
                             endingColor:endingColor];
    [aGradient drawInRect:[self bounds] angle:angle];
}

@end