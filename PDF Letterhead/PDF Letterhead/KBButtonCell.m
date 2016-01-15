//
//  KBButtonCell.m
//  CustomButtons
//
//  Created by Kyle Bock on 11/2/12.
//  Copyright (c) 2012 Kyle Bock. All rights reserved.
//

#import "KBButtonCell.h"
#import "NSColor+ColorExtensions.h"

@implementation KBButtonCell

- (void)setKBButtonType:(BButtonType)type {

    [[NSGraphicsContext currentContext] saveGraphicsState];
    kbButtonType = type;
    [[NSGraphicsContext currentContext] restoreGraphicsState];
}

- (NSImage *)mirrorImage:(NSImage *)image inAxis:(NSString *)axis
{
    NSImage *existingImage = image;
    NSSize existingSize = [existingImage size];
    NSSize newSize = NSMakeSize(existingSize.width, existingSize.height);
    NSImage *flippedImage = [[NSImage alloc] initWithSize:newSize];
    
    [flippedImage lockFocus];
    [[NSGraphicsContext currentContext] setImageInterpolation:NSImageInterpolationHigh];
    
    NSAffineTransform *t = [NSAffineTransform transform];
    
    if([axis isEqual:@"x"]){
        [t translateXBy:0.0 yBy:existingSize.height];
        [t scaleXBy:1 yBy:-1];
    }
    else if([axis isEqual:@"y"]){
        [t translateXBy:existingSize.width yBy:0.0];
        [t scaleXBy:-1 yBy:1];
    }
    else{
        //raise
    }
    
    [t concat];
        

    [existingImage drawAtPoint:NSZeroPoint fromRect:NSMakeRect(0, 0, newSize.width, newSize.height) operation:NSCompositeSourceOver fraction:1.0];
    
    [flippedImage unlockFocus];
    
    return flippedImage;
}

- (NSColor*)getColorForButtonType {
    switch (kbButtonType) {
        case BButtonTypeDefault:
            return [NSColor colorWithCalibratedRed:0.85f green:0.85f blue:0.85f alpha:1.00f];
            break;
        case BButtonTypePrimary:
            return [NSColor colorWithCalibratedRed:0.00f green:0.33f blue:0.80f alpha:1.00f];
            break;
        case BButtonTypeInfo:
            return [NSColor colorWithCalibratedRed:0.18f green:0.59f blue:0.71f alpha:1.00f];
            break;
        case BButtonTypeSuccess:
            return [NSColor colorWithCalibratedRed:0.32f green:0.64f blue:0.32f alpha:1.00f];
            break;
        case BButtonTypeWarning:
            return [NSColor colorWithCalibratedRed:0.97f green:0.58f blue:0.02f alpha:1.00f];
            break;
        case BButtonTypeDanger:
            return [NSColor colorWithCalibratedRed:0.74f green:0.21f blue:0.18f alpha:1.00f];
            break;
        case BButtonTypeInverse:
            return [NSColor colorWithCalibratedRed:0.13f green:0.13f blue:0.13f alpha:1.00f];
            break;
        case BButtonTypeLight:
            return [NSColor getColorForHexCode: @"eaedf1"];
            //return [NSColor colorWithCalibratedRed:0.85f green:0.85f blue:0.85f alpha:1.00f];
            //#eaedf1
            break;
        case BButtonTypeDark:
            return [NSColor getColorForHexCode: @"505050"];
            break;
    }
}


- (void)drawImage:(NSImage*)image withFrame:(NSRect)frame inView:(NSView*)controlView
{
    

    
    
    NSAttributedString *attrStr = [self attributedTitle];
    CGSize stringSize = [attrStr size];
    CGFloat titleWidth = stringSize.width;
    
    CGFloat marge = (controlView.frame.size.width - titleWidth + frame.size.width - 5) / 2;
    BOOL drawShadow = NO;


//    NSLog(@"FOR: : %@",[self title]);
//    NSLog(@"calc: marge: %fd", marge);
//    NSLog(@"calc: titleWidth: %fd", stringSize.width);

//    NSLog(@"given: controlview.width: %fd", controlView.frame.size.width);
//    NSLog(@"given: frame.width: %fd", frame.size.width);
//    NSLog(@"END: : %@",[self title]);
   
    NSColor *titleColor;
    if ([[self getColorForButtonType] isLightColor]) {
        titleColor = [NSColor blackColor];
    } else {
        titleColor = [NSColor whiteColor];
        drawShadow = YES;
    }

    NSRect newFrame = CGRectMake(marge - frame.size.width - 0,
                                 frame.origin.y,
                                 frame.size.width,
                                 frame.size.height);
    
    
    NSGraphicsContext *ctx = [NSGraphicsContext currentContext];
    
    CGContextRef contextRef = [ctx graphicsPort];   
    
    NSImage *useImage = [self mirrorImage:image inAxis:@"x"];

    NSData *data = [useImage TIFFRepresentation];
    
    CGImageSourceRef source = CGImageSourceCreateWithData((__bridge CFDataRef)data, NULL);

    if(source) {
        CGImageRef imageRef = CGImageSourceCreateImageAtIndex(source, 0, NULL);
        CFRelease(source);

        if(drawShadow){
        //shadow
        CGContextSaveGState(contextRef);
        {
            NSRect rect = NSOffsetRect(newFrame, 0.0f, 1.0f);
            CGContextClipToMask(contextRef, NSRectToCGRect(rect), imageRef);
            [[NSColor blackColor] setFill];
            NSRectFill(rect);
        }
        CGContextRestoreGState(contextRef);

        }
        
        //realimage
        CGContextSaveGState(contextRef);
        {
            NSRect rect = newFrame;
            CGContextClipToMask(contextRef, NSRectToCGRect(rect), imageRef);
            [titleColor setFill];
            NSRectFill(rect);
        }
        CGContextRestoreGState(contextRef);
        CFRelease(imageRef);
    }
}

