//
//  DropZone.m
//  T3x Expander
//
//  Created by Pim Snel on 06-10-11.
//  Copyright 2011 Lingewoud B.V. All rights reserved.
//

#import "PLAppDelegate.h"
#import "PLDropZone.h"

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

- (void)setImage:(NSImage *)newImage{
    
    //NSLog(@"ximage: %@", newImage);
    
    if (newImage)
    {
        imageIsSet = YES;
    }
    else
    {
        imageIsSet = NO;
    }
    
    if([[self identifier] isEqualToString:@"sourceDropArea"]){
        
        if(!newImage){
            newImage = nil;
            [(PLAppDelegate *)[NSApp delegate] setIsSetContent:NO];

        }
        else{
            [(PLAppDelegate *)[NSApp delegate] setIsSetContent:YES];
            [self layer].contents = nil;

        }
    }
    else{
        if(!newImage){

            if([[self identifier] isEqualToString:@"bgDropArea"]){

                newImage = nil;
                [(PLAppDelegate *)[NSApp delegate] setIsSetBackground:NO];
            }
            else{
                newImage = nil;
                [(PLAppDelegate *)[NSApp delegate] setIsSetCover:NO];
            }
        }
        else{
            if([[self identifier] isEqualToString:@"bgDropArea"]){
                
                [(PLAppDelegate *)[NSApp delegate] setIsSetBackground:YES];
            }
            else{
                [(PLAppDelegate *)[NSApp delegate] setIsSetCover:YES];
            }
        }
    }
    [super setImage:newImage];
    //[(PLAppDelegate *)[NSApp delegate] renderPDF];
    
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
    PLAppDelegate *delegate = [[NSApplication sharedApplication] delegate ];
    NSPasteboard *pboard = [sender draggingPasteboard];

    [self dropAreaFadeOut];
    
    if ( [[pboard types] containsObject:NSFilenamesPboardType] ) {
    
        NSArray *files = [pboard propertyListForType:NSFilenamesPboardType];
        
        if([files count]>1)
        {
            NSLog(@"ask for folder to store");
        }
        
        NSString * ext = [[[files objectAtIndex:0] pathExtension] lowercaseString];
        
        if([[self identifier] isEqualToString:@"sourceDropArea"])
        {
            if ([ext isEqual:@"pdf"]){
                
                self.sourcefilepath = [files lastObject];
                BOOL ok = [self setPdfFilepath:[self sourcefilepath]];
                
                if (ok) {
                    [(PLAppDelegate *)[NSApp delegate] renderPDF];
                }
                
                return YES;
                
            } else {
                NSLog(@"invalid filetype, no PDF");
                return NO;
            }   
        }
        else
        {
            //NSString *loweredExtension = [[selectedFile pathExtension] lowercaseString];
            NSSet *validImageExtensions = [NSSet setWithArray:[NSImage imageFileTypes]];
            if ([validImageExtensions containsObject:ext])
            {
                self.sourcefilepath = [files lastObject];
                BOOL ok = [self setPdfFilepath:[self sourcefilepath]];
                
                //Check if we are editing a current profile
#ifdef PRO
                Profile *loadedProfile = [delegate performSelector:@selector(returnLoadedProfile)];
                PLProfileEditWindow *openedEditWindow = delegate.profileEditWindow;
                
                NSImage * newImage = [[NSImage alloc] initWithContentsOfFile:[self sourcefilepath]];
                
                if (loadedProfile) {
                    
                    loadedProfile.lastUpdated = [delegate performSelector:@selector(returnDateNow)];
                    
                    if([[self identifier] isEqualToString:@"coverDropArea"]) {
                        [openedEditWindow saveImage:newImage :loadedProfile :@"cover"];
                    } else {
                        [openedEditWindow saveImage:newImage :loadedProfile :@"background"];
                    }
                }
#endif
                
                if (ok) {
                    [(PLAppDelegate *)[NSApp delegate] renderPDF];
                }
                
                return YES;
            }
            else {
                NSLog(@"invalid filetype, no extension with pdf/png/jpg");
                return NO;
            }
            
        }
        
    }
    
    return NO;
}


-(BOOL) setPdfFilepath:(NSString*)path{
    
    if (path == nil) {
        [self setImage:nil];
        return YES;
    }
    
    NSMutableString *str = [[NSMutableString alloc] initWithString:path];
    NSString *word = @"file://";
    if ([str rangeOfString:word].location == NSNotFound) {
        [str insertString:word atIndex:0];
    }
    
    NSString *encodedString;
    NSString *decoded = [path stringByReplacingPercentEscapesUsingEncoding:NSUTF8StringEncoding];

    if ([path isEqualToString:decoded]) {
        encodedString = [str stringByAddingPercentEscapesUsingEncoding : NSUTF8StringEncoding];
    } else {
        encodedString = path;
    }

    NSLog(@"encodedstr: %@", encodedString);
    
    NSURL *data = [NSURL URLWithString:encodedString];
    NSImage *zNewImage = [[NSImage alloc] initWithContentsOfURL:data];
    
    NSLog(@"image: %@", zNewImage);
    
    [self setImage:zNewImage];
    
    return YES;

}


-(void) setFilepath:(NSString*)path{
     self.sourcefilepath = path;
}

-(NSString *) getFilepath{
    return self.sourcefilepath;
}

- (void)drawRect:(NSRect)frame {
    
    NSImage *coverImage = [NSImage imageNamed:@"coverdrop"];
    NSImage *sourceImage = [NSImage imageNamed:@"contentdrop"];
    NSImage *bgImage = [NSImage imageNamed:@"bgdrop"];
    
    NSBezierPath *outerPath = [NSBezierPath bezierPathWithRect: [self bounds]];
    [[NSColor colorWithCGColor:CGColorCreateGenericGray(0,0.4)] set];
    [outerPath stroke];
    
    self.layer.masksToBounds = NO;
    
    [self setWantsLayer:YES];
    CALayer *imageLayer = self.layer;
    [imageLayer setBounds:[self bounds]];
    [imageLayer setShadowRadius:2];
    [imageLayer setShadowOffset:CGSizeZero];
    [imageLayer setShadowColor:CGColorCreateGenericGray(0,0.5)];
    imageLayer.masksToBounds = NO;
    
    
    [NSGraphicsContext restoreGraphicsState];
    
    
    if (imageIsSet) {
        [[NSColor colorWithWhite:1 alpha:1] setFill];
        [imageLayer setShadowOpacity:1];
    } else {
        [[NSColor colorWithWhite:1 alpha:0] setFill];
        [imageLayer setShadowOpacity:0];
    }

    NSRectFill(frame);
    
    if ([[self identifier] isEqual:@"coverDropArea"]) {
        if (!imageIsSet) {
            [coverImage drawInRect:frame fromRect:NSZeroRect operation:NSCompositeSourceOver fraction:1];
        }
    }
    else if ([[self identifier] isEqual:@"sourceDropArea"]) {
        if (!imageIsSet) {
            [sourceImage drawInRect:frame fromRect:NSZeroRect operation:NSCompositeSourceOver fraction:1];
        }
    }
    else {
        if (!imageIsSet) {
            [bgImage drawInRect:frame fromRect:NSZeroRect operation:NSCompositeSourceOver fraction:1];
        }
    }

    [super drawRect:frame];
}


@end
