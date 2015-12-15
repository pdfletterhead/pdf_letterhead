//
//  PLProfileWindow.h
//  PDF Letterhead
//
//  Created by Richard Vollebregt on 10/12/15.
//  Copyright © 2015 Pim Snel. All rights reserved.
//

#import <Cocoa/Cocoa.h>

@interface PLProfileWindowController : NSWindowController

@property (strong) NSMutableArray *profiles;
@property (strong, nonatomic) NSManagedObjectContext *managedObjectContext;
@property (strong) IBOutlet NSArrayController *profileArrayController;
@property (strong, nonatomic) NSURL *pathToAppSupport;

@end
