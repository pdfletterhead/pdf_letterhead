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
    
    NSBezierPath *outerPath = [NSBezierPath bezierPathWithRect: [self bounds]];
    [[NSColor lightGrayColor] set];
    [outerPath stroke];
    
    self.layer.masksToBounds = NO;
    
    [self setWantsLayer:YES];
    CALayer *imageLayer = self.layer;
    [imageLayer setBounds:[self bounds]];
    [imageLayer setShadowRadius:3];
    [imageLayer setShadowOffset:CGSizeZero];
    [imageLayer setShadowOpacity:1];
    [imageLayer setShadowColor:CGColorCreateGenericGray(0, 1)];
    imageLayer.masksToBounds = NO;
    
    
    [NSGraphicsContext restoreGraphicsState];

    
    [super drawRect:dirtyRect];

}

@end
