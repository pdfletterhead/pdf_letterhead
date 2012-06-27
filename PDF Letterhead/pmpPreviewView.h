//
//  pmpPreviewView.h
//  background pdf
//
//  Created by Pim Snel on 16-04-12.
//  Copyright (c) 2012 Lingewoud b.v. All rights reserved.
//

#import <Cocoa/Cocoa.h>

@interface pmpPreviewView : NSView{
    NSRect rect;
    NSImage * bgImage; 
    NSImage * srcImage;
}
@property NSImage *bgImage;
@property NSImage *srcImage;

- (BOOL)backgroundImage:(NSImage *)newImage;
- (BOOL)sourceImage:(NSImage *)newImage;
- (void)saveToPDF:(NSString *)filename;
- (void)print:(id)sender;

@end
