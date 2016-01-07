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
    
    NSImage *image = [NSImage imageNamed:@"coverdrop"];
    NSSize size = NSSizeFromString(@"{60,80}");
    
    image = [self imageResize:image newSize:size];
    
    NSColor *backgroundColor = [NSColor colorWithPatternImage:image];
    [backgroundColor setFill];
    NSRectFill(dirtyRect);
    
    
    
    [super drawRect:dirtyRect];

}

- (NSImage *)imageResize:(NSImage*)anImage newSize:(NSSize)newSize {
    NSImage *sourceImage = anImage;
    [sourceImage setScalesWhenResized:YES];
    
    // Report an error if the source isn't a valid image
    if (![sourceImage isValid]){
        NSLog(@"Invalid Image");
    } else {
        NSImage *smallImage = [[NSImage alloc] initWithSize: newSize];
        [smallImage lockFocus];
        [sourceImage setSize: newSize];
        [[NSGraphicsContext currentContext] setImageInterpolation:NSImageInterpolationHigh];
        [sourceImage drawAtPoint:NSZeroPoint fromRect:CGRectMake(0, 0, newSize.width, newSize.height) operation:NSCompositeCopy fraction:1.0];
        [smallImage unlockFocus];
        return smallImage;
    }
    return nil;
}

@end
