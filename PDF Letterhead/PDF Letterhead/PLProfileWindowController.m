//
//  PLProfileWindowController.m
//  PDF Letterhead
//
//  Created by Richard Vollebregt on 10/12/15.
//  Copyright © 2015 Pim Snel. All rights reserved.
//

#import "PLProfileWindowController.h"
#import "PLProfile.h"
#import "PLProfileImage.h"

@interface PLProfileWindowController ()
@property (unsafe_unretained) IBOutlet NSTextField *viewTitle;
@property (unsafe_unretained) IBOutlet NSTableView *profileTableView;
@property (unsafe_unretained) IBOutlet NSImageView *coverImage;
@property (unsafe_unretained) IBOutlet NSImageView *backgroundImage;
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
        // Initialization code here.
    }
    
    return self;
}

- (void)windowDidLoad
{
    [super windowDidLoad];
    // Implement this method to handle any initialization after your window controller's window has been loaded from its nib file.

    // Setup sample data
    PLProfileImage *profile1 = [[PLProfileImage alloc] initWithTitle:@"Profiel numero 1" coverImage:[NSImage imageNamed:@"Metallic_shield_bug444.jpg"] backgroundImage:[NSImage imageNamed:@"download.jpeg"]];
    PLProfileImage *profile2 = [[PLProfileImage alloc] initWithTitle:@"Profiel numero 2" coverImage:[NSImage imageNamed:@"download.jpeg"] backgroundImage:[NSImage imageNamed:@"Metallic_shield_bug444.jpg"]];
    _profiles = [NSMutableArray arrayWithObjects:profile1, profile2, nil];
    
    //self.ProfileWindowController.profiles = profiles;
    
}

- (NSView *)tableView:(NSTableView *)tableView viewForTableColumn:(NSTableColumn *)tableColumn row:(NSInteger)row {
    
    // Get a new ViewCell
    NSTableCellView *cellView = [tableView makeViewWithIdentifier:tableColumn.identifier owner:self];
    
    // Since this is a single-column table view, this would not be necessary.
    // But it's a good practice to do it in order by remember it when a table is multicolumn.
    if( [tableColumn.identifier isEqualToString:@"MainColumn"] )
    {
        PLProfileImage *profile = [_profiles objectAtIndex:row];
        cellView.imageView.image = profile.backgroundImage;
        cellView.textField.stringValue = profile.data.title;
        return cellView;
    }
    
    return cellView;
}

-(PLProfileImage*)selectedProfile {
    NSInteger selectedRow = [self.profileTableView selectedRow];
    if ( selectedRow >= 0 && self.profiles.count > selectedRow ) {
        PLProfileImage *selectedProfile = [self.profiles objectAtIndex:selectedRow];
        return selectedProfile;
    }
    return nil;
}

-(void)setDetailInfo:(PLProfileImage*)doc {
    NSString *title = @"";
    NSImage  *backgroundImage = nil;
    NSImage  *coverImage = nil;
    
    if (doc != nil ) {
        title = doc.data.title;
        backgroundImage = doc.backgroundImage;
        coverImage = doc.coverImage;
    }
    [self.coverImage setImage:coverImage];
    [self.backgroundImage setImage:backgroundImage];
    [self.viewTitle setStringValue:title];
}

-(void)tableViewSelectionDidChange:(NSNotification *)aNotification {
    PLProfileImage *selectedProfile = [self selectedProfile];
    [self setDetailInfo:selectedProfile];
    
    // Enable/Disable buttons based on selection
    BOOL buttonsEnabled = (selectedProfile!=nil);
    [self.viewTitle setEnabled:buttonsEnabled];
    [self.openCover setEnabled:buttonsEnabled];
    [self.delCover setEnabled:buttonsEnabled];
    [self.openBackground setEnabled:buttonsEnabled];
    [self.delBackground setEnabled:buttonsEnabled];
    
}

- (NSInteger)numberOfRowsInTableView:(NSTableView *)tableView {
    return [self.profiles count];
}

