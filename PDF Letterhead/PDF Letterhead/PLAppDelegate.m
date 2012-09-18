//
//  PLAppDelegate.m
//  PDF Letterhead
//
//  Created by Pim Snel on 17-09-12.
//  Copyright (c) 2012 Pim Snel. All rights reserved.
//
#import "PLAppDelegate.h"
#import "PLPDFPage.h"

@implementation PLAppDelegate

@synthesize persistentStoreCoordinator = _persistentStoreCoordinator;
@synthesize managedObjectModel = _managedObjectModel;
@synthesize managedObjectContext = _managedObjectContext;

- (void)applicationDidFinishLaunching:(NSNotification *)aNotification
{
    // Insert code here to initialize your application
}

-(void) setPreview
{
	NSImage			*bgimage;
	NSImage			*sourceimage;
	PLPDFPage       *page;
	
	// Start with an empty PDFDocument.
	_letterheadPDF = [[PDFDocument alloc] init];
	
    if([_backgrounddoc getFilepath]){
        bgimage = [_backgrounddoc image];
    }
    else{
        bgimage = NULL;
        NSBundle* myBundle = [NSBundle mainBundle];
        NSString* myImagePath = [myBundle pathForResource:@"white" ofType:@"pdf"];
        
        bgimage = [[NSImage alloc] initWithContentsOfFile: myImagePath];
    }
    
    // Get image.
    if([_sourcedoc getFilepath]){
        sourceimage = [_sourcedoc image];
        
        NSLog(@"pdf path:%@",[_sourcedoc getFilepath]);
        PDFDocument * sourcePDF = [[PDFDocument alloc] initWithURL:[NSURL fileURLWithPath:[_sourcedoc getFilepath]]];
        NSUInteger pagescount = [sourcePDF pageCount];
        NSLog(@"pages: %li",pagescount);
        
        for (int y = 0; y < pagescount; y++) {
            PDFPage *currentPage = [sourcePDF pageAtIndex:y];
            NSImage *image = [[NSImage alloc] initWithData:[currentPage dataRepresentation]];
            
            // Create our custom PDFPage subclass (pass it an image and the month it is to represent).
            page = [[PLPDFPage alloc] initWithBGImage: bgimage sourceDoc: image];
            
            // Insert the new page in our PDF document.
            [_letterheadPDF insertPage: page atIndex: y];
            
            NSLog(@"y = %i", y);
        }
    }
    else{
        sourceimage = NULL;
        page = [[PLPDFPage alloc] initWithBGImage: bgimage sourceDoc: sourceimage];
    
        [_letterheadPDF insertPage: page atIndex: 0];

    }
	
    // Assign PDFDocument ot PDFView.
	[_pdfView setDocument: _letterheadPDF];
	
    //to make sure to right document is printed. But we must replace the print functions
    [_pdfWindow makeFirstResponder:_pdfView];
}


- (IBAction)saveAs: (id) sender
{
    NSString * newFileName;
    if ([_sourcedoc getFilepath] == nil) {
        newFileName = @"new.pdf";
    }
    else {
        newFileName = [NSString stringWithFormat:@"%@-BGD.pdf" ,[[[_sourcedoc getFilepath] lastPathComponent] stringByDeletingPathExtension]];
    }
    
    NSSavePanel *spanel = [NSSavePanel savePanel];
    [spanel beginSheetForDirectory:nil
                              file:newFileName
                    modalForWindow:_pdfWindow
                     modalDelegate:self
                    didEndSelector:@selector(didEndSaveSheet:returnCode:contextInfo:)
                       contextInfo:NULL];
  
	
	// Create save panel, require PDF.
	[spanel setRequiredFileType: @"pdf"];
	
	// Run save panel — write PDF document to resulting URL.
	if ([spanel runModal] == NSFileHandlingPanelOKButton)
		[_letterheadPDF writeToURL: [spanel URL]];
    [_pdfWindow makeFirstResponder:_pdfView];

}

- (IBAction)saveEmail: (id) sender
{
    NSString * newFileName;
    if ([_sourcedoc getFilepath] == nil) {
        newFileName = @"/tmp/new.pdf";
    }
    else {
        newFileName = [NSString stringWithFormat:@"/tmp/%@-BGD.pdf" ,[[[_sourcedoc getFilepath] lastPathComponent] stringByDeletingPathExtension]];
    }
    
    NSLog(@"email");
    NSAppleScript *mailScript;
    NSURL * tmpFileUrl = [NSURL fileURLWithPath:newFileName isDirectory:NO];
	[_letterheadPDF writeToURL:tmpFileUrl];
    NSString * subject = @"My PDF";
    NSString * body = @"";
    
    NSString *scriptString= [NSString stringWithFormat:@"set theAttachment to \"%@\"\nset the new_path to POSIX file theAttachment\ntell application \"Mail\"\nset theNewMessage to make new outgoing message with properties {subject:\"%@\", content:\"%@\" & return & return, visible:true}\n tell theNewMessage\ntry\nmake new attachment with properties {file name:new_path} at after the last word of the last paragraph\nend try\nend tell\nactivate\nend tell",newFileName,subject,body];
    NSLog(scriptString);
    mailScript = [[NSAppleScript alloc] initWithSource:scriptString];
    [mailScript executeAndReturnError:nil];
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

@end
