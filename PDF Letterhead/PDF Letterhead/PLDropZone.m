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
    //NSLog(@"initWithCoder");
    //[self setAllowsCutCopyPaste:NO];
    
    return self;

}

/*- (id)initWithFrame:(NSRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self registerForDraggedTypes:[NSArray arrayWithObjects:
                                       NSColorPboardType, NSFilenamesPboardType, nil]];

        [self dropAreaFadeOut];
        self.sourcefilepath = @"";
    }
    NSLog(@"initWithFrame");
    
    return self;
}
*/





- (void)setImage:(NSImage *)newImage{
    
    NSBundle* myBundle = [NSBundle mainBundle];
    if([[self identifier] isEqualToString:@"sourceDropArea"]){
        
        if(!newImage){
            NSString* myImagePath = [myBundle pathForResource:@"dragContentDocument" ofType:@"png"];
            newImage = [[NSImage alloc] initWithContentsOfFile: myImagePath];
            [[NSApp delegate] setIsSetContent:NO];
        }
        else{
            [[NSApp delegate] setIsSetContent:YES];
        }
        
        //NSLog(@"not storing prefs %@",[self identifier]);
        
    }
    else{
        if(!newImage){
            NSString* myImagePath = [myBundle pathForResource:@"dragLetterheadDocument" ofType:@"png"];
            newImage = [[NSImage alloc] initWithContentsOfFile: myImagePath];

            if([[self identifier] isEqualToString:@"bgDropArea"]){
                [[NSApp delegate] saveBackgroundImagePathInPrefs: nil atIndex:0 cover:NO];
                [[NSApp delegate] setIsSetBackground:NO];
            }
            else{
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
    [self setAlphaValue:0.2];
}

- (void)dropAreaFadeOut
{
    [self setAlphaValue:1.0];


}

- (NSDragOperation)draggingEntered:(id <NSDraggingInfo>)sender {
    NSPasteboard *pboard;
    NSDragOperation sourceDragMask;

 
    //NSLog(@"drag operation entered");
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
    //NSLog(@"drag operation finished");

    [self dropAreaFadeOut];
}

- (BOOL)performDragOperation:(id <NSDraggingInfo>)sender
{
//    NSImageView *theDropArea = (NSImageView *)sender;
    NSPasteboard *pboard = [sender draggingPasteboard];

    //NSLog(@"drop now on %@",[self identifier]);
    [self dropAreaFadeOut];
    
    //int numberOfFiles = [files count];

    if ( [[pboard types] containsObject:NSFilenamesPboardType] ) {
    
        NSArray *files = [pboard propertyListForType:NSFilenamesPboardType];
        
        if([files count]>1)
        {
            NSLog(@"ask for folder to store");
        }
        
        if ([[[files objectAtIndex:0] pathExtension] isEqual:@"pdf"]){
           
            //NSString *zPath = [files lastObject];
            self.sourcefilepath = [files lastObject];
            NSImage *zNewImage = [[NSImage alloc] initWithContentsOfFile:[self sourcefilepath]];
            [self setImage:zNewImage];
            //NSLog(@"sourcefilepath: %@",self.sourcefilepath);
            
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

@end
