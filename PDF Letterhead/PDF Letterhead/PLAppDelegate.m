//
//  PLAppDelegate.m
//  PDF Letterhead
//
//  Created by Pim Snel on 17-09-12.
//  Copyright (c) 2012 Pim Snel. All rights reserved.
//
#import "PLAppDelegate.h"
#import "PLPDFPage.h"
#import "Profile.h"
#import "PLTableRowView.h"
#include "PLProfileEditWindow.h"


@interface PLAppDelegate()

@property (strong) IBOutlet NSTableView *drawerTableView;
@property (unsafe_unretained) IBOutlet NSArrayController *pArrayController;
@property (unsafe_unretained) IBOutlet NSView *drawerContentView;
@property (weak) IBOutlet NSView *noItemsView;
@property (weak) IBOutlet NSButton *manageLetterheadsButton;
@property (weak) IBOutlet NSBox *manageLetterheadsLine;
@property (weak) IBOutlet KBButton *saveNewLetterheadButton;
@property (weak) IBOutlet NSBox *saveNewLetterheadLine;
@property (weak) IBOutlet NSButton *upgradeToProButton;
@property (weak) IBOutlet NSSegmentedControl *segmentedControl;
@property (weak) IBOutlet PDFView *PDFView;
@property (weak) IBOutlet NSTextField *dropDescription;

@end

@implementation PLAppDelegate

@synthesize persistentStoreCoordinator = _persistentStoreCoordinator;
@synthesize managedObjectModel = _managedObjectModel;
@synthesize managedObjectContext = _managedObjectContext;
@synthesize quickStartWindow = _quickStartWindow;
@synthesize profileEditWindow = _profileEditWindow;
@synthesize profileDrawer = _profileDrawer;
@synthesize retrievePrice = _retrievePrice;


@synthesize chooseLetterheadButton, saveLetterheadButton, saveButton3, previewButton3, printButton3, mailButton3;


- (void)awakeFromNib {
    [[saveLetterheadButton cell] setKBButtonType:BButtonTypeLight];
    [[saveButton3 cell] setKBButtonType:BButtonTypeDark];
    [[previewButton3 cell] setKBButtonType:BButtonTypeDark];
    [[printButton3 cell] setKBButtonType:BButtonTypeDark];
    [[mailButton3 cell] setKBButtonType:BButtonTypeDark];
}

- (void)applicationDidFinishLaunching:(NSNotification *)aNotification
{
    
#ifdef LITE
    [self disableProFeatures];
    
    //try to retrieve app price
    _retrievePrice = [[PLRetrievePrice alloc] initWithAppId:@422876559];
    //_retrievePrice = [[PLRetrievePrice alloc] initWithAppId:@1075794517];

    [self moveInterfaceElements];
#endif
    
    _isSetContent = NO;
    
    [[self PDFView] setBackgroundColor:[NSColor colorWithDeviceRed: 51.0/255.0 green: 51.0/255.0 blue: 51.0/255.0 alpha: 1.0]];

    //Temp folder creation
    NSError *tmpFileCreateError;
    _tmpDirectoryURL = [NSURL fileURLWithPath:[NSTemporaryDirectory() stringByAppendingPathComponent:[[NSProcessInfo processInfo] globallyUniqueString]] isDirectory:YES];
    [[NSFileManager defaultManager] createDirectoryAtURL:_tmpDirectoryURL withIntermediateDirectories:YES attributes:nil error:&tmpFileCreateError];
    
    //style main pdfview
    [_previewView setBackgroundColor:[NSColor colorWithDeviceRed: 51.0/255.0 green: 51.0/255.0 blue: 51.0/255.0 alpha: 1.0]];
    
    [_myMainMenu setAutoenablesItems:NO];
    [[[self manageLetterheadsButton] image] setSize:NSMakeSize(15.0,12.0)];
    [[self manageLetterheadsButton] setNeedsDisplay:YES];
    
    [_pdfThumbView setAllowsDragging:NO];
    [_pdfThumbView setAllowsMultipleSelection:NO];
    
    _cvframe = [_coverbackgrounddoc frame];
    _bgframe = [_backgrounddoc frame];
    _cvTextframe = [_coverbackgrounddocText frame];
    _bgTextframe = [_backgrounddocText frame];
    
#ifdef PRO

    [self setupProfileDrawer];
    _profileEditWindow = [[PLProfileEditWindow alloc] init ];
    //Managed Object Context for ProfileViewController
    self.profileEditWindow.managedObjectContext = [self managedObjectContext];
    self.profileEditWindow.pathToAppSupport = [self applicationFilesDirectory];
    [self selectProfile:nil];
    [self checkProfiles];
    
    if ([[NSUserDefaults standardUserDefaults] boolForKey:@"drawerState"] == YES) {
        [self openProfileDrawer:nil];
    }
    
#endif
    
    [self coverControlAction:self];
    [self setupColorSwitch];
    
#ifdef LITE
    _quickStartWindow = [[PLQuickStart1 alloc] initWithWindowNibName:@"PLQuickStart1"];
    [self doOpenQuickStart];
    
#endif
    
}


