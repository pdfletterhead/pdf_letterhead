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
    
    // add a background image
    NSColor *backgroundColor = [NSColor colorWithPatternImage:[NSImage imageNamed:@"coverdrop"]];
    [backgroundColor setFill];
    NSRectFill(dirtyRect);

//    // redraw the image to fit |yourView|'s size
//    UIGraphicsBeginImageContextWithOptions(yourView.frame.size, NO, 0.f);
//    [targetImage drawInRect:CGRectMake(0.f, 0.f, yourView.frame.size.width, yourView.frame.size.height)];
//    UIImage * resultImage = UIGraphicsGetImageFromCurrentImageContext();
//    UIGraphicsEndImageContext();
    
    [super drawRect:dirtyRect];


}

@end
