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
    
    NSArray * allPages = [ypDoc getAllObjectsWithKey:@"Type" value:@"Page"];
    
    
    BOOL whiteBackgroundFound = NO;
    NSMutableArray * contentsObjects = [NSMutableArray array];
    
    for (YPObject* page in allPages) {
        
        NSString *docContentNumber = [[ypDoc getInfoForKey:@"Contents" inObject:[page getObjectNumber]] getReferenceNumber];
       // NSLog(@"page content objnr: %@", docContentNumber);
        
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


-(NSData*) removeWhiteBackgrounds:(NSData*)streamContent
{
    NSMutableData* newStreamContent;
    
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
    
//    NSString * streamContent = [[NSString alloc] initWithData:streamContentAsData encoding:NSUTF8StringEncoding];
//    NSString * streamContent = [[NSString alloc] initWithData:streamContentAsData encoding:NSASCIIStringEncoding];
    NSString * streamContent = [[NSString alloc] initWithData:streamContentAsData encoding:NSMacOSRomanStringEncoding];
    

    NSRange startRange = [streamContent rangeOfString:aStartItem];
    NSRange stopRange = [streamContent rangeOfString:aStopItem];
    
    
    if(stopRange.location == NSNotFound || stopRange.location == NSNotFound)
    {
        NSLog(@"no sc colorscace rectangles found");
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
        
        NSLog(@"\nranges: %@\n%@", NSStringFromRange(firstPartRange), NSStringFromRange(lastPartRange));
   //     NSLog(@"plain now: %@", streamContent);
   //     NSLog(@"r1: %lu, r2:, %lu\n",(unsigned long)startRange.location, (unsigned long)stopRange.location);
        //cleanedStreamContent = (NSMutableString*)[streamContent substringToIndex:startRange.location];
        //cleanedStreamContent = (NSMutableString*)[cleanedStreamContent stringByAppendingString:[streamContent substringFromIndex:stopRange.location]];
   //     NSLog(@"r1: %lu, r2:, %lu\ncleaned: %@",(unsigned long)startRange.location, (unsigned long)stopRange.location, cleanedStreamContent);
       
        const char *output = malloc([streamContentAsData length]);
        output = [streamContentAsData bytes];
        printf("\nwat:%s\n",output);
        
        const char *output2 = malloc([cleanedStreamContent length]);
        output2 = [cleanedStreamContent bytes];
        printf("\nwat2:%s\n",output2);
        return (NSData*)cleanedStreamContent;
    }
    
}

@end




















