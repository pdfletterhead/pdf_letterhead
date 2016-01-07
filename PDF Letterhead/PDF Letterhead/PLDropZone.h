//
//  DropZone.h
//  T3x Expander
//
//  Created by Pim Snel on 06-10-11.
//  Copyright 2011 Lingewoud B.V. All rights reserved.
//

#import <Cocoa/Cocoa.h>
#import "Profile.h"
#import "PLProfileEditWindow.h"

@interface PLDropZone : NSImageView{
    NSString * sourcefilepath;
    BOOL imageIsSet;
}
@property NSString *sourcefilepath;

- (void)dropAreaFadeIn;
- (void)dropAreaFadeOut;
-(NSString *)getFilepath;
-(BOOL) setPdfFilepath:(NSString*)path;
-(void) setFilepath:(NSString*)path;

@end