- (BOOL)application:(NSApplication *)theApplication openFile:(NSString *)filename
{
    if ([[[filename pathExtension] lowercaseString] isEqual:@"pdf"]){
        [_sourcedoc setPdfFilepath:filename];
        return YES;
    }
    else {
        return NO;
    }
}

- (IBAction)doOpenFileForCover:(id)sender {
    [self doOpenFileForImageView:_coverbackgrounddoc];
}

- (IBAction)doOpenFileForBG:(id)sender {
    [self doOpenFileForImageView:_backgrounddoc];
}

- (IBAction)doOpenFileForContentDoc:(id)sender {
    [self doOpenFileForImageView:_sourcedoc];
}

- (IBAction)doDelForCover:(id)sender {
    [_coverbackgrounddoc setImage:nil];
}

- (IBAction)doDelForBG:(id)sender {
    [_backgrounddoc setImage:nil];
}

- (IBAction)doDelForContentDoc:(id)sender {
    [_sourcedoc setImage:nil];
}

- (void)doOpenFileForImageView:(PLDropZone*)theView {
    
    //BOOL cancelOperation;
    
    NSOpenPanel *openPanel = [[NSOpenPanel alloc] init];
    [openPanel setCanChooseFiles:YES];
    [openPanel setCanChooseDirectories:NO];
    [openPanel setAllowsMultipleSelection:NO];
    
    if ([openPanel runModal] == NSOKButton)
    {
        NSString *tvarFilename = [[openPanel URL] path];
        NSLog(@"file: %@", tvarFilename);
        NSString *ext = [[tvarFilename pathExtension] lowercaseString ];

        if([[theView identifier] isEqualToString:@"sourceDropArea"])
        {
            if ([ext isEqual:@"pdf"]){
                
                [theView setPdfFilepath:tvarFilename];
            }
            else {
                NSLog(@"invalid filetype, no PDF");
            }
        }
        else
        {
            NSSet *validImageExtensions = [NSSet setWithArray:[NSImage imageFileTypes]];
            if ([validImageExtensions containsObject:ext])
            {
                [theView setPdfFilepath:tvarFilename];
            }
            else {
                NSLog(@"invalid filetype, no IMAGE");
            }
        }
    }
    else
    {
        NSLog(@"what to do when no file was given?");
        //cancelOperation = YES;
    }
}

- (IBAction)openPreview:(id)sender {
    
    [_previewWindow makeKeyAndOrderFront:sender];
    
}

- (IBAction)openSupportPage:(id)sender {
    [[NSWorkspace sharedWorkspace] openURL:[NSURL URLWithString:@"http://www.pdfletterhead.net"]];
}


- (IBAction)openQuickStart:(id)sender {
    [self doOpenQuickStart];
}

-(void)doOpenQuickStart{
    [[_quickStartWindow window] setLevel:NSPopUpMenuWindowLevel];
    [_quickStartWindow showWindow:self];
    
    
}

- (void)setupColorSwitch {
    unsigned colorCode = 0;
    unsigned char redByte, greenByte, blueByte;
    
    NSScanner* scanner = [NSScanner scannerWithString:@"318bd2"];
    (void) [scanner scanHexInt:&colorCode]; // ignore error
    
    redByte = (unsigned char)(colorCode >> 16);
    greenByte = (unsigned char)(colorCode >> 8);
    blueByte = (unsigned char)(colorCode); // masks off high bits
    
    NSColor* blueColor = [NSColor colorWithCalibratedRed:(CGFloat)redByte / 0xff
                                                    green:(CGFloat)greenByte / 0xff
                                                     blue:(CGFloat)blueByte / 0xff
                                                    alpha:1.0];
    [_coverswitch3 setTintColor: blueColor];
    [_coverswitch3 setFocusRingType:NSFocusRingTypeNone];
    
    [self coverControlAction:_coverswitch3];
}




- (void)setupProfileDrawer {
    
    _drawerIsOpen = NO;
    
    CGRect wRect = _pdfWindow.frame;
    CGRect rect0 = CGRectMake(wRect.origin.x, (wRect.origin.y+15), 200.0, (wRect.size.height-50.0));
    
    _profileDrawer = [[NSWindow alloc] initWithContentRect:rect0
                                                 styleMask:NSUnifiedTitleAndToolbarWindowMask
                                                   backing:NSBackingStoreBuffered
                                                     defer:NO];
    unsigned colorCode = 0;
    unsigned char redByte, greenByte, blueByte;
    
    NSScanner* scanner = [NSScanner scannerWithString:@"FBFDFC"];
    (void) [scanner scanHexInt:&colorCode]; // ignore error
    
    redByte = (unsigned char)(colorCode >> 16);
    greenByte = (unsigned char)(colorCode >> 8);
    blueByte = (unsigned char)(colorCode); // masks off high bits
    
    NSColor* whiteColor = [NSColor colorWithCalibratedRed:(CGFloat)redByte / 0xff
                                                    green:(CGFloat)greenByte / 0xff
                                                     blue:(CGFloat)blueByte / 0xff
                                                    alpha:1.0];
    
    [_profileDrawer setBackgroundColor:[NSColor clearColor]];
    [_profileDrawer setContentView: _drawerContentView];
    [_profileDrawer setMovableByWindowBackground: NO];
    
    [_drawerContentView setWantsLayer:YES];
    [[_drawerContentView layer] setCornerRadius:4.0];
    [[_drawerContentView layer] setBackgroundColor:whiteColor.CGColor];
    
    _profileDrawer.hasShadow = YES;
    
    [_pdfWindow addChildWindow:_profileDrawer ordered:NSWindowBelow];
}

