//
//  PLMainWindowView.m
//  PDF Letterhead
//
//  Created by Pim Snel on 12-10-12.
//  Copyright (c) 2012 Pim Snel. All rights reserved.
//

#import "PLMainWindowView.h"

@implementation PLMainWindowView
@synthesize background;

- (id)initWithFrame:(NSRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {

    }
    
    return self;
}

- (void)drawRect:(NSRect)dirtyRect
{
    background = [NSColor colorWithDeviceRed: 240.0/255.0 green: 242.0/255.0 blue: 246.0/255.0 alpha: 1.0];
    [background set];
    NSRectFill([self bounds]);
}

@end
