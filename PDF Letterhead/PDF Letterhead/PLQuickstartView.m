//
//  PLQuickstartView.m
//  PDF Letterhead
//
//  Created by Richard Vollebregt on 18/01/16.
//  Copyright © 2016 Pim Snel. All rights reserved.
//

#import "PLQuickstartView.h"

@implementation PLQuickstartView

- (void)drawRect:(NSRect)dirtyRect
{
    [[NSColor whiteColor] set];
    NSRectFill(dirtyRect);
}

@end
