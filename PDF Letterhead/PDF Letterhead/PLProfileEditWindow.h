//
//  PLProfileEditWindow.h
//  PDF Letterhead
//
//  Created by Richard Vollebregt on 17/12/15.
//  Copyright © 2015 Pim Snel. All rights reserved.
//

#import <Cocoa/Cocoa.h>
#import "Profile.h"

@interface PLProfileEditWindow : NSWindowController

@property (strong, nonatomic) NSManagedObjectContext *managedObjectContext;
@property (strong) IBOutlet NSArrayController *profileArrayController;
@property (strong, nonatomic) NSURL *pathToAppSupport;
@property (unsafe_unretained) Profile *loadedProfile;


-(Profile*)getCurrentProfile :(Profile *)row;
-(NSString*)saveImage:(NSImage*)image :(Profile*)profile :(NSString*)cover;

@end
