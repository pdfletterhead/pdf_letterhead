//
//  PLButton.h
//  PDF Letterhead
//
//  Created by Richard Vollebregt on 17/12/15.
//  Copyright © 2015 Pim Snel. All rights reserved.
//

#import <Cocoa/Cocoa.h>

@interface PLButton : NSButton
{
    NSColor *startingColor;
    NSColor *endingColor;
    int angle;
}

@property(nonatomic, retain) NSColor *startingColor;
@property(nonatomic, retain) NSColor *endingColor;
@property(assign) int angle;

@end
