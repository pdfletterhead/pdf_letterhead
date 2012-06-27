//
//  pmpAppDelegate.m
//  background pdf
//
//  Created by Pim Snel on 13-04-12.
//  Copyright (c) 2012 Lingewoud b.v. All rights reserved.
//

#import "pmpAppDelegate.h"
#import "pmpDropZone.h"

@implementation pmpAppDelegate

@synthesize window = _window;
@synthesize persistentStoreCoordinator = __persistentStoreCoordinator;
@synthesize managedObjectModel = __managedObjectModel;
@synthesize managedObjectContext = __managedObjectContext;

@synthesize previewView,previewView2,sourcedoc,backgrounddoc;





-(IBAction)printPDF:(id)sender{


    
    
    
    
        NSPrintInfo *info = [NSPrintInfo sharedPrintInfo];
        [info setHorizontalPagination:NSFitPagination];
        [info setVerticalPagination:NSFitPagination];
        [info setHorizontallyCentered:NO];
        [info setVerticallyCentered:NO];
        
        //NSImageView *view = [[NSImageView alloc] init];
        //[previewView2 setImage:image];
        //[previewView2 setImageScaling:NSScaleProportionally];
        //[previewView2 setBoundsOrigin:NSMakePoint(boundsX, boundsY)];
        //[previewView2 setBoundsSize:NSMakeSize(boundsWidth, boundsHeight)];
        //[previewView2 translateOriginToPoint:NSMakePoint(boundsX, [info paperSize].height -                                              boundsHeight - boundsY)];
        
        NSPrintOperation *printOp = [NSPrintOperation printOperationWithView:previewView2 printInfo:info];
        [printOp setShowsPrintPanel:YES];
        [printOp runOperation];
    
    //[previewView2 print:sender];
}




-(void) saveAs:(NSString *)startdir :(NSString *)initname
{
    NSString * newFileName;
    if ([sourcedoc getFilepath] == nil) {
        newFileName = @"new.pdf";
    }
    else {
        newFileName = [NSString stringWithFormat:@"%@-BGD.pdf" ,[[[sourcedoc getFilepath] lastPathComponent] stringByDeletingPathExtension]];

    }
    
    NSSavePanel *spanel = [NSSavePanel savePanel];
    [spanel beginSheetForDirectory:nil
                              file:newFileName
                    modalForWindow:self.window
                     modalDelegate:self
                    didEndSelector:@selector(didEndSaveSheet:returnCode:contextInfo:)
                       contextInfo:NULL];
}

-(void)didEndSaveSheet:(NSSavePanel *)savePanel returnCode:(int)returnCode contextInfo:(void *)contextInfo
{
    if (returnCode == NSOKButton){
        NSLog([savePanel filename]);
        //[self createNewPDF:[sourcedoc getFilepath] :[backgrounddoc getFilepath] :@"/Users/pim/Desktop/tmp.pdf"];
        //[self setPreview];
        [previewView2 saveToPDF:[savePanel filename]];
    }else{
        NSLog(@"Cancel");
    }
}

-(IBAction)saveNewPDF:(id)sender
{
    NSLog(@"saveNewPDF");

    [self saveAs:@"startDir" :@"initName"];
}

-(IBAction)previewPDF:(id)sender
{
    [self setPreview];
}

-(void) setPreview
{
    NSLog(@"setPreview");
    [previewView2 backgroundImage:[[NSImage alloc] initWithContentsOfFile:[backgrounddoc getFilepath]]];
    [previewView2 sourceImage:[[NSImage alloc] initWithContentsOfFile:[sourcedoc getFilepath]]];
}

-(void) createNewPDF:(NSString *)source :(NSString *)background :(NSString *)dest
{
    NSLog(@"createNewPDF source: %@ bg: %@ dest: %@",source, background, dest);   
}


