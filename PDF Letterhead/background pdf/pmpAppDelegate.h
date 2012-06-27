//
//  pmpAppDelegate.h
//  background pdf
//
//  Created by Pim Snel on 13-04-12.
//  Copyright (c) 2012 Lingewoud b.v. All rights reserved.
//

#import <Cocoa/Cocoa.h>
#import "pmpDropZone.h"
#import "pmpPreviewView.h"


@interface pmpAppDelegate : NSObject <NSApplicationDelegate>

@property (assign) IBOutlet NSWindow *window;
@property (assign) IBOutlet NSImageView *previewView;
@property (assign) IBOutlet pmpPreviewView *previewView2;
@property (assign) IBOutlet pmpDropZone *sourcedoc;
@property (assign) IBOutlet pmpDropZone *backgrounddoc;

@property (readonly, strong, nonatomic) NSPersistentStoreCoordinator *persistentStoreCoordinator;
@property (readonly, strong, nonatomic) NSManagedObjectModel *managedObjectModel;
@property (readonly, strong, nonatomic) NSManagedObjectContext *managedObjectContext;

-(void) saveAs:(NSString *)startdir :(NSString *)initname;
//-(IBAction)saveAction:(id)sender;
-(IBAction)saveNewPDF:(id)sender;
-(IBAction)previewPDF:(id)sender;
-(IBAction)printPDF:(id)sender;

-(void) setPreview;
-(void) createNewPDF:(NSString *)source :(NSString *)background :(NSString *)dest;

@end