- (IBAction)updateTitle:(id)sender {
    PLProfileImage *selectedProfile = [self selectedProfile];
    if (selectedProfile) {
        selectedProfile.data.title = [self.viewTitle stringValue];
        NSIndexSet *indexSet = [NSIndexSet indexSetWithIndex:[self.profiles indexOfObject:selectedProfile]];
        NSIndexSet *columnSet = [NSIndexSet indexSetWithIndex:0];
        [self.profileTableView reloadDataForRowIndexes:indexSet columnIndexes:columnSet];
    }
}

- (IBAction)addProfile:(id)sender {
    PLProfileImage *newProfile = [[PLProfileImage alloc] initWithTitle:@"New Profile" coverImage:nil backgroundImage:nil];
    
    [self.profiles addObject:newProfile];
    NSInteger newRowIndex = self.profiles.count - 1;
    
    [self.profileTableView insertRowsAtIndexes:[NSIndexSet indexSetWithIndex:newRowIndex] withAnimation:NSTableViewAnimationEffectFade];
    [self.profileTableView selectRowIndexes:[NSIndexSet indexSetWithIndex:newRowIndex] byExtendingSelection:NO];
    [self.profileTableView scrollRowToVisible:newRowIndex];
}

- (IBAction)removeProfile:(id)sender {
    PLProfileImage *selectedProfile = [self selectedProfile];
    if (selectedProfile) {
        [self.profiles removeObject:selectedProfile];
        [self.profileTableView removeRowsAtIndexes:[NSIndexSet indexSetWithIndex:self.profileTableView.selectedRow] withAnimation:NSTableViewAnimationEffectFade];
        [self setDetailInfo:nil];
    }
}

- (IBAction)doAddCover:(id)sender {
    [self openExistingDocument :self.coverImage :@"cover"];
}

- (IBAction)doDelCover:(id)sender {
    [self delExistingDocument:self.coverImage :@"cover"];
}

- (IBAction)doAddBg:(id)sender {
    [self openExistingDocument:self.backgroundImage :@"background"];
}

- (IBAction)doDelBg:(id)sender {
    [self delExistingDocument:self.backgroundImage :@"background"];
}

- (void)openExistingDocument:(NSImageView*)sender :(NSString*)cover {
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
                [sender setImage:zNewImage];
                
                PLProfileImage *selectedProfile = [self selectedProfile];
                if (selectedProfile) {
                    
                    if ([cover isEqual: @"cover"]) {
                        NSLog(@"Name == %@", cover);
                        selectedProfile.coverImage = zNewImage;
                    } else {
                        NSLog(@"Name == %@", cover);
                        selectedProfile.backgroundImage = zNewImage;
                        //update table view for small icon
                        NSIndexSet *indexSet = [NSIndexSet indexSetWithIndex:[self.profiles indexOfObject:selectedProfile]];
                        NSIndexSet *columnSet = [NSIndexSet indexSetWithIndex:0];
                        [self.profileTableView reloadDataForRowIndexes:indexSet columnIndexes:columnSet];
                    }
                }
            }
            else {
                NSLog(@"invalid filetype, no IMAGE");
            }
        }
    }];

}

- (void)delExistingDocument:(NSImageView*)sender :(NSString*)cover {
    [sender setImage:nil];
    
    PLProfileImage *selectedProfile = [self selectedProfile];
    if (selectedProfile) {
        
        if ([cover isEqual: @"cover"]) {
            NSLog(@"Name == %@", cover);
            selectedProfile.coverImage = nil;
        } else {
            NSLog(@"Name == %@", cover);
            selectedProfile.backgroundImage = nil;
            //update table view for small icon
            NSIndexSet *indexSet = [NSIndexSet indexSetWithIndex:[self.profiles indexOfObject:selectedProfile]];
            NSIndexSet *columnSet = [NSIndexSet indexSetWithIndex:0];
            [self.profileTableView reloadDataForRowIndexes:indexSet columnIndexes:columnSet];
        }
    }

}



@end
