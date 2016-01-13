//
//  PLImageView.m
//  PDF Letterhead
//
//  Created by Richard Vollebregt on 06/01/16.
//  Copyright © 2016 Pim Snel. All rights reserved.
//

#import "PLImageView.h"

@implementation PLImageView

- (void)drawRect:(NSRect)dirtyRect {
    
    if ([self image]) {
        [[NSColor colorWithWhite:1 alpha:1] setFill];
    } else {
        [[NSColor colorWithWhite:1 alpha:0] setFill];
    }
    
    NSRectFill(dirtyRect);
    
    NSBezierPath *outerPath = [NSBezierPath bezierPathWithRect: [self bounds]];
    [[NSColor colorWithCGColor:CGColorCreateGenericGray(0,0.4)] set];
    [outerPath stroke];
    
    self.layer.masksToBounds = NO;
    
    [self setWantsLayer:YES];
    CALayer *imageLayer = self.layer;
    [imageLayer setBounds:[self bounds]];
    [imageLayer setShadowRadius:1];
    [imageLayer setShadowOffset:CGSizeZero];
    [imageLayer setShadowOpacity:1];
    [imageLayer setShadowColor:CGColorCreateGenericGray(0,0.25)];
    imageLayer.masksToBounds = NO;
    
    
    [NSGraphicsContext restoreGraphicsState];

    
    [super drawRect:dirtyRect];

}

@end
