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
    //background = [NSColor colorWithCalibratedRed:(74/255.0) green:(74/255.0) blue:(74/255.0) alpha:1.0f];
    background = [NSColor colorWithDeviceRed: 225.0/255.0 green: 229.0/255.0 blue: 234.0/255.0 alpha: 1.0];

    [background set];
    NSRectFill([self bounds]);
}

@end
