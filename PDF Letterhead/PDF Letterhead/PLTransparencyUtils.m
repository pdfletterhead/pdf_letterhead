//
//  PLTransparencyUtils.m
//  PDF Letterhead
//
//  Created by Pim Snel on 16-02-16.
//  Copyright © 2016 Pim Snel. All rights reserved.
//

#import "PLTransparencyUtils.h"
#import "PLAppDelegate.h"


@implementation PLTransparencyUtils

@synthesize sourceData, destinationData, ypDoc, allPageContentsObjects;

- (id)initWithData:(NSData*)data
{
    if (self = [super init]) {
        
        sourceData = data;
        
        ypDoc = [[YPDocument alloc] initWithData:data];
        
        return self;
    }
    return nil;
}

-(BOOL) documentHasWhiteBackgrounds
{
    NSLog(@"Detect white bgs");
//    YPPages *pg = [[YPPages alloc] initWithDocument:ypDoc];
//    NSLog(@"page count: %d", [pg getPageCount]);
    
    //All Pages unsorted
    NSArray * allPages = [ypDoc getAllObjectsWithKey:@"Type" value:@"Page"];
    //NSLog(@"all: %@ ", allPages);
    
    BOOL whiteBackgroundFound = NO;
    NSMutableArray * contentsObjects = [NSMutableArray array];
    
    for (YPObject* page in allPages) {
        
        NSString *docContentNumber = [[ypDoc getInfoForKey:@"Contents" inObject:[page getObjectNumber]] getReferenceNumber];
        NSLog(@"page content objnr: %@", docContentNumber);
        
        if(docContentNumber)
        {
            YPObject * pageContentsObject = [ypDoc getObjectByNumber:docContentNumber];
            [contentsObjects addObject:pageContentsObject];
            
            NSString *plainContent = [pageContentsObject getUncompressedStreamContents];
            
            if([self hasWhiteBackgrounds:plainContent])
            {
                whiteBackgroundFound = YES;
            }
        }
    }
    
    allPageContentsObjects = [contentsObjects copy];
    
    return whiteBackgroundFound;
}

-(void) cleanDocumentFromWhiteBackgrounds
{
    NSLog(@"Clear white bgs");
    if(!allPageContentsObjects)
    {
        if(![self documentHasWhiteBackgrounds])
        {
            return;
        }
    }

    for (YPObject* pageContentsObject in allPageContentsObjects)
    {
        //id plainA = [[pageContentsObject getStreamObject] getRawData];
        
//        NSString *pathTo = [[[[NSApp delegate] applicationFilesDirectory] URLByAppendingPathComponent:[NSString stringWithFormat:@"%@.xx",@"raw"]] path];
//        [plainA writeToFile:pathTo atomically:YES];

  //      id plainC = [NSString stringWithUTF8String:[[[pageContentsObject getStreamObject] getRawData] bytes]];
        NSString *plainContent = [pageContentsObject getUncompressedStreamContents];
//        NSString* newStr = [[NSString alloc] initWithData:[[pageContentsObject getStreamObject] getRawData] encoding:NSUTF8StringEncoding];

        
  //      NSLog(@"raw now: %@", plainA);
        //NSLog(@"raw now: %@", plainC);
        //NSLog(@"raw now2: %@", newStr);
        NSLog(@"plain now: %@", plainContent);
        
        NSString * newplain = [self removeWhiteBackgrounds:plainContent];
        
        NSLog(@"newplain now: %@", newplain);
        
        [pageContentsObject setStreamContentsWithString:newplain];
        
        [ypDoc addObjectToUpdateQueue:pageContentsObject];
    }
        
    [ypDoc updateDocumentData];
}

-(void) writeNewDocToFile:(NSString*)path
{
    [[ypDoc modifiedPDFData] writeToFile:path atomically:YES];
}

-(BOOL) hasWhiteBackgrounds:(NSString*)streamContent
{
    //REAL DETECTION
    NSString *needle = @"/Cs1 cs 1 1 1 sc";
    NSString *needle2 = @"1 1 1 rg";
    if ([streamContent rangeOfString:needle].location != NSNotFound) {
        NSLog(@"PDF may contain white backgrounds");
        return YES;
    }

    if ([streamContent rangeOfString:needle2].location != NSNotFound) {
        NSLog(@"PDF may contain white backgrounds");
        return YES;
    }
    
    NSLog(@"PDF does not contain white backgrounds");
    return NO;
}


-(NSString*) removeWhiteBackgrounds:(NSString*)streamContent
{
    NSMutableString* newStreamContent;
    
    newStreamContent = (NSMutableString*)[self removeWhiteBackgroundsWithColorStates:streamContent startItem:@"/Cs1 cs 1 1 1 sc" stopItem:@"/Cs1 cs 0 0 0 sc"];
    
    if(newStreamContent)
    {
        return newStreamContent;
    }
    
    newStreamContent = (NSMutableString*)[self removeWhiteBackgroundsWithColorStates:streamContent startItem:@"1 1 1 rg" stopItem:@"0 0 0 rg"];
    
    if(newStreamContent)
    {
        return newStreamContent;
    }
    
    return streamContent;
}


-(NSString*) removeWhiteBackgroundsWithColorStates:(NSString*)streamContent startItem:(NSString*)aStartItem stopItem:(NSString*)aStopItem
{
    NSMutableString * cleanedStreamContent;

    NSRange startRange = [streamContent rangeOfString:aStartItem];
    NSRange stopRange = [streamContent rangeOfString:aStopItem];
    
    if(stopRange.location == NSNotFound || stopRange.location == NSNotFound)
    {
        NSLog(@"no sc colorscace rectangles found");
        return nil;
    }
    
    else
    {
        //NSLog(@"r1: %lu, r2:, %lu\n",(unsigned long)startRange.location, (unsigned long)stopRange.location);
        
        cleanedStreamContent = (NSMutableString*)[streamContent substringToIndex:startRange.location];
        cleanedStreamContent = (NSMutableString*)[cleanedStreamContent stringByAppendingString:[streamContent substringFromIndex:stopRange.location]];
        
        NSLog(@"r1: %lu, r2:, %lu\ncleaned: %@",(unsigned long)startRange.location, (unsigned long)stopRange.location, cleanedStreamContent);
        return (NSString*)cleanedStreamContent;
    }
   
}

@end




















