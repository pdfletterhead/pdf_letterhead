//
//  PLButtonCell.m
//  PDF Letterhead
//
//  Created by Richard Vollebregt on 12/01/16.
//  Copyright © 2016 Pim Snel. All rights reserved.
//

#import "PLButtonCell.h"

@implementation PLButtonCell

- (NSBackgroundStyle)interiorBackgroundStyle
{
    if (self.backgroundStyle == NSBackgroundStyleLight) {
        self.image = [NSImage imageNamed:@"pencilgray"];
    } else if (self.backgroundStyle == NSBackgroundStyleDark) {
        self.image = [NSImage imageNamed:@"pencilwhite"];
    }
    return NSBackgroundStyleLowered;
}

@end
