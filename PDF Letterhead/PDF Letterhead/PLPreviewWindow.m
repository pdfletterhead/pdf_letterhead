//
//  PLPreviewWindow.m
//  PDF Letterhead
//
//  Created by Pim Snel on 27-09-12.
//  Copyright (c) 2012 Pim Snel. All rights reserved.
//

#import "PLPreviewWindow.h"

@implementation PLPreviewWindow

- (void)orderOut:(id)sender;
{
    NSLog(@"did close");
    NSUInteger masks = [self styleMask];
    if ( masks & NSFullScreenWindowMask) {
        [self toggleFullScreen:sender];
    }
    
    [super orderOut:sender];
}

@end
