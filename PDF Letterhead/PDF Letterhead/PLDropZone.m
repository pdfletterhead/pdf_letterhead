//
//  DropZone.m
//  T3x Expander
//
//  Created by Pim Snel on 06-10-11.
//  Copyright 2011 Lingewoud B.V. All rights reserved.
//

#import "PLDropZone.h"
#import "PLAppDelegate.h"

@implementation PLDropZone

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

- (BOOL)becomeFirstResponder
{
    NSLog(@"is am selected");
    [[self animator] setAlphaValue:0.5];

    return YES;
}

- (BOOL)resignFirstResponder
{
    NSLog(@"is am deselected");
    [[self animator] setAlphaValue:1.0];
    
    return YES;
}

- (void)setImage:(NSImage *)newImage{
    
    NSBundle* myBundle = [NSBundle mainBundle];
    
    if(newImage)
    {
        imageIsSet = YES;
    }
    else
    {
        imageIsSet = NO;
    }
    
    
    
    if([[self identifier] isEqualToString:@"sourceDropArea"]){
        
        if(!newImage){
            NSString* myImagePath = [myBundle pathForResource:@"contentdrop" ofType:@"png"];
            newImage = [[NSImage alloc] initWithContentsOfFile: myImagePath];
            [[NSApp delegate] setIsSetContent:NO];
            
            //set main pdfview hidden
            [[[NSApp delegate] pdfView] setHidden:YES];
            //[[[NSApp delegate] pdfView] setNeedsDisplay:YES];
            //[[[NSApp delegate] pdfView] setAlphaValue:0.0];
        }
        else{
            [[NSApp delegate] setIsSetContent:YES];

            //set main pdfview visible
            [[[NSApp delegate] pdfView] setHidden:NO];
            //[[[NSApp delegate] pdfView] setAlphaValue:1.0];
              //setNeedsDisplay:YES];
        }
    }
    else{
        if(!newImage){

            if([[self identifier] isEqualToString:@"bgDropArea"]){

                NSString* myImagePath = [myBundle pathForResource:@"bgdrop" ofType:@"png"];
                newImage = [[NSImage alloc] initWithContentsOfFile: myImagePath];
                
                [[NSApp delegate] saveBackgroundImagePathInPrefs: nil atIndex:0 cover:NO];
                [[NSApp delegate] setIsSetBackground:NO];
            }
            else{
                NSString* myImagePath = [myBundle pathForResource:@"coverdrop" ofType:@"png"];
                newImage = [[NSImage alloc] initWithContentsOfFile: myImagePath];

                [[NSApp delegate] saveBackgroundImagePathInPrefs: nil atIndex:0 cover:YES];
                [[NSApp delegate] setIsSetCover:NO];
            }
        }
        else{
            if([[self identifier] isEqualToString:@"bgDropArea"]){
                
                [[NSApp delegate] saveBackgroundImagePathInPrefs: newImage atIndex:0 cover:NO];
                [[NSApp delegate] setIsSetBackground:YES];
            }
            else{
                [[NSApp delegate] saveBackgroundImagePathInPrefs: newImage atIndex:0 cover:YES];
                [[NSApp delegate] setIsSetCover:YES];
            }
        }
    }
    [super setImage:newImage];
        
    [[NSApp delegate] updatePreviewAndActionButtons];

}

- (void)dropAreaFadeIn
{
    [[self animator] setAlphaValue:0.2];
}

- (void)dropAreaFadeOut
{
    [[self animator ] setAlphaValue:1.0];
}

- (NSDragOperation)draggingEntered:(id <NSDraggingInfo>)sender {
    NSPasteboard *pboard;
    NSDragOperation sourceDragMask;

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
    [self dropAreaFadeOut];
}

- (BOOL)performDragOperation:(id <NSDraggingInfo>)sender
{
    NSPasteboard *pboard = [sender draggingPasteboard];

    [self dropAreaFadeOut];
    
    if ( [[pboard types] containsObject:NSFilenamesPboardType] ) {
    
        NSArray *files = [pboard propertyListForType:NSFilenamesPboardType];
        
        if([files count]>1)
        {
            NSLog(@"ask for folder to store");
        }
        
        if ([[[files objectAtIndex:0] pathExtension] isEqual:@"pdf"]){
           
            self.sourcefilepath = [files lastObject];
            NSImage *zNewImage = [[NSImage alloc] initWithContentsOfFile:[self sourcefilepath]];
            [self setImage:zNewImage];
            
            return YES;
            
        } else {
            NSLog(@"invalid filetype, no IMAGE");
            return NO;
        }
    }

    return NO;
}


-(BOOL) setPdfFilepath:(NSString*)path{
    if ([[path pathExtension] isEqual:@"pdf"]){
        
        self.sourcefilepath = path;
        NSImage *zNewImage = [[NSImage alloc] initWithContentsOfFile:[self sourcefilepath]];
        [self setImage:zNewImage];
        return YES;
    }

    return NO;
}


-(void) setFilepath:(NSString*)path{
     self.sourcefilepath = path;
}

-(NSString *) getFilepath{
    return self.sourcefilepath;
}

- (void)drawRect:(NSRect)frame {

    if(imageIsSet)
    {
        NSColor * background = [NSColor colorWithDeviceRed: 255.0/255.0 green: 255.0/255.0 blue: 255.0/255.0 alpha: 1.0];
        [background set];
        NSRectFill([self bounds]);
    }
    
    [super drawRect:frame];
}


@end
