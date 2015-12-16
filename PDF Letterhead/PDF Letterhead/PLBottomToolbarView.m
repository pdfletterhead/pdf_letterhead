//
//  PLBottomToolbarView.m
//  PDF Letterhead
//
//  Created by Pim Snel on 11-12-12.
//  Copyright (c) 2012 Pim Snel. All rights reserved.
//

#import "PLBottomToolbarView.h"

@implementation PLBottomToolbarView
@synthesize background;

- (id)initWithFrame:(NSRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code here.
    }
    
    return self;
}


- (void)drawRect:(NSRect)rect   {
    background = [NSColor colorWithDeviceRed: 51.0/255.0 green: 51.0/255.0 blue: 51.0/255.0 alpha: 1.0];
    [background set];
    NSRectFill([self bounds]);
    
}


@end
