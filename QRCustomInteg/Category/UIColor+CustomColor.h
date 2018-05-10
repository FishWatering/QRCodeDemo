//
//  UIColor+CustomColor.h
//  Demo0328
//
//  Created by 李萍 on 2018/3/28.
//  Copyright © 2018年 李萍. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIColor (CustomColor)

+ (UIColor *)colorWithHex:(int)hexValue alpha:(CGFloat)alpha;
+ (UIColor *)colorWithHex:(int)hexValue;

+ (UIColor *)ThemeColor;
+ (UIColor *)TextColor;

@end
