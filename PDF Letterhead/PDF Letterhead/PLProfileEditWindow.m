//
//  PLProfileEditWindow.m
//  PDF Letterhead
//
//  Created by Richard Vollebregt on 17/12/15.
//  Copyright © 2015 Pim Snel. All rights reserved.
//

#import "PLProfileEditWindow.h"
#import "PLAppDelegate.h"

@interface PLProfileEditWindow ()

//Deze properties moeten worden omgeschreven op een getter/setter manier ?
@property (unsafe_unretained) IBOutlet NSImageView *bgImage;
@property (unsafe_unretained) IBOutlet NSImageView *coverImage;
@property (unsafe_unretained) IBOutlet NSTextField *title;

@property (unsafe_unretained) IBOutlet NSTextField *titleLabel;
@property (unsafe_unretained) IBOutlet NSTextField *dropCoverLabel;
@property (unsafe_unretained) IBOutlet NSTextField *dropFollowingLabel;

@end

@implementation PLProfileEditWindow


- (void)windowDidLoad {
    [super windowDidLoad];
    
    // Implement this method to handle any initialization after your window controller's window has been loaded from its nib file.
    // setup translations
    [_titleLabel setStringValue:NSLocalizedString(@"Title",@"Title")];
    [_dropCoverLabel setStringValue:NSLocalizedString(@"Drop cover background here",@"Drop cover background here")];
    [_dropFollowingLabel setStringValue:NSLocalizedString(@"Drop following background here",@"Drop following background here")];
    [[self window] setTitle:NSLocalizedString(@"Edit Letterhead","Edit Letterhead")];
    
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

- (IBAction)updateTitle:(id)sender {
    
    NSString *str = [sender stringValue];
    _loadedProfile.name = str;
    [self updateLastUpdatedTime];
    
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
                    if (_loadedProfile) {
                        [self saveImage:zNewImage :_loadedProfile :cover];
                    }
                }
            }
            else {
                NSLog(@"invalid filetype, no IMAGE");
            }
        }
    }];
    
    [self updateLastUpdatedTime];
}

- (void)delExistingDocument:(NSString*)cover {
    [self removeImage:_loadedProfile :cover];
    [self updateLastUpdatedTime];
}

- (void)updateLastUpdatedTime {
    PLAppDelegate *delegate = [[NSApplication sharedApplication] delegate ];
    _loadedProfile.lastUpdated = [delegate performSelector:@selector(returnDateNow)];
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
        [[self coverImage] setImage:nil];
    } else {
        profile.bgImagePath = nil;
        [[self bgImage] setImage:nil];
    }
    
    
}

-(NSString*)saveImage:(NSImage*)image :(Profile*)profile :(NSString*)cover {
    
    NSImageView *myView;
    NSRect vFrame;
    NSURL *pathToPdf = [self.pathToAppSupport URLByAppendingPathComponent:[NSString stringWithFormat:@"%@.pdf",[self createUniqueString]]];
    
    vFrame = NSZeroRect;
    vFrame.size = [image size];
    myView = [[NSImageView alloc] initWithFrame:vFrame];
    
    [myView setImage:image];
    
    NSData *data = [myView dataWithPDFInsideRect:vFrame];
    
    NSString *returnVar;
    
    // 3. Write image to disk, set path
    if ([data writeToURL:pathToPdf atomically:NO]) {
        if ([cover isEqual:@"cover"]) {
            profile.coverImagePath = [pathToPdf absoluteString];
            [[self coverImage] setImage:image];
            returnVar = profile.coverImagePath;
            
        } else {
            profile.bgImagePath = [pathToPdf absoluteString];
            [[self bgImage] setImage:image];
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
