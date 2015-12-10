//
//  PLProfileImage.h
//  PDF Letterhead
//
//  Created by Richard Vollebregt on 10/12/15.
//  Copyright © 2015 Pim Snel. All rights reserved.
//

#import <Foundation/Foundation.h>

@class PLProfile;

@interface PLProfileImage : NSObject

@property (strong) PLProfile *data;
@property (strong) NSImage *coverImage;
@property (strong) NSImage *backgroundImage;

- (id)initWithTitle:(NSString*)title coverImage:(NSImage*)coverImage backgroundImage:(NSImage*)backgroundImage;

@end
