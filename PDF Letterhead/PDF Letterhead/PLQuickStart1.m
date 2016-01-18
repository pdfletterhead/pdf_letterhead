//
//  PLQuickStart1.m
//  PDF Letterhead
//
//  Created by Pim Snel on 15-01-13.
//  Copyright (c) 2013 Pim Snel. All rights reserved.
//

#import "PLQuickStart1.h"

@interface PLQuickStart1 ()

@end

@implementation PLQuickStart1

- (id)initWithWindow:(NSWindow *)window
{
    self = [super initWithWindow:window];
    return self;
}

- (void)windowDidLoad
{
    self.window.backgroundColor = [NSColor whiteColor];
    [super windowDidLoad];
}

- (IBAction)buyNowAction:(id)sender {
    [[NSWorkspace sharedWorkspace] openURL:[NSURL URLWithString:@"http://www.pdfletterhead.net/?utm_source=splashscreen&utm_medium=app&utm_campaign=letterhead-app"]];
}

@end
