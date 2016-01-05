//
//  PLTableRowView.m
//  PDF Letterhead
//
//  Created by Richard Vollebregt on 05/01/16.
//  Copyright © 2016 Pim Snel. All rights reserved.
//

#import "PLTableRowView.h"

@implementation PLTableRowView
- (id)init
{
    if (!(self = [super init])) return nil;
    return self;
}

- (void)drawSelectionInRect:(NSRect)dirtyRect {
    if (self.selectionHighlightStyle != NSTableViewSelectionHighlightStyleNone) {
        NSRect selectionRect = NSInsetRect(self.bounds, 2.5, 2.5);
        [[NSColor colorWithRed:0.271 green:0.588 blue:0.776 alpha:1.0] setFill];
        NSBezierPath *selectionPath = [NSBezierPath bezierPathWithRect:selectionRect];
        [selectionPath fill];
    }
}
@end
