//
//  PLAppDelegate.h
//  PDF Letterhead
//
//  Created by Pim Snel on 17-09-12.
//  Copyright (c) 2012 Pim Snel. All rights reserved.
//

#import <Quartz/Quartz.h>
#import "PLDropZone.h"
#import "PLQuickStart1.h"
#import "ITSwitch.h"
#import "KBButton.h"


@interface PLAppDelegate : NSObject <NSApplicationDelegate, NSWindowDelegate>
{
    float _browserWidth;
	NSPrintingOrientation _orientation;
	NSString *_headerLeftJs;
	NSString *_headerRightJs;
	NSString *_footerLeftJs;
	NSString *_footerRightJs;

    BOOL _paginate;
    BOOL _setView;
    
    PDFView                 *_pdfView;
    PDFDocument				*_letterheadPDF;
}

@property (assign) IBOutlet NSWindow *pdfWindow;
@property (assign) IBOutlet PDFThumbnailView *pdfThumbView;
@property (assign) IBOutlet NSMenu *myMainMenu;

@property (assign) IBOutlet NSToolbarItem *printButton1;
@property (assign) IBOutlet NSToolbarItem *previewButton1;
@property (assign) IBOutlet NSToolbarItem *saveButton1;
@property (assign) IBOutlet NSToolbarItem *mailButton1;

@property (assign) IBOutlet NSMenuItem *printButton2;
@property (assign) IBOutlet NSMenuItem *saveButton2;
@property (assign) IBOutlet NSMenuItem *mailButton2;
@property (assign) IBOutlet NSMenuItem *previewButton2;

// Buttons below PDF Window
@property (assign) IBOutlet NSButton *saveButton3;
@property (assign) IBOutlet NSButton *printButton3;
@property (assign) IBOutlet NSButton *mailButton3;
@property (assign) IBOutlet NSButton *previewButton3;

@property (assign) IBOutlet NSButton *chooseLetterheadButton;
@property (assign) IBOutlet NSButton *saveLetterheadButton;

@property (assign) IBOutlet NSButton *manageProfilesButton;

@property (assign) IBOutlet PLDropZone *sourcedoc;
@property (assign) IBOutlet PLDropZone *backgrounddoc;
@property (assign) IBOutlet PLDropZone *coverbackgrounddoc;
@property (assign) IBOutlet NSTextField *backgrounddocText;
@property (assign) IBOutlet NSTextField *coverbackgrounddocText;

//@property (assign) IBOutlet NSSegmentedControl *coverswitch;
@property (assign) IBOutlet ITSwitch *coverswitch3;

@property (readonly, retain) NSURL *tmpDirectoryURL;

@property (assign) NSRect cvframe;
@property (assign) NSRect bgframe;
@property (assign) NSRect cvTextframe;
@property (assign) NSRect bgTextframe;

@property (assign) IBOutlet NSWindow *previewWindow;
@property (assign) IBOutlet PDFView *previewView;
@property (assign) IBOutlet NSView *pdfOuterView;

@property (retain) IBOutlet NSWindow *profileDrawer;

@property (assign) BOOL coverEnabled;
@property (assign) BOOL isSetCover;
@property (assign) BOOL isSetBackground;
@property (assign) BOOL isSetContent;
@property (assign) BOOL drawerIsOpen;

@property (readonly, retain) PLQuickStart1 *quickStartWindow;

@property (readonly, strong, nonatomic) NSPersistentStoreCoordinator *persistentStoreCoordinator;
@property (readonly, strong, nonatomic) NSManagedObjectModel *managedObjectModel;
@property (readonly, strong, nonatomic) NSManagedObjectContext *managedObjectContext;
@property (readonly, strong, nonatomic) NSArrayController *profileArrayController;
@property (nonatomic,strong) PLProfileEditWindow *profileEditWindow;


-(IBAction)saveAs:(id)sender;
-(IBAction)saveEmail: (id) sender;
-(IBAction)savePrint: (id) sender;
-(IBAction)showMainWindow: (id) sender;
-(IBAction)coverControlAction: (id) sender;
-(IBAction)openQuickStart:(id)sender;
-(IBAction)selectProfile:(id)sender;
-(IBAction)editSelectedProfile:(id)sender;

-(void)updatePreviewAndActionButtons;

@end
