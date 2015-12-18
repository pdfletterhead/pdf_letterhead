//
//  PLProfileEditWindow.m
//  PDF Letterhead
//
//  Created by Richard Vollebregt on 17/12/15.
//  Copyright © 2015 Pim Snel. All rights reserved.
//

#import "PLProfileEditWindow.h"

@interface PLProfileEditWindow ()

//Deze properties moeten worden omgeschreven op een getter/setter manier ?
@property (unsafe_unretained) IBOutlet NSImageView *bgImage;
@property (unsafe_unretained) IBOutlet NSImageView *coverImage;
@property (unsafe_unretained) IBOutlet NSTextField *title;


@end

@implementation PLProfileEditWindow

- (void)windowDidLoad {
    [super windowDidLoad];
    
    // Implement this method to handle any initialization after your window controller's window has been loaded from its nib file.
    
    NSURL *bgPath = [NSURL URLWithString:_loadedProfile.bgImagePath];
    NSURL *coverPath = [NSURL URLWithString:_loadedProfile.coverImagePath];
   
    if (bgPath == nil) {
        [[self bgImage] setImage:nil];
    } else {
        NSImage *background = [[NSImage alloc] initWithContentsOfURL:bgPath];
        [[self bgImage] setImage:background];
    }
    if (coverPath == nil) {
        [[self coverImage] setImage:nil];
    } else {
        NSImage *cover = [[NSImage alloc] initWithContentsOfURL:coverPath];
        [[self coverImage] setImage:cover];
    }
    
    if (_loadedProfile.name != nil) {
        [[self title] setStringValue:_loadedProfile.name];
    }
}

-(Profile*)getCurrentProfile :(Profile *)profile {
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
//    NSOpenPanel* openPanel = [NSOpenPanel openPanel];
//    [openPanel setCanChooseFiles:YES];
//    [openPanel setCanChooseDirectories:NO];
//    [openPanel setAllowsMultipleSelection:NO];
//    
//    // This method displays the panel and returns immediately.
//    // The completion handler is called when the user selects an
//    // item or cancels the panel.
//    
//    [openPanel beginWithCompletionHandler:^(NSInteger result){
//        if (result == NSFileHandlingPanelOKButton) {
//            NSString *file = [[openPanel URL] path];
//            NSString *ext = [[file pathExtension] lowercaseString ];
//            
//            NSSet *validImageExtensions = [NSSet setWithArray:[NSImage imageFileTypes]];
//            if ([validImageExtensions containsObject:ext])  {
//                NSImage *zNewImage = [[NSImage alloc] initWithContentsOfFile:file];
//                if ([self makeOrFindAppSupportDirectory]) {
//                    Profile *profile = [self getCurrentProfile];
//                    if (profile) {
//                        [self saveImage:zNewImage :profile :cover];
//                    }
//                }
//            }
//            else {
//                NSLog(@"invalid filetype, no IMAGE");
//            }
//        }
//    }];
    NSLog(@"profile: %@", _loadedProfile);
}

- (void)delExistingDocument:(NSString*)cover {
//    Profile *profile = [self getCurrentProfile];
//    [self removeImage:profile :cover];
}

- (IBAction)addNewProfile:(id)sender {
    Profile* newProfile = [NSEntityDescription insertNewObjectForEntityForName:@"Profile" inManagedObjectContext:self.managedObjectContext];
    newProfile.name = @"New Letterhead";
    newProfile.uid = [self createUniqueString];
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

-(NSString*)saveImage:(NSImage*)image :(Profile*)profile :(NSString*)cover {
    // 1. Get an NSBitmapImageRep from the image passed in
    [image lockFocus];
    NSBitmapImageRep *imgRep = [[NSBitmapImageRep alloc] initWithFocusedViewRect:NSMakeRect(0.0, 0.0, [image size].width, [image size].height)];
    [image unlockFocus];
    
    // 2. Create URL to where image will be saved
    NSURL *pathToImage = [self.pathToAppSupport URLByAppendingPathComponent:[NSString stringWithFormat:@"%@.png",[self createUniqueString]]];
    NSData *data = [imgRep representationUsingType: NSPNGFileType properties: nil];
    NSString *returnVar;
    
    // 3. Write image to disk, set path in Bug
    if ([data writeToURL:pathToImage atomically:NO]) {
        
        if ([cover isEqual:@"cover"]) {
            profile.coverImagePath = [pathToImage absoluteString];
            returnVar = profile.coverImagePath;
            
        } else {
            profile.bgImagePath = [pathToImage absoluteString];
            returnVar = profile.bgImagePath;
        }
        return returnVar;
    } else {
        return @"";
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
