//
//  DropZone.h
//  T3x Expander
//
//  Created by Pim Snel on 06-10-11.
//  Copyright 2011 Lingewoud B.V. All rights reserved.
//

#import <Cocoa/Cocoa.h>

@interface pmpDropZone : NSImageView{
NSString * sourcefilepath;
}
@property NSString *sourcefilepath;

- (void)dropAreaFadeIn;
- (void)dropAreaFadeOut;
-(NSString *)getFilepath;
-(void) setFilepath:(NSString*)path;

@end


