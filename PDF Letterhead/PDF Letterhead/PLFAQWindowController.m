//
//  PLFAQWindowController.m
//  PDF Letterhead
//
//  Created by Pim Snel on 18-09-12.
//  Copyright (c) 2012 Pim Snel. All rights reserved.
//

#import "PLFAQWindowController.h"

@interface PLFAQWindowController ()

@end

@implementation PLFAQWindowController

- (id)initWithWindow:(NSWindow *)window
{
    self = [super initWithWindow:window];
    if (self) {
    }
    
    return self;
}

- (void)awakeFromNib
{
    [_FAQView readRTFDFromFile:[[NSBundle mainBundle] pathForResource:@"FAQ" ofType:@"rtf"]];
}

- (void)windowDidLoad
{
    [super windowDidLoad];


    
    // Implement this method to handle any initialization after your window controller's window has been loaded from its nib file.
}



@end