-(void)windowDidResize:(NSNotification *)notification{
    
    CGRect wRect = _pdfWindow.frame;
    
    CGFloat pos_x;
    if(_drawerIsOpen){
        pos_x = _pdfWindow.frame.origin.x-180;
    }
    else{
        pos_x = _pdfWindow.frame.origin.x;
    }

    CGRect rect1 = CGRectMake(pos_x, (wRect.origin.y+15), _profileDrawer.frame.size.width, (wRect.size.height-50.0));
    
    [_profileDrawer setFrame:rect1 display:YES];
    
    [_profileDrawer viewsNeedDisplay];
}

- (IBAction)openProfileDrawer:(id)sender {
    
    NSImage *openIcon = [NSImage imageNamed:@"drawerouticon"];
    [openIcon setSize:NSMakeSize( 15.0, 12.0 )];
    NSImage *closeIcon = [NSImage imageNamed:@"drawerinicon"];
    [closeIcon setSize:NSMakeSize( 15.0, 12.0 )];

    
    if (_drawerIsOpen && sender != nil) {
        [[self manageLetterheadsButton] setImage:closeIcon];
        _drawerIsOpen = NO;
        [[NSUserDefaults standardUserDefaults] setBool:NO forKey:@"drawerState"];
        CGRect wRect = _pdfWindow.frame;
        CGRect rect1 = CGRectMake(wRect.origin.x, (wRect.origin.y+15), 200.0, (wRect.size.height-50.0));
        
        [_profileDrawer setFrame:rect1 display:YES animate:YES];
        
    } else {
        [[self manageLetterheadsButton] setImage:openIcon];
        //check if frame is to close to screen corner
        if (_pdfWindow.frame.origin.x < 180.0){
            
            if( _pdfWindow.frame.origin.x + _pdfWindow.frame.size.width + 180 > [[NSScreen mainScreen] frame].size.width){

                CGFloat diff = _pdfWindow.frame.origin.x + _pdfWindow.frame.size.width - [[NSScreen mainScreen] frame].size.width;
                
                CGRect wRect1 = _pdfWindow.frame;
                CGRect wRect = CGRectMake(181.0, wRect1.origin.y,([[NSScreen mainScreen] frame].size.width - 181 + diff), wRect1.size.height);
                CGRect rect1 = CGRectMake(wRect.origin.x, (wRect.origin.y+15), 200.0, (wRect.size.height-50.0));
                
                [_profileDrawer setFrame:rect1 display:YES animate:NO];
                [_pdfWindow setFrame:wRect display:YES animate:YES];
                
                [NSTimer scheduledTimerWithTimeInterval:0.0f
                                                 target:self
                                               selector: @selector(openProfileDrawer:)
                                               userInfo:nil
                                                repeats:NO];
            }
            else {
                CGRect wRect1 = _pdfWindow.frame;
                CGRect wRect = CGRectMake(181.0, wRect1.origin.y, wRect1.size.width, wRect1.size.height);
                CGRect rect1 = CGRectMake(wRect.origin.x, (wRect.origin.y+15), 200.0, (wRect.size.height-50.0));
                [_profileDrawer setFrame:rect1 display:YES animate:NO];
                [_pdfWindow setFrame:wRect display:YES animate:YES];
                
                [NSTimer scheduledTimerWithTimeInterval:0.0f
                                                 target:self
                                               selector: @selector(openProfileDrawer:)
                                               userInfo:nil
                                                repeats:NO];
            }
            

        }
        else{
            _drawerIsOpen = YES;
            [[NSUserDefaults standardUserDefaults] setBool:YES forKey:@"drawerState"];
            CGRect wRect = _pdfWindow.frame;
            CGRect rect1 = CGRectMake(wRect.origin.x-180.0, (wRect.origin.y+15), 200.0, (wRect.size.height-50.0));
            
            [_profileDrawer setFrame:rect1 display:YES animate:YES];
        }
    }
    
}

-(Profile*)returnLoadedProfile {
    return _profileEditWindow.loadedProfile;
}

-(void)doOpenEditor :(Profile *)profile {
    _profileEditWindow = [[PLProfileEditWindow alloc] initWithWindowNibName:@"PLProfileEditWindow"];
    _profileEditWindow.loadedProfile = profile;
    
    //Managed Object Context for ProfileViewController
    self.profileEditWindow.managedObjectContext = [self managedObjectContext];
    self.profileEditWindow.pathToAppSupport = [self applicationFilesDirectory];
    
    [_profileEditWindow showWindow:self];
}

