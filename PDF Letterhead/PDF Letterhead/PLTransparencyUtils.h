//
//  PLTransparencyUtils.h
//  PDF Letterhead
//
//  Created by Pim Snel on 16-02-16.
//  Copyright © 2016 Pim Snel. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "YPDocument.h"

@interface PLTransparencyUtils : NSObject

@property NSData* sourceData;
@property YPDocument* ypDoc;
@property NSMutableData* destinationData;
@property NSArray * allPageContentsObjects;

- (id)initWithData:(NSData*)data;

-(BOOL) documentHasWhiteBackgrounds;
-(BOOL) hasWhiteBackgrounds:(NSString*)streamContent;
-(void) cleanDocumentFromWhiteBackgrounds;
-(NSString*) removeWhiteBackgrounds:(NSString*)streamContent;
-(void) writeNewDocToFile:(NSString*)path;
@end
