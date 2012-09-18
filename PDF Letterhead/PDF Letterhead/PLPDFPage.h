//
//  PLPDFPage.h
//  PDF Letterhead
//
//  Created by Pim Snel on 17-09-12.
//  Copyright (c) 2012 Pim Snel. All rights reserved.
//

#import <Quartz/Quartz.h>

@interface PLPDFPage : PDFPage
{
    NSImage		*_bgimage;
    NSImage		*_frontimage;
}
- (id) initWithBGImage: (NSImage *) bgimage sourceDoc: (NSImage *) sourceimage;
@end