- (void)drawBezelWithFrame:(NSRect)frame inView:(NSView *)controlView
{
    NSGraphicsContext* ctx = [NSGraphicsContext currentContext];
    
    // corner radius
    CGFloat roundedRadius = 3.0f;
    
    NSColor *color = [self getColorForButtonType];
    
    // Draw darker overlay if button is pressed
    if([self isHighlighted]) {
        [ctx saveGraphicsState];
        
        [[NSBezierPath bezierPathWithRoundedRect:frame
                                         xRadius:roundedRadius
                                         yRadius:roundedRadius] setClip];
        
        [[color darkenColorByValue:0.12f] setFill];
        NSRectFillUsingOperation(frame, NSCompositeSourceOver);
        [ctx restoreGraphicsState];
        
        return;
    }
    
    // create background color
    [ctx saveGraphicsState];
    
    [[NSBezierPath bezierPathWithRoundedRect:frame
                                     xRadius:roundedRadius
                                     yRadius:roundedRadius] setClip];
    
  
    if ([[self getColorForButtonType] isLightColor]) {
        [[color darkenColorByValue:0.12f] setFill];
    } else {
        [[color darkenColorByValue:0.20f] setFill];
    }
    
    NSRectFillUsingOperation(frame, NSCompositeSourceOver);
    [ctx restoreGraphicsState];
    
    
    
    //draw inner button area
    [ctx saveGraphicsState];
    
    NSBezierPath* bgPath = [NSBezierPath bezierPathWithRoundedRect:NSInsetRect(frame, 1.0f, 1.0f) xRadius:roundedRadius yRadius:roundedRadius];
    [bgPath setClip];
    
    NSColor* topColor = [color lightenColorByValue:0.12f];
    
    // gradient for inner portion of button
    NSGradient* bgGradient = [[NSGradient alloc] initWithColorsAndLocations:
                              topColor, 0.0f,
                              color, 1.0f,
                              nil];
    
    [bgGradient drawInRect:[bgPath bounds] angle:90.0f];
    
    [ctx restoreGraphicsState];
}

- (NSRect) drawTitle:(NSAttributedString *)title withFrame:(NSRect)frame inView:(NSView *)controlView {
    NSGraphicsContext* ctx = [NSGraphicsContext currentContext];
    
    [ctx saveGraphicsState];
    NSMutableAttributedString *attrString = [title mutableCopy];
    
    //Correct vertical placement

    CGSize stringSize = [attrString size];
    CGFloat titleHeight = stringSize.height;
    CGFloat vertOffset = (controlView.frame.size.height-titleHeight)/2;
    frame = NSMakeRect(frame.origin.x, vertOffset, frame.size.width, frame.size.height);
    
    [attrString beginEditing];
    NSColor *titleColor;
    BOOL drawShadow = NO;
    if ([[self getColorForButtonType] isLightColor]) {
        titleColor = [NSColor blackColor];
    } else {
        titleColor = [NSColor whiteColor];
        drawShadow = YES;
    }
    
    [attrString addAttribute:NSForegroundColorAttributeName value:titleColor range:NSMakeRange(0, [[self title] length])];
    [attrString endEditing];
    
    if(drawShadow){
        NSMutableAttributedString *attrString2 = [attrString mutableCopy];
        [attrString2 addAttribute:NSForegroundColorAttributeName value:[NSColor blackColor] range:NSMakeRange(0, [[self title] length])];
        [attrString2 endEditing];
        NSRect rect = NSOffsetRect(frame, 0.0f, 1.0f);
        [super drawTitle:attrString2 withFrame:rect inView:controlView];
    }
    
    NSRect r = [super drawTitle:attrString withFrame:frame inView:controlView];
    // Restore the graphics state
    [ctx restoreGraphicsState];
    
    return r;
}

@end
