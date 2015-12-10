//
//  PLProfile.m
//  PDF Letterhead
//
//  Created by Richard Vollebregt on 10/12/15.
//  Copyright © 2015 Pim Snel. All rights reserved.
//

#import "PLProfile.h"

@implementation PLProfile

- (id)initWithTitle:(NSString *)title {
    if ((self = [super init])) {
        self.title = title;
    }
    return self;
}

@end
