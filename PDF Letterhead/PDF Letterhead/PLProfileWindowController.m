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

- (NSInteger)numberOfRowsInTableView:(NSTableView *)tableView {
    return [self.profiles count];
}

@end
