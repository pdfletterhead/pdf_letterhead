//
//  YPPages.h
//  YAPDFKit
//
//  Created by Aliona on 28.05.14.
//  Copyright (c) 2014 Ptenster. All rights reserved.
//

#import "YPDocument.h"

@interface YPPages : NSObject

@property id pageInfoObjectNum;

- (id)initWithDocument:(YPDocument *)d;
- (int)getPageCount;
- (id)getPagesTree;

@end
