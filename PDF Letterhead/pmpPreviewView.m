//
//  pmpPreviewView.m
//  background pdf
//
//  Created by Pim Snel on 16-04-12.
//  Copyright (c) 2012 Lingewoud b.v. All rights reserved.
//

#import "pmpPreviewView.h"

@implementation pmpPreviewView

@synthesize srcImage, bgImage;

- (id)initWithFrame:(NSRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {

      rect = [self bounds];      
      //bgImage = [[NSImage alloc] initWithContentsOfFile:@"/Users/pim/Desktop/source.pdf"];
      //srcImage = [[NSImage alloc] initWithContentsOfFile:@"/Users/pim/Desktop/source.pdf"];
    }
    
    return self;
}

- (BOOL)backgroundImage:(NSImage *)newImage {
    
    if (newImage && (newImage != bgImage)) {
        [newImage setSize:rect.size];
        [newImage setScalesWhenResized:YES];
        if ([newImage isValid]) {
            bgImage = newImage;
            
            [self setNeedsDisplay:YES];
            return YES;
        }
    }
    return NO;
}

- (BOOL)sourceImage:(NSImage *)newImage {
  
    NSLog(@"new source");

    if (newImage && (newImage != srcImage)) {
        [newImage setSize:rect.size];
        [newImage setScalesWhenResized:YES];
        if ([newImage isValid]) {
            srcImage = newImage;

            [self setNeedsDisplay:YES];
            return YES;
        }
    }
    return NO;
}

- (void)print:(id)sender{
    NSLog(@"lets print");
    [super print:sender];

}

- (void)saveToPDF:(NSString *)filename {
    NSRect r = [self bounds];
    NSData *data = [self dataWithPDFInsideRect:r];
    
    [data writeToFile:filename atomically:YES];
}

- (void)drawRect:(NSRect)dirtyRect
{

    [[NSColor whiteColor] set];
    NSRectFill(rect);

    [bgImage drawInRect:[self bounds] fromRect:NSZeroRect operation:NSCompositeSourceOver fraction:1];
    [srcImage drawInRect:[self bounds] fromRect:NSZeroRect operation:NSCompositeSourceOver fraction:1];
}

@end
