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
//        NSLog(@"%s",[data bytes]);
        
        ypDoc = [[YPDocument alloc] initWithData:data];
        
        return self;
    }
    return nil;
}

-(BOOL) documentHasWhiteBackgrounds
{
    NSArray * allPages = [ypDoc getAllObjectsWithKey:@"Type" value:@"Page"];
    
    
  //      NSLog(@"all: %@",allPages);
    
    BOOL whiteBackgroundFound = NO;
    NSMutableArray * contentsObjects = [NSMutableArray array];
    
    for (YPObject* page in allPages) {
        
        NSString *docContentNumber = [[ypDoc getInfoForKey:@"Contents" inObject:[page getObjectNumber]] getReferenceNumber];
        
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
    if(!allPageContentsObjects)
    {
        if(![self documentHasWhiteBackgrounds])
        {
            return;
        }
    }

    for (YPObject* pageContentsObject in allPageContentsObjects)
    {

        NSData *plainContent = [pageContentsObject getUncompressedStreamContentsAsData];
        
        NSData * newplain = [self removeWhiteBackgrounds:plainContent];
        
        [pageContentsObject setStreamContentsWithData:newplain];
        
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
//    NSLog(@"detect in %@",streamContent);
    
    
    //REAL DETECTION
    NSString *needle = @"/Cs1 cs 1 1 1 sc";
    NSString *needle2 = @"1 1 1 rg";
    if ([streamContent rangeOfString:needle].location != NSNotFound) {
        return YES;
    }

    if ([streamContent rangeOfString:needle2].location != NSNotFound) {
        return YES;
    }
    
    return NO;
}


-(NSData*) removeWhiteBackgrounds:(NSData*)streamContent
{
    NSMutableData* newStreamContent;
    
   // NSLog(@"%s",[streamContent bytes]);
    
    newStreamContent = (NSMutableData*)[self removeWhiteBackgroundsWithColorStates:streamContent startItem:@"/Cs1 cs 1 1 1 sc" stopItem:@"/Cs1 cs 0 0 0 sc"];
    
    if(newStreamContent)
    {
        return newStreamContent;
    }
    
    newStreamContent = (NSMutableData*)[self removeWhiteBackgroundsWithColorStates:streamContent startItem:@"1 1 1 rg" stopItem:@"0 0 0 rg"];
    
    if(newStreamContent)
    {
        return newStreamContent;
    }
    
    return (NSData*)streamContent;
}

-(NSData*) removeWhiteBackgroundsWithColorStates:(NSData*)streamContentAsData startItem:(NSString*)aStartItem stopItem:(NSString*)aStopItem
{
    NSString * streamContent = [[NSString alloc] initWithData:streamContentAsData encoding:NSMacOSRomanStringEncoding];

    NSRange startRange = [streamContent rangeOfString:aStartItem];
    NSRange stopRange = [streamContent rangeOfString:aStopItem];
    
    if(startRange.location == NSNotFound || stopRange.location == NSNotFound)
    {
        return nil;
    }
    else
    {
        NSRange firstPartRange = {0,startRange.location};
        NSRange lastPartRange = {stopRange.location, ([streamContentAsData length]-stopRange.location)};
        NSData *firstPartCleanedStreamContent = [streamContentAsData subdataWithRange:firstPartRange];
        NSData *lastPartCleanedStreamContent = [streamContentAsData subdataWithRange:lastPartRange];
        
        NSMutableData * cleanedStreamContent = [firstPartCleanedStreamContent mutableCopy];
        [cleanedStreamContent appendData:lastPartCleanedStreamContent];
       
        return (NSData*)cleanedStreamContent;
    }
}

@end




















