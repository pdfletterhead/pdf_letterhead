//
//  PLProfileImage.m
//  PDF Letterhead
//
//  Created by Richard Vollebregt on 10/12/15.
//  Copyright © 2015 Pim Snel. All rights reserved.
//

#import "PLProfile.h"
#import "PLProfileImage.h"

@implementation PLProfileImage
- (id)initWithTitle:(NSString *)title coverImage:(NSImage *)coverImage backgroundImage:(NSImage *)backgroundImage {
    
    if ((self = [super init])) {
        self.data = [[PLProfile alloc] initWithTitle:title];
        self.coverImage = coverImage;
        self.backgroundImage = backgroundImage;
    }
    return self;
}
@end
