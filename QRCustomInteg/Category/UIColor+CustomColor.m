//
//  UIColor+CustomColor.m
//  Demo0328
//
//  Created by 李萍 on 2018/3/28.
//  Copyright © 2018年 李萍. All rights reserved.
//

#import "UIColor+CustomColor.h"

@implementation UIColor (CustomColor)

+ (UIColor *)colorWithHex:(int)hexValue alpha:(CGFloat)alpha
{
    return [UIColor colorWithRed:((float)((hexValue & 0xFF0000) >> 16))/255.0
                           green:((float)((hexValue & 0xFF00) >> 8))/255.0
                            blue:((float)(hexValue & 0xFF))/255.0
                           alpha:alpha];
}

+ (UIColor *)colorWithHex:(int)hexValue
{
    return [UIColor colorWithHex:hexValue alpha:1.0];
}

+ (UIColor *)ThemeColor
{
    return [UIColor colorWithHex:0xb1d85c alpha:1.0];
}

+ (UIColor *)TextColor
{
    return [UIColor colorWithHex:0xFF8247 alpha:1.0];
}

@end
