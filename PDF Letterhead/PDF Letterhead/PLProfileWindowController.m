//
//  PLProfileWindowController.m
//  PDF Letterhead
//
//  Created by Richard Vollebregt on 10/12/15.
//  Copyright © 2015 Pim Snel. All rights reserved.
//

#import "PLProfileWindowController.h"
#import "Profile.h"

@interface PLProfileWindowController ()
@property (unsafe_unretained) IBOutlet NSMenuItem *openCover;
@property (unsafe_unretained) IBOutlet NSMenuItem *delCover;
@property (unsafe_unretained) IBOutlet NSMenuItem *openBackground;
@property (unsafe_unretained) IBOutlet NSMenuItem *delBackground;

@end

@implementation PLProfileWindowController

- (id)initWithWindow:(NSWindow *)window
{
    self = [super initWithWindow:window];
    if (self) {
    }
    
    return self;
}

- (void)windowDidLoad
{
    [super windowDidLoad];        
}

-(Profile*)getCurrentProfile {
    if ([[self.profileArrayController selectedObjects] count] > 0) {
        return [[self.profileArrayController selectedObjects] objectAtIndex:0];
    } else {
        return nil;
    }
}


- (IBAction)doAddCover:(id)sender {
    [self openExistingDocument :@"cover"];
}

- (IBAction)doDelCover:(id)sender {
    [self delExistingDocument :@"cover"];
}

- (IBAction)doAddBg:(id)sender {
    [self openExistingDocument :@"background"];
}

- (IBAction)doDelBg:(id)sender {
    [self delExistingDocument :@"background"];
}

- (void)openExistingDocument :(NSString*)cover {
    NSOpenPanel* openPanel = [NSOpenPanel openPanel];
    [openPanel setCanChooseFiles:YES];
    [openPanel setCanChooseDirectories:NO];
    [openPanel setAllowsMultipleSelection:NO];
    
    // This method displays the panel and returns immediately.
    // The completion handler is called when the user selects an
    // item or cancels the panel.
    
    [openPanel beginWithCompletionHandler:^(NSInteger result){
        if (result == NSFileHandlingPanelOKButton) {
            NSString *file = [[openPanel URL] path];
            NSString *ext = [[file pathExtension] lowercaseString ];
            
            NSSet *validImageExtensions = [NSSet setWithArray:[NSImage imageFileTypes]];
            if ([validImageExtensions containsObject:ext])  {
                NSImage *zNewImage = [[NSImage alloc] initWithContentsOfFile:file];
                if ([self makeOrFindAppSupportDirectory]) {
                    Profile *profile = [self getCurrentProfile];
                    if (profile) {
                        [self saveImage:zNewImage :profile :cover];
                    }
                }
            }
            else {
                NSLog(@"invalid filetype, no IMAGE");
            }
        }
    }];

}

- (void)delExistingDocument:(NSString*)cover {
    Profile *profile = [self getCurrentProfile];
    [self removeImage:profile :cover];
}

// Create a unique string for the images
-(NSString *)createUniqueString {
    CFUUIDRef theUUID = CFUUIDCreate(NULL);
    CFStringRef string = CFUUIDCreateString(NULL, theUUID);
    CFRelease(theUUID);
    return (__bridge NSString *)string;
}

-(void)removeImage:(Profile*)profile :(NSString*)cover {
    if ([cover isEqual:@"cover"]) {
        profile.coverImagePath = nil;
        
    } else {
        profile.bgImagePath = nil;
    }
}

-(BOOL)saveImage:(NSImage*)image :(Profile*)profile :(NSString*)cover {
    // 1. Get an NSBitmapImageRep from the image passed in
    [image lockFocus];
    NSBitmapImageRep *imgRep = [[NSBitmapImageRep alloc] initWithFocusedViewRect:NSMakeRect(0.0, 0.0, [image size].width, [image size].height)];
    [image unlockFocus];
    
    // 2. Create URL to where image will be saved
    NSURL *pathToImage = [self.pathToAppSupport URLByAppendingPathComponent:[NSString stringWithFormat:@"%@.png",[self createUniqueString]]];
    NSData *data = [imgRep representationUsingType: NSPNGFileType properties: nil];
    
    // 3. Write image to disk, set path in Bug
    if ([data writeToURL:pathToImage atomically:NO]) {
        
        if ([cover isEqual:@"cover"]) {
            profile.coverImagePath = [pathToImage absoluteString];

        } else {
            profile.bgImagePath = [pathToImage absoluteString];
        }
        return YES;
    } else {
        return NO;
    }
}

-(BOOL)makeOrFindAppSupportDirectory {
    BOOL isDir;
    NSFileManager *manager = [NSFileManager defaultManager];
    if ([manager fileExistsAtPath:[self.pathToAppSupport absoluteString] isDirectory:&isDir] && isDir) {
        return YES;
    } else {
        NSError *error = nil;
        [manager createDirectoryAtURL:self.pathToAppSupport withIntermediateDirectories:YES attributes:nil error:&error];
        if (!error) {
            return YES;
        } else {
            NSLog(@"Error creating directory");
            return NO;
        }
    }
}



@end
