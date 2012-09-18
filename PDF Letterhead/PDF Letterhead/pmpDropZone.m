//
//  DropZone.m
//  T3x Expander
//
//  Created by Pim Snel on 06-10-11.
//  Copyright 2011 Lingewoud B.V. All rights reserved.
//

#import "pmpDropZone.h"
#import "PLAppDelegate.h"

@implementation pmpDropZone

@synthesize sourcefilepath;


- (id)initWithCoder:(NSCoder *)decoder
{
    self = [super initWithCoder:decoder];
    if (self) {
        [self registerForDraggedTypes:[NSArray arrayWithObjects:
                                       NSColorPboardType, NSFilenamesPboardType, nil]];
        
        [self dropAreaFadeOut];
    }

    return self;

}
- (id)initWithFrame:(NSRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self registerForDraggedTypes:[NSArray arrayWithObjects:
                                       NSColorPboardType, NSFilenamesPboardType, nil]];

        [self dropAreaFadeOut];
        self.sourcefilepath = @"";
    }
    
    return self;
}

- (void)dropAreaFadeIn
{
    [self setAlphaValue:0.2];
}

- (void)dropAreaFadeOut
{
    [self setAlphaValue:1.0];


}

- (NSDragOperation)draggingEntered:(id <NSDraggingInfo>)sender {
    NSPasteboard *pboard;
    NSDragOperation sourceDragMask;
 
    NSLog(@"drag operation entered");
    sourceDragMask = [sender draggingSourceOperationMask];
    pboard = [sender draggingPasteboard];
    
    if ( [[pboard types] containsObject:NSFilenamesPboardType] ) {
        
        [self dropAreaFadeIn];
        
        if (sourceDragMask & NSDragOperationLink) {
            return NSDragOperationLink;
        } else if (sourceDragMask & NSDragOperationCopy) {
            return NSDragOperationCopy;
        }
    }
    return NSDragOperationNone;
}

- (void) draggingExited: (id <NSDraggingInfo>) info
{
    NSLog(@"drag operation finished");

    [self dropAreaFadeOut];
}

- (BOOL)performDragOperation:(id <NSDraggingInfo>)sender
{
    NSPasteboard *pboard = [sender draggingPasteboard];

    NSLog(@"drop now");
    [self dropAreaFadeOut];
    
    //int numberOfFiles = [files count];

    if ( [[pboard types] containsObject:NSFilenamesPboardType] ) {
    
        NSArray *files = [pboard propertyListForType:NSFilenamesPboardType];        
        if ([[[files objectAtIndex:0] pathExtension] isEqual:@"pdf"]){
           
            //NSString *zPath = [files lastObject];
            self.sourcefilepath = [files lastObject];
            NSImage *zNewImage = [[NSImage alloc] initWithContentsOfFile:[self sourcefilepath]];
            [self setImage:zNewImage];
            NSLog(@"sourcefilepath: %@",self.sourcefilepath);
            [[NSApp delegate] setPreview];


        } else {
            return NO;
        }
    }
}

-(NSString *) getFilepath{
    return self.sourcefilepath;
}

@end
