//
//  PLQuickStart1.m
//  PDF Letterhead
//
//  Created by Pim Snel on 15-01-13.
//  Copyright (c) 2013 Pim Snel. All rights reserved.
//

#import "PLQuickStart1.h"
#import "PLAppDelegate.h"

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
    
    [_closeButton setTitle:NSLocalizedString(@"Close", @"Close")];

    NSBundle* myBundle = [NSBundle mainBundle];
    NSString* myImagePath = [myBundle pathForResource:NSLocalizedString(@"splashscreen-eng", @"splashscreen-eng") ofType:@"png"];
    NSImage *splashImage = [[NSImage alloc] initWithContentsOfFile: myImagePath];
    [_featureImage setImage:splashImage];
    
    PLAppDelegate *delegate = [NSApp delegate];
    
    if( [[delegate retrievePrice] priceFound]==YES){
        NSString * price = [[delegate retrievePrice] formattedPrice];
        NSString * buttonTitle = [NSString stringWithFormat:@"%@ (%@)", NSLocalizedString(@"Upgrade", @"Buy now for only $x.xx button"), price];
        [_buyButton setTitle:buttonTitle];
    }
    self.window.backgroundColor = [NSColor clearColor];
    [[_buyButton cell] setKBButtonType:BButtonTypeBuy];

    [super windowDidLoad];
}

- (IBAction)buyNowAction:(id)sender {
    [[NSWorkspace sharedWorkspace] openURL:[NSURL URLWithString:@"http://www.pdfletterhead.net/?utm_source=splashscreen&utm_medium=app&utm_campaign=letterhead-app&redirect=true"]];
    [self close];
}

@end
