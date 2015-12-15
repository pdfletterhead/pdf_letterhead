//
//  PLImageTransformer.m
//  PDF Letterhead
//
//  Created by Richard Vollebregt on 14/12/15.
//  Copyright © 2015 Pim Snel. All rights reserved.
//

#import "PLImageTransformer.h"

@implementation PLImageTransformer

+(Class)transformedValueClass {
    return [NSImage class];
}

-(id)transformedValue:(id)value {
    if (value == nil) {
        return nil;
    } else {
        return [[NSImage alloc] initWithContentsOfURL:[NSURL URLWithString:value]];
    }
}

@end
