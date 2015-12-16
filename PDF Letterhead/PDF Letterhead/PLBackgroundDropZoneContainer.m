//
//  PLBackgroundDropZoneContainer.m
//  PDF Letterhead
//
//  Created by Pim Snel on 11-12-12.
//  Copyright (c) 2012 Pim Snel. All rights reserved.
//

#import "PLBackgroundDropZoneContainer.h"

@implementation PLBackgroundDropZoneContainer

- (id)initWithFrame:(NSRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.layer = _layer;   // strangely necessary
        self.wantsLayer = YES;
        self.layer.masksToBounds = YES;
        self.layer.cornerRadius = 25.0;
        
        CALayer *viewLayer = [CALayer layer];
       [viewLayer setBackgroundColor:CGColorCreateGenericRGB(225.0, 229.0, 234.0, 1.0)]; //wtf is dit voor rare kleur?
       [self setLayer:viewLayer];
    }
    
    return self;
}

- (void)drawRect:(NSRect)dirtyRect  {

}

@end