- (NSTableRowView *)tableView:(NSTableView *)tableView rowViewForRow:(NSInteger)row
{

    PLTableRowView *rowView = [[PLTableRowView alloc]init];
    return rowView;
}

-(void)renderPDF {
    
    //Render PDF
    dispatch_async( dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        
        PDFDocument *document = [self renderDocument];
            
        //Set PDFView
        dispatch_async( dispatch_get_main_queue(), ^{
        
            [[self PDFView] setDocument:document];
            [[self previewView] setDocument:document];
            _letterheadPDF = document;
            if(_isSetContent){
                [[self PDFView] setHidden:NO];
                [mailButton3 setHidden:NO];
                [saveButton3 setHidden:NO];
                [printButton3 setHidden:NO];
                [previewButton3 setHidden:NO];

            }
            else
            {
                [[self PDFView] setHidden:YES];
                [mailButton3 setHidden:YES];
                [saveButton3 setHidden:YES];
                [printButton3 setHidden:YES];
                [previewButton3 setHidden:YES];

            }
            
        });
    });
}

-(PDFDocument*)renderDocument {
    
    NSImage			*bgimage;
    NSImage			*cvrimage;
    NSImage			*sourceimage;
    PLPDFPage       *page;
    PDFDocument     *letterheadPDF;


    // Start with an empty PDFDocument.
    letterheadPDF = [[PDFDocument alloc] init];
    
    if(_coverEnabled){
        
        if(_isSetCover){
            cvrimage = [_coverbackgrounddoc image];
        }
        else{
            cvrimage = NULL;
            NSBundle* myBundle = [NSBundle mainBundle];
            NSString* myImagePath = [myBundle pathForResource:@"white" ofType:@"pdf"];
            
            cvrimage = [[NSImage alloc] initWithContentsOfFile: myImagePath];
        }
    }
    
    if(_isSetBackground){
        bgimage = [_backgrounddoc image];
    }
    else if ([_backgrounddoc image]){
        bgimage = [_backgrounddoc image];
    }
    
    else{
        bgimage = NULL;
        NSBundle* myBundle = [NSBundle mainBundle];
        NSString* myImagePath = [myBundle pathForResource:@"white" ofType:@"pdf"];
        
        bgimage = [[NSImage alloc] initWithContentsOfFile: myImagePath];
    }
    
    // Get image.
    if(_isSetContent || [_sourcedoc image]){
        
        sourceimage = [_sourcedoc image];
        NSString *filePath;
        
        if(![_sourcedoc getFilepath])
        {
            filePath = [NSString stringWithFormat:@"%@/no_name.pdf",[[self applicationFilesDirectory] path]];
            BOOL success;
            //NSImage *myImage;
            NSImageView *myView;
            NSRect vFrame;
            NSData *pdfData;
            //        NSError *error = nil;
            
            vFrame = NSZeroRect;
            vFrame.size = [sourceimage size];
            myView = [[NSImageView alloc] initWithFrame:vFrame];
            
            [myView setImage:sourceimage];
            
            pdfData = [myView dataWithPDFInsideRect:vFrame];
            
            success = [pdfData writeToFile:filePath options:0 error:NULL];
        }
        else{
            filePath = [_sourcedoc getFilepath];
        }
        
        PDFDocument * sourcePDF = [[PDFDocument alloc] initWithURL:[NSURL fileURLWithPath:filePath]];
        NSUInteger pagescount = [sourcePDF pageCount];
        
        for (int y = 0; y < pagescount; y++) {
            
            PDFPage *currentPage = [sourcePDF pageAtIndex:y];
            NSImage *image = [[NSImage alloc] initWithData:[currentPage dataRepresentation]];
            
            if(_coverEnabled && y==0){
                // Create our custom PDFPage subclass (pass it an image and the month it is to represent).f
                page = [[PLPDFPage alloc] initWithBGImage: cvrimage sourceDoc: image label:[currentPage label]];
            }
            else{
                // Create our custom PDFPage subclass (pass it an image and the month it is to represent).
                page = [[PLPDFPage alloc] initWithBGImage: bgimage sourceDoc: image label:[currentPage label]];

            }
            
            // Insert the new page in our PDF document.
            [letterheadPDF insertPage: page atIndex: y];
        }
    }
    else{
        sourceimage = NULL;
        
        if(_coverEnabled){
            
            // Create our custom PDFPage subclass (pass it an image and the month it is to represent).
            page = [[PLPDFPage alloc] initWithBGImage: cvrimage sourceDoc: sourceimage label:nil];
        }
        else{
            // Create our custom PDFPage subclass (pass it an image and the month it is to represent).
            page = [[PLPDFPage alloc] initWithBGImage: bgimage sourceDoc: sourceimage label:nil];
        }
        
        [letterheadPDF insertPage: page atIndex: 0];
    }
    
    return letterheadPDF;

}

-(BOOL)allowSetPreview{
    
    BOOL allow = NO;
    if(!_isSetContent)
    {
        allow = NO;
    }
    else{
        //LAZY CHECKING, ONLY CONTENT DOCUMENT IS NEEDED
        allow = YES;
    }
    
    if(!_coverEnabled && _isSetBackground)
    {
        allow = YES;
    }
    
    if(_coverEnabled && _isSetCover && _isSetBackground)
    {
        allow = YES;
    }
    
    NSLog(@"allow: %hhd", allow);
    return allow;
}

