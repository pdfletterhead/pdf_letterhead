//
//  PLAppDelegate.h
//  PDF Letterhead
//
//  Created by Pim Snel on 17-09-12.
//  Copyright (c) 2012 Pim Snel. All rights reserved.
//

#import <Quartz/Quartz.h>
#import "pmpDropZone.h"


@interface PLAppDelegate : NSObject <NSApplicationDelegate>
{
	PDFDocument				*_letterheadPDF;
}

@property (assign) IBOutlet NSWindow *pdfWindow;
@property (assign) IBOutlet pmpDropZone *sourcedoc;
@property (assign) IBOutlet pmpDropZone *backgrounddoc;
@property (assign) IBOutlet pmpDropZone *coverbackgrounddoc;
@property (assign) IBOutlet NSSegmentedControl *coverswitch;
@property (assign) BOOL coverEnabled;

@property (assign) IBOutlet PDFView *pdfView;
@property (assign) IBOutlet PDFThumbnailView *pdfThumbView;



@property (readonly, strong, nonatomic) NSPersistentStoreCoordinator *persistentStoreCoordinator;
@property (readonly, strong, nonatomic) NSManagedObjectModel *managedObjectModel;
@property (readonly, strong, nonatomic) NSManagedObjectContext *managedObjectContext;

-(IBAction)saveAs:(id)sender;
-(IBAction)showMainWindow: (id) sender;
-(void)setPreview;
-(void)setPreviewStoreBackgroundInPrefs:(BOOL)storeInPrefs;
- (IBAction)coverControlAction: (id) sender;



@end
