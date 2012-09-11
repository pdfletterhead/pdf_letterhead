//
//  pmpPrintInfo.h
//  PDF Letterhead
//
//  Created by Pim Snel on 11-09-12.
//  Copyright (c) 2012 Lingewoud b.v. All rights reserved.
//

#import <Foundation/Foundation.h>
#include <AppKit/NSPrintInfo.h>

@interface pmpPrintInfo : NSPrintInfo

- (NSRect)imageablePageBounds;

@end