- (IBAction)showMainWindow: (id) sender{
    [_pdfWindow makeKeyAndOrderFront:self];
}


- (IBAction)coverControlAction: (id) sender{
    
    if([_coverswitch3 checked]==NO){
        
        _coverEnabled = NO;
        [_coverbackgrounddoc unregisterDraggedTypes];
        [[_coverbackgrounddoc animator] setAlphaValue:0.0];
        [_coverbackgrounddoc setEditable:NO];
        
        CGRect newbgframe = CGRectMake(_cvframe.origin.x+45,
                                       _cvframe.origin.y,
                                       _bgframe.size.width,
                                       (_bgframe.size.height));
        
        [[_backgrounddoc animator ]setFrame:newbgframe];
        
        [[_coverbackgrounddocText animator] setAlphaValue:0.0];
        
        
        [[_backgrounddocText animator] setStringValue:NSLocalizedString(@"Background", @"Cover disabled Following text")];
        
        CGRect newbgTextframe = CGRectMake(_cvTextframe.origin.x+45,
                                           _cvTextframe.origin.y,
                                           _bgTextframe.size.width,
                                           (_bgTextframe.size.height));

        [[_backgrounddocText animator ]setFrame:newbgTextframe];
        _backgrounddoc.identifier = @"coverDropArea";
        [self dropDescription].stringValue = NSLocalizedString(@"Drop background image here", @"Cover control action Drop Description unchecked");
        [_backgrounddoc setNeedsDisplay:YES];
        
    }
    else{
        
        _coverEnabled = YES;
        [[_backgrounddocText animator] setStringValue:NSLocalizedString(@"Following", nil)];
        [[_backgrounddoc animator ]setFrame:_bgframe];
        
        [[_backgrounddocText animator ]setFrame:_bgTextframe];
        
        [_coverbackgrounddoc registerForDraggedTypes:[NSArray arrayWithObjects:
                                                      NSColorPboardType, NSFilenamesPboardType, nil]];
        
        [_coverbackgrounddoc dropAreaFadeOut];
        [[_coverbackgrounddocText animator] setAlphaValue:1.0];
        
        [_coverbackgrounddoc setEditable:YES];
        _backgrounddoc.identifier = @"bgDropArea";
        [self dropDescription].stringValue = NSLocalizedString(@"Drop background images here", @"Cover control action Drop Description checked");
        [_backgrounddoc setNeedsDisplay:YES];

    }
    
    [self renderPDF];
}


- (IBAction)saveAs: (id) sender {
    
    NSString * defaultName;
    if ([_sourcedoc getFilepath] == nil) {
        defaultName = @"Untitled.pdf";
    }
    else {
        defaultName =[[[[_sourcedoc getFilepath] lastPathComponent] stringByDeletingPathExtension] stringByAppendingString:@".pdf"];
    }
    
    NSSavePanel *savePanel = [NSSavePanel savePanel];
    [savePanel setNameFieldStringValue:defaultName];
    
	if ([savePanel runModal] == NSFileHandlingPanelOKButton)
        [_letterheadPDF writeToURL: [savePanel URL]];
    
    }

- (IBAction)saveEmail: (id) sender {
    

    NSString * newFileName;
    if ([_sourcedoc getFilepath] == nil) {
        newFileName = [[_tmpDirectoryURL path] stringByAppendingPathComponent: @"new.pdf" ];
    }
    else {

        NSString *tmpName =[NSString stringWithFormat:@"%@.pdf" ,[[[_sourcedoc getFilepath] lastPathComponent] stringByDeletingPathExtension]];
        newFileName = [ [_tmpDirectoryURL path] stringByAppendingPathComponent:tmpName];
    }

   
    NSLog(@"email: %@", newFileName);
    NSURL * tmpFileUrl = [NSURL fileURLWithPath:newFileName isDirectory:NO];
	[_letterheadPDF writeToURL:tmpFileUrl];
    NSString * subject = NSLocalizedString(@"My PDF", @"Subject for Email");
    NSString * body = NSLocalizedString(@"", @"Body for Email");
    
    NSString* textAttributedString = body;
    
    NSSharingService* mailShare = [NSSharingService sharingServiceNamed:NSSharingServiceNameComposeEmail];
    NSArray* shareItems = @[textAttributedString,tmpFileUrl];
    [mailShare setSubject:subject];
    [mailShare performWithItems:shareItems];
}


- (IBAction)savePrint: (id) sender{
    NSPrintInfo *info = [NSPrintInfo sharedPrintInfo];
    [_PDFView printWithInfo:info autoRotate:YES pageScaling:YES];
}

- (void)checkProfiles {
    
    NSError *error;
    [self.pArrayController fetchWithRequest:nil merge:NO error:&error];
    
    if ([[self.pArrayController arrangedObjects] count] == 0) {
        [[self noItemsView] setHidden:NO];
    } else {
        [[self noItemsView] setHidden:YES];
    }
}

