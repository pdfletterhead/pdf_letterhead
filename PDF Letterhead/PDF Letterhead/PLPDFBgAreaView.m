//
//  PLPDFBgAreaView.m
//  PDF Letterhead
//
//  Created by Pim Snel on 12-12-12.
//  Copyright (c) 2012 Pim Snel. All rights reserved.
//

#import "PLPDFBgAreaView.h"

@implementation PLPDFBgAreaView

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
    NSImage *newImage = [[NSImage alloc] initWithContentsOfFile: [myBundle pathForResource:@"pdfviewbg" ofType:@"png"]];
    [newImage drawInRect:[self bounds] fromRect:NSZeroRect operation:NSCompositeSourceOver fraction:1];
}

@end
