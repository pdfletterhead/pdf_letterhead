//
//  PLBackgroundDropZoneContainer.m
//  PDF Letterhead
//
//  Created by Pim Snel on 11-12-12.
//  Copyright (c) 2012 Pim Snel. All rights reserved.
//

#import "PLBackgroundDropZoneContainer.h"

@implementation PLBackgroundDropZoneContainer

@synthesize background;

- (id)initWithFrame:(NSRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        
        NSShadow *dropShadow = [[NSShadow alloc] init];
        [dropShadow setShadowColor:[NSColor redColor]];
        [dropShadow setShadowOffset:NSMakeSize(0, 50.0)];
        [dropShadow setShadowBlurRadius:50.0];
        
      
        
        
        self.layer = _layer;   // strangely necessary
        self.wantsLayer = YES;
        self.layer.masksToBounds = YES;
        self.layer.cornerRadius = 10.0;
}
    
    return self;
}

- (void)drawRect:(NSRect)dirtyRect
{
    background = [NSColor colorWithDeviceRed: 229.0/255.0 green: 232.0/255.0 blue: 236.0/255.0 alpha: 1.0];
    [background set];
    NSRectFill([self bounds]);
}

@end