- (NSString*)returnDateNow {
    //string representation of current date
    NSDate *today = [NSDate date];
    NSDateFormatter *dateFormat = [[NSDateFormatter alloc] init];
    [dateFormat setDateFormat:@"yyyyMMddHHmmss"];
    NSString *dateString = [dateFormat stringFromDate:today];
    return dateString;
}

- (IBAction)saveNewProfile:(id)sender {

    [self openProfileDrawer:nil];
    
    NSString *name = [self inputAlert:NSLocalizedString(@"Enter a name for the new letterhead", @"Create new Letterhead Message") defaultValue:NSLocalizedString(@"Untitled Letterhead", @"Default name new Letterhead")];
    
    if (name) {
        NSString *dateString = [self returnDateNow];
        Profile* newProfile = [NSEntityDescription insertNewObjectForEntityForName:@"Profile" inManagedObjectContext:self.managedObjectContext];
        newProfile.name = name;
        newProfile.bgImagePath = [[self profileEditWindow] saveImage:[[self backgrounddoc] image] :newProfile :@"background"];
        newProfile.coverImagePath = [[self profileEditWindow] saveImage:[[self coverbackgrounddoc] image] :newProfile :@"cover"];
        newProfile.lastUpdated = dateString;
        
        [self checkProfiles];
        [self selectRow:newProfile];
    }

}

- (NSString *)inputAlert: (NSString *)prompt defaultValue: (NSString *)defaultValue {
    NSAlert *alert = [NSAlert alertWithMessageText: prompt
                                     defaultButton:NSLocalizedString(@"OK", @"OK button")
                                   alternateButton:NSLocalizedString(@"Cancel", @"Cancel button")
                                       otherButton:nil
                         informativeTextWithFormat:@""];
    
    NSTextField *input = [[NSTextField alloc] initWithFrame:NSMakeRect(0, 0, 200, 24)];
    [input setStringValue:defaultValue];
    [alert setAccessoryView:input];
    NSInteger button = [alert runModal];
    if (button == NSAlertDefaultReturn) {
        [input validateEditing];
        return [input stringValue];
    } else if (button == NSAlertAlternateReturn) {
        return nil;
    } else {
        return nil;
    }
}

- (void) selectRow:(Profile*)profile {
    

    NSArray *selectedItems = [NSArray arrayWithObject:profile];
    
    [[self pArrayController] setSelectedObjects:selectedItems];
}

- (void) checkSegment {
    
    if ([_drawerTableView selectedRow] == -1) {
        [[self segmentedControl] setEnabled:NO forSegment:1];
    } else {
        [[self segmentedControl] setEnabled:YES forSegment:1];
    }
}

- (IBAction)selectProfile:(id)sender {
    
    [self checkSegment];
    
    //save moc intermittently
    [self saveManagedObjectContext];
    
    Profile *profile = [self getCurrentProfile];

    if (sender == nil && profile == nil) {
        
        //set previous profile
        NSURL *url = [[NSUserDefaults standardUserDefaults] URLForKey:@"recentProfile"];
        if (url) {
            NSManagedObjectID *objID = [[[self managedObjectContext] persistentStoreCoordinator] managedObjectIDForURIRepresentation:url];
            profile = [[self managedObjectContext] objectWithID:objID];
            [self checkProfiles];
            [self selectRow:profile];
        }
    } else {
        NSManagedObjectID *objID = profile.objectID;
        NSURL *recentProfile = [objID URIRepresentation];
        
        if (recentProfile != NULL) {
            [[NSUserDefaults standardUserDefaults] setURL:recentProfile forKey:@"recentProfile"];
            [[NSUserDefaults standardUserDefaults] synchronize];
        }
    }

    if (profile) {
        [self.backgrounddoc setPdfFilepath:profile.bgImagePath];
        [self.coverbackgrounddoc setPdfFilepath:profile.coverImagePath];
    }
    
    [self renderPDF];

}

- (NSArray *)updatedSortDescriptors {
    return [NSArray arrayWithObject:
            [NSSortDescriptor sortDescriptorWithKey:@"lastUpdated"
                                          ascending:NO]];
}

-(Profile*)getCurrentProfile {
    if ([[self.pArrayController selectedObjects] count] > 0) {
        return [[self.pArrayController selectedObjects] objectAtIndex:0];
    } else {
        return nil;
    }
}

//Called by segmented control
-(IBAction)addOrDeleteProfile:(id)sender {

    NSInteger selectedSegment = [sender selectedSegment];
    
    if(selectedSegment==0){
        [self saveNewProfile:sender];
    }
    else {
        
        if ([_drawerTableView selectedRow] != -1) {
            NSAlert *alert = [[NSAlert alloc] init];
            [alert addButtonWithTitle:NSLocalizedString(@"OK", @"OK button")];
            [alert addButtonWithTitle:NSLocalizedString(@"Cancel", @"Cancel button")];
            [alert setMessageText:NSLocalizedString(@"Are you sure you want to delete this letterhead?", @"Delete Letterhead message")];
            [alert setInformativeText:NSLocalizedString(@"Deleted letterheads cannot be restored.", @"Delete Letterhead warning")];
            [alert setAlertStyle:NSWarningAlertStyle];
            
            if ([alert runModal] == NSAlertFirstButtonReturn) {
                NSUInteger index = [self.pArrayController selectionIndex];
                [self.pArrayController removeObjectAtArrangedObjectIndex:index];
            }
        }
    }

    [self checkProfiles];
}

