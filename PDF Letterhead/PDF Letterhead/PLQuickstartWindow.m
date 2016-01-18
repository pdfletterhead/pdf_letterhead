//
//  PLQuickstartWindow.m
//  PDF Letterhead
//
//  Created by Richard Vollebregt on 18/01/16.
//  Copyright © 2016 Pim Snel. All rights reserved.
//

#import "PLQuickstartWindow.h"

@implementation PLQuickstartWindow

- (id)initWithContentRect:(NSRect)contentRect styleMask:(NSUInteger)aStyle backing:(NSBackingStoreType)bufferingType defer:(BOOL)flag
{
    self = [super initWithContentRect:contentRect styleMask:NSBorderlessWindowMask backing:bufferingType defer:flag];
    
    if ( self )
    {
        [self setStyleMask:NSBorderlessWindowMask];
        [self setOpaque:NO];
        [self setBackgroundColor:[NSColor whiteColor]];
    }
    
    return self;
}


- (void) setContentView:(NSView *)aView
{
    aView.wantsLayer            = YES;
    aView.layer.frame           = aView.frame;
    aView.layer.cornerRadius    = 5.0;
    aView.layer.masksToBounds   = YES;
    
    
    [super setContentView:aView];
    
}


@end