+ (void)unpackT3xFile:(NSString *)filePath
{
    NSLog(@"Unpacking %@",filePath);
    //	set phpcommand to "/usr/bin/php -c" & hiddeninipath & " " & hiddenscriptpath & " " & full_path & " " & full_path_new
    
    NSString *expandt3xPath = [NSString stringWithFormat:@"%@/Contents/Resources/expandt3x",[[NSBundle mainBundle] bundlePath]];
    NSLog(@"expandt3xPath: %@",expandt3xPath);
    
    NSString * phpExec = @"/usr/bin/php";
    NSString * phpIniPath = [NSString stringWithFormat:@"%@/php.ini",expandt3xPath];
    NSString * phpScriptPath = [NSString stringWithFormat:@"%@/expandt3x.php",expandt3xPath];
    
    NSString * newOutputPath = [filePath stringByDeletingPathExtension];
   
    
}

- (void)applicationDidFinishLaunching:(NSNotification *)aNotification
{
    // Insert code here to initialize your application
}

// Returns the directory the application uses to store the Core Data store file. This code uses a directory named "com.lapp5.background_pdf" in the user's Application Support directory.
- (NSURL *)applicationFilesDirectory
{
    NSFileManager *fileManager = [NSFileManager defaultManager];
    NSURL *appSupportURL = [[fileManager URLsForDirectory:NSApplicationSupportDirectory inDomains:NSUserDomainMask] lastObject];
    return [appSupportURL URLByAppendingPathComponent:@"com.lapp5.background_pdf"];
}

// Creates if necessary and returns the managed object model for the application.
- (NSManagedObjectModel *)managedObjectModel
{
    if (__managedObjectModel) {
        return __managedObjectModel;
    }
	
    NSURL *modelURL = [[NSBundle mainBundle] URLForResource:@"background_pdf" withExtension:@"momd"];
    __managedObjectModel = [[NSManagedObjectModel alloc] initWithContentsOfURL:modelURL];
    return __managedObjectModel;
}

// Returns the persistent store coordinator for the application. This implementation creates and return a coordinator, having added the store for the application to it. (The directory for the store is created, if necessary.)
- (NSPersistentStoreCoordinator *)persistentStoreCoordinator
{
    if (__persistentStoreCoordinator) {
        return __persistentStoreCoordinator;
    }
    
    NSManagedObjectModel *mom = [self managedObjectModel];
    if (!mom) {
        NSLog(@"%@:%@ No model to generate a store from", [self class], NSStringFromSelector(_cmd));
        return nil;
    }
    
    NSFileManager *fileManager = [NSFileManager defaultManager];
    NSURL *applicationFilesDirectory = [self applicationFilesDirectory];
    NSError *error = nil;
    
    NSDictionary *properties = [applicationFilesDirectory resourceValuesForKeys:[NSArray arrayWithObject:NSURLIsDirectoryKey] error:&error];
    
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
        if (![[properties objectForKey:NSURLIsDirectoryKey] boolValue]) {
            // Customize and localize this error.
            NSString *failureDescription = [NSString stringWithFormat:@"Expected a folder to store application data, found a file (%@).", [applicationFilesDirectory path]];
            
            NSMutableDictionary *dict = [NSMutableDictionary dictionary];
            [dict setValue:failureDescription forKey:NSLocalizedDescriptionKey];
            error = [NSError errorWithDomain:@"YOUR_ERROR_DOMAIN" code:101 userInfo:dict];
            
            [[NSApplication sharedApplication] presentError:error];
            return nil;
        }
    }
    
    NSURL *url = [applicationFilesDirectory URLByAppendingPathComponent:@"background_pdf.storedata"];
    NSPersistentStoreCoordinator *coordinator = [[NSPersistentStoreCoordinator alloc] initWithManagedObjectModel:mom];
    if (![coordinator addPersistentStoreWithType:NSXMLStoreType configuration:nil URL:url options:nil error:&error]) {
        [[NSApplication sharedApplication] presentError:error];
        return nil;
    }
    __persistentStoreCoordinator = coordinator;
    
    return __persistentStoreCoordinator;
}

// Returns the managed object context for the application (which is already bound to the persistent store coordinator for the application.) 
- (NSManagedObjectContext *)managedObjectContext
{
    if (__managedObjectContext) {
        return __managedObjectContext;
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
    __managedObjectContext = [[NSManagedObjectContext alloc] init];
    [__managedObjectContext setPersistentStoreCoordinator:coordinator];

    return __managedObjectContext;
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
    
    if (!__managedObjectContext) {
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