- (BOOL)validateMenuItem:(NSMenuItem *)item
{
    if ([item action] == @selector(saveAs:) && (![self allowSetPreview])) {
        return NO;
    }
    if ([item action] == @selector(saveEmail:) && (![self allowSetPreview])) {
        return NO;
    }
    if ([item action] == @selector(savePrint:) && (![self allowSetPreview])) {
        return NO;
    }
    if ([item action] == @selector(openPreview:) && (![self allowSetPreview])) {
        return NO;
    }
    
    return YES;
}

- (void) disableProFeatures {
    NSLog(@"Lite Version");
    [[self manageLetterheadsButton] setHidden:YES];
    [[self manageLetterheadsLine] setHidden:YES];
    [[self saveNewLetterheadButton] setHidden:YES];
    [[self saveNewLetterheadLine] setHidden:YES];
    [[self upgradeToProButton] setHidden:NO];
}

- (void) moveInterfaceElements {
    
    [_coverbackgrounddoc setFrameOrigin:NSMakePoint(_coverbackgrounddoc.frame.origin.x, _coverbackgrounddoc.frame.origin.y - 20)];
    [_coverbackgrounddocText setFrameOrigin:NSMakePoint(_coverbackgrounddocText.frame.origin.x, _coverbackgrounddocText.frame.origin.y - 26)];

    [_backgrounddoc setFrameOrigin:NSMakePoint(_backgrounddoc.frame.origin.x, _backgrounddoc.frame.origin.y - 20)];
    [_backgrounddocText setFrameOrigin:NSMakePoint(_backgrounddocText.frame.origin.x, _backgrounddocText.frame.origin.y - 26)];
    
    [[self dropDescription ] setFrameOrigin:NSMakePoint([self dropDescription ].frame.origin.x, [self dropDescription ].frame.origin.y - 30)];

}

- (IBAction)editSelectedProfile:(id)sender {
    
    NSInteger row = nil;
    Profile *profile = nil;
    
    if ([[sender identifier] isEqual: @"tableview"]) {
        row = [_drawerTableView clickedRow];
        
    } else {
        NSButton *button = (NSButton *)sender;
        row = [[self drawerTableView] rowForView:button];
    }
    
    if (row != (long) -1) {
        profile = [[[self pArrayController] arrangedObjects ] objectAtIndex:row];
        [self doOpenEditor:profile];
    }
}


// Returns the directory the application uses to store the Core Data store file. This code uses a directory named "com.lapp5.PDF_Letterhead" in the user's Application Support directory.
- (NSURL *)applicationFilesDirectory
{
    NSFileManager *fileManager = [NSFileManager defaultManager];
    NSURL *appSupportURL = [[fileManager URLsForDirectory:NSApplicationSupportDirectory inDomains:NSUserDomainMask] lastObject];
    return [appSupportURL URLByAppendingPathComponent:@"com.lapp5.PDF_Letterhead"];
}

// Creates if necessary and returns the managed object model for the application.
- (NSManagedObjectModel *)managedObjectModel
{
    if (_managedObjectModel) {
        return _managedObjectModel;
    }
	
    NSURL *modelURL = [[NSBundle mainBundle] URLForResource:@"PDF_Letterhead" withExtension:@"momd"];
    _managedObjectModel = [[NSManagedObjectModel alloc] initWithContentsOfURL:modelURL];
    return _managedObjectModel;
}

// Returns the persistent store coordinator for the application. This implementation creates and return a coordinator, having added the store for the application to it. (The directory for the store is created, if necessary.)
- (NSPersistentStoreCoordinator *)persistentStoreCoordinator
{
    if (_persistentStoreCoordinator) {
        return _persistentStoreCoordinator;
    }
    
    NSManagedObjectModel *mom = [self managedObjectModel];
    if (!mom) {
        NSLog(@"%@:%@ No model to generate a store from", [self class], NSStringFromSelector(_cmd));
        return nil;
    }
    
    NSFileManager *fileManager = [NSFileManager defaultManager];
    NSURL *applicationFilesDirectory = [self applicationFilesDirectory];
    NSError *error = nil;
    
    NSDictionary *properties = [applicationFilesDirectory resourceValuesForKeys:@[NSURLIsDirectoryKey] error:&error];
    
    if (!properties) {
        BOOL ok = NO;
        if ([error code] == NSFileReadNoSuchFileError) {
            ok = [fileManager createDirectoryAtPath:[applicationFilesDirectory path] withIntermediateDirectories:YES attributes:nil error:&error];
        }
        if (!ok) {
            [[NSApplication sharedApplication] presentError:error];
            return nil;
        }
    } else {
        if (![properties[NSURLIsDirectoryKey] boolValue]) {
            // Customize and localize this error.
            NSString *failureDescription = [NSString stringWithFormat:@"Expected a folder to store application data, found a file (%@).", [applicationFilesDirectory path]];
            
            NSMutableDictionary *dict = [NSMutableDictionary dictionary];
            [dict setValue:failureDescription forKey:NSLocalizedDescriptionKey];
            error = [NSError errorWithDomain:@"YOUR_ERROR_DOMAIN" code:101 userInfo:dict];
            
            [[NSApplication sharedApplication] presentError:error];
            return nil;
        }
    }
    
    NSURL *url = [applicationFilesDirectory URLByAppendingPathComponent:@"PDF_Letterhead.storedata"];
    NSPersistentStoreCoordinator *coordinator = [[NSPersistentStoreCoordinator alloc] initWithManagedObjectModel:mom];
    if (![coordinator addPersistentStoreWithType:NSXMLStoreType configuration:nil URL:url options:nil error:&error]) {
        [[NSApplication sharedApplication] presentError:error];
        return nil;
    }
    _persistentStoreCoordinator = coordinator;
    
    return _persistentStoreCoordinator;
}

