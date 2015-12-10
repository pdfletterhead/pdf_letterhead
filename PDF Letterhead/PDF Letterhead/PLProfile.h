//
//  PLProfile.h
//  PDF Letterhead
//
//  Created by Richard Vollebregt on 10/12/15.
//  Copyright © 2015 Pim Snel. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface PLProfile : NSObject

@property (strong) NSString *title;

- (id)initWithTitle:(NSString*)title;

@end
