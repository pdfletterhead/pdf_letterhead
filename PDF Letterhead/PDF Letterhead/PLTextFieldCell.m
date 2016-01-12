//
//  PLTextFieldCell.m
//  PDF Letterhead
//
//  Created by Richard Vollebregt on 12/01/16.
//  Copyright © 2016 Pim Snel. All rights reserved.
//

#import "PLTextFieldCell.h"

@implementation PLTextFieldCell


//Change color text when selected
- (void)setBackgroundStyle:(NSBackgroundStyle)backgroundStyle {

    if (backgroundStyle == NSBackgroundStyleLight) {
        self.textColor = [NSColor darkGrayColor];
    } else if (backgroundStyle == NSBackgroundStyleDark) {
        self.textColor = [NSColor whiteColor];
    }
    
}

@end
