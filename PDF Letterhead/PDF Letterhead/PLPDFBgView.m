//
//  PLPDFBgView.m
//  PDF Letterhead
//
//  Created by Pim Snel on 12-12-12.
//  Copyright (c) 2012 Pim Snel. All rights reserved.
//

#import "PLPDFBgView.h"

@implementation PLPDFBgView

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
    
        //background = [NSColor colorWithCalibratedRed:(74/255.0) green:(74/255.0) blue:(74/255.0) alpha:1.0f];
        NSColor * background = [NSColor colorWithDeviceRed: 51.0/255.0 green: 51.0/255.0 blue: 51.0/255.0 alpha: 1.0];
        
        [background set];
        NSRectFill([self bounds]);
}

@end