// Returns the managed object context for the application (which is already bound to the persistent store coordinator for the application.)
- (NSManagedObjectContext *)managedObjectContext
{
    if (_managedObjectContext) {
        return _managedObjectContext;
    }
    
    NSPersistentStoreCoordinator *coordinator = [self persistentStoreCoordinator];
    if (!coordinator) {
        NSMutableDictionary *dict = [NSMutableDictionary dictionary];
        [dict setValue:@"Failed to initialize the store" forKey:NSLocalizedDescriptionKey];
        [dict setValue:@"There was an error building up the data file." forKey:NSLocalizedFailureReasonErrorKey];
        NSError *error = [NSError errorWithDomain:@"YOUR_ERROR_DOMAIN" code:9999 userInfo:dict];
        [[NSApplication sharedApplication] presentError:error];
        return nil;
    }
    _managedObjectContext = [[NSManagedObjectContext alloc] init];
    [_managedObjectContext setPersistentStoreCoordinator:coordinator];
    
    return _managedObjectContext;
}

// Returns the NSUndoManager for the application. In this case, the manager returned is that of the managed object context for the application.
- (NSUndoManager *)windowWillReturnUndoManager:(NSWindow *)window
{
    return [[self managedObjectContext] undoManager];
}

// Performs the save action for the application, which is to send the save: message to the application's managed object context. Any encountered errors are presented to the user.
- (IBAction)saveAction:(id)sender
{
    NSError *error = nil;
    
    if (![[self managedObjectContext] commitEditing]) {
        NSLog(@"%@:%@ unable to commit editing before saving", [self class], NSStringFromSelector(_cmd));
    }
    
    if (![[self managedObjectContext] save:&error]) {
        [[NSApplication sharedApplication] presentError:error];
    }
}

- (NSApplicationTerminateReply)applicationShouldTerminate:(NSApplication *)sender
{
    // Save changes in the application's managed object context before the application terminates.
    
    if (!_managedObjectContext) {
        return NSTerminateNow;
    }
    
    if (![[self managedObjectContext] commitEditing]) {
        NSLog(@"%@:%@ unable to commit editing to terminate", [self class], NSStringFromSelector(_cmd));
        return NSTerminateCancel;
    }
    
    if (![[self managedObjectContext] hasChanges]) {
        return NSTerminateNow;
    }
    
    NSError *error = nil;
    if (![[self managedObjectContext] save:&error]) {
        
        // Customize this code block to include application-specific recovery steps.
        BOOL result = [sender presentError:error];
        if (result) {
            return NSTerminateCancel;
        }
        
        NSString *question = NSLocalizedString(@"Could not save changes while quitting. Quit anyway?", @"Quit without saves error question message");
        NSString *info = NSLocalizedString(@"Quitting now will lose any changes you have made since the last successful save", @"Quit without saves error question info");
        NSString *quitButton = NSLocalizedString(@"Quit anyway", @"Quit anyway button title");
        NSString *cancelButton = NSLocalizedString(@"Cancel", @"Cancel button title");
        NSAlert *alert = [[NSAlert alloc] init];
        [alert setMessageText:question];
        [alert setInformativeText:info];
        [alert addButtonWithTitle:quitButton];
        [alert addButtonWithTitle:cancelButton];
        
        NSInteger answer = [alert runModal];
        
        if (answer == NSAlertAlternateReturn) {
            return NSTerminateCancel;
        }
    }
    
    return NSTerminateNow;
}

- (void) saveManagedObjectContext {
    NSError *error = nil;
    if (![[self managedObjectContext] save:&error]) {
        NSLog(@"Could not save Managed Object Context");
    }
}

- (BOOL)applicationShouldHandleReopen:(NSApplication *)theApplication hasVisibleWindows:(BOOL)flag
{
    if (flag) {
        return NO;
    } else {
        [ _pdfWindow makeKeyAndOrderFront:self];
        return YES;
    }
}


@end
