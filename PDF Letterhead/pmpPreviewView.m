//
//  pmpPreviewView.m
//  background pdf
//
//  Created by Pim Snel on 16-04-12.
//  Copyright (c) 2012 Lingewoud b.v. All rights reserved.
//

#import "pmpPreviewView.h"
#import "pmpPrintInfo.h"

@implementation pmpPreviewView

@synthesize srcImage, bgImage;

- (id)initWithFrame:(NSRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {

      rect = [self bounds];      
      //bgImage = [[NSImage alloc] initWithContentsOfFile:@"/Users/pim/Desktop/source.pdf"];
      //srcImage = [[NSImage alloc] initWithContentsOfFile:@"/Users/pim/Desktop/source.pdf"];
    }
    
    return self;
}

- (BOOL)backgroundImage:(NSImage *)newImage {
    
    if (newImage && (newImage != bgImage)) {
        [newImage setSize:rect.size];
        [newImage setScalesWhenResized:YES];
        if ([newImage isValid]) {
            bgImage = newImage;
            
            [self setNeedsDisplay:YES];
            return YES;
        }
    }
    return NO;
}

- (BOOL)sourceImage:(NSImage *)newImage {
  
    NSLog(@"new source");

    if (newImage && (newImage != srcImage)) {
        [newImage setSize:rect.size];
        [newImage setScalesWhenResized:YES];
        if ([newImage isValid]) {
            srcImage = newImage;

            [self setNeedsDisplay:YES];
            return YES;
        }
    }
    return NO;
}

- (void)print:(id)sender{
    NSLog(@"lets print");
    
    
    NSPrintInfo *printInfo;
    NSPrintInfo *sharedInfo;
    NSPrintOperation *printOp;
    NSMutableDictionary *printInfoDict;
    NSMutableDictionary *sharedDict;
    
    sharedInfo = [NSPrintInfo sharedPrintInfo];
    sharedDict = [sharedInfo dictionary];
    printInfoDict = [NSMutableDictionary dictionaryWithDictionary: sharedDict];
    
    [printInfoDict setObject:NSPrintSaveJob forKey:NSPrintJobDisposition];
    
    //[printInfoDict setObject:filename forKey:NSPrintSavePath];
    
    
    printInfo = [[NSPrintInfo alloc] initWithDictionary: printInfoDict];
    //        [printInfo setHorizontalPagination: NSAutoPagination];
    //        [printInfo setVerticalPagination: NSAutoPagination];
    /*
     [printInfo setHorizontalPagination:NSClipPagination];
    [printInfo setVerticalPagination:NSClipPagination];
    [printInfo setVerticallyCentered:YES];
    [printInfo setHorizontallyCentered:YES];
     */
    
    [printInfo setRightMargin:0.0];
    [printInfo setTopMargin:0.0];
    [printInfo setLeftMargin:0.0];
    [printInfo setBottomMargin:0.0];
    
    //[[printInfo imageablePageBounds] = NSMakeRect(0.0,0.0, 571.0, 817.0);
    [printInfo setScalingFactor:2.0];

    NSDictionary *printInfoDict2 = [printInfo printSettings];
    
    for (id key in printInfoDict2) {
        
        NSLog(@"key: %@, value: %@", key, [printInfoDict objectForKey:key]);
        
    }
    
    
    
    NSLog(@"lets print: %@",NSStringFromRect([printInfo imageablePageBounds]));
    
    printOp = [NSPrintOperation printOperationWithView:self printInfo:printInfo];
    //[printOp setShowPanels:NO];
    [printOp runOperation];
    
//    [super print:sender];

}

/*
 Letter		 612x792
 LetterSmall	 612x792
 Tabloid		 792x1224
 Ledger		1224x792
 Legal		 612x1008
 Statement	 396x612
 Executive	 540x720
 A0               2384x3371
 A1              1685x2384
 A2		1190x1684
 A3		 842x1190
 A4		 595x842
 A4Small		 595x842
 A5		 420x595
 B4		 729x1032
 B5		 516x729
 Envelope	 ???x???
 Folio		 612x936
 Quarto		 610x780
 10x14		 720x1008
 */

- (void)saveToPDF:(NSString *)filename {
    
    BOOL pageit = YES;
    if(pageit){

        
        NSPrintInfo *printInfo;
        NSPrintInfo *sharedInfo;
        NSPrintOperation *printOp;
        NSMutableDictionary *printInfoDict;
        NSMutableDictionary *sharedDict;
        
        sharedInfo = [NSPrintInfo sharedPrintInfo];
        sharedDict = [sharedInfo dictionary];
        printInfoDict = [NSMutableDictionary dictionaryWithDictionary: sharedDict];
        
        [printInfoDict setObject:NSPrintSaveJob forKey:NSPrintJobDisposition];
        
        [printInfoDict setObject:filename forKey:NSPrintSavePath];
        
        
        printInfo = [[pmpPrintInfo alloc] initWithDictionary: printInfoDict];
//        [printInfo setHorizontalPagination: NSAutoPagination];
//        [printInfo setVerticalPagination: NSAutoPagination];
        [printInfo setHorizontalPagination:NSClipPagination];
        [printInfo setVerticalPagination:NSClipPagination];
        [printInfo setVerticallyCentered:YES];
        [printInfo setHorizontallyCentered:YES];
        [printInfo setScalingFactor:2.0];
        [printInfo setRightMargin:0.0];
        [printInfo setTopMargin:0.0];
        [printInfo setLeftMargin:0.0];
        [printInfo setBottomMargin:0.0];
        //[[printInfo imageablePageBounds] = NSMakeRect(0.0,0.0, 571.0, 817.0);

        NSDictionary *printInfoDict2 = [printInfo printSettings];
        
        for (id key in printInfoDict2) {
            
            NSLog(@"key: %@, value: %@", key, [printInfoDict objectForKey:key]);
            
        }
        
        
        
        NSLog(@"lets print: %@",NSStringFromRect([printInfo imageablePageBounds]));
        
        printOp = [NSPrintOperation printOperationWithView:self printInfo:printInfo];
        [printOp setShowPanels:NO];
        [printOp runOperation];
    }
    else{
        
        NSRect r = [self bounds];
        NSData *data = [self dataWithPDFInsideRect:r];
        
        [data writeToFile:filename atomically:YES];
    }
}

- (void)drawRect:(NSRect)dirtyRect
{

    [[NSColor whiteColor] set];
    NSRectFill(rect);

    [bgImage drawInRect:[self bounds] fromRect:NSZeroRect operation:NSCompositeSourceOver fraction:1];
    [srcImage drawInRect:[self bounds] fromRect:NSZeroRect operation:NSCompositeSourceOver fraction:1];
}

@end
