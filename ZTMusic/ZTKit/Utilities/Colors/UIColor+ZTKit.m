//
//  UIColor+ZTKit.m
//  ZTMusic
//
//  Created by 李伯坤 on 2018/7/31.
//  Copyright © 2018年 李伯坤. All rights reserved.
//

#import "UIColor+ZTKit.h"

@implementation UIColor (ZTKit)

#pragma mark - # 灰色
+ (UIColor *)colorGrayBG {
    return RGBAColor(240.0, 239.0, 245.0, 1.0);
}

+ (UIColor *)colorGrayForSeperator {
    return [UIColor colorWithWhite:0.5 alpha:0.3];
}

#pragma mark - # 绿色
+ (UIColor *)colorGreen {
    return RGBAColor(2.0, 187.0, 0.0, 1.0f);
}

+ (UIColor *)colorGreenHL {
    return RGBAColor(46, 139, 46, 1.0f);
}

#pragma mark - # 红色
+ (UIColor *)colorPink
{
    return HexColor(0xee325b);
}

+ (UIColor *)colorRed {
    return RGBColor(228, 68, 71);
}

+ (UIColor *)colorRedHL {
    return RGBColor(205, 62, 64);
}

#pragma mark - # 蓝色
+ (UIColor *)colorBlue
{
    return RGBAColor(74.0, 99.0, 141.0, 1.0);
}

@end
