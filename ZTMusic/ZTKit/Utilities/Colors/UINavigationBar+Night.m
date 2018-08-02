//
//  UINavigationBar+Night.m
//  LCGO
//
//  Created by 李伯坤 on 2018/7/9.
//  Copyright © 2018年 李伯坤. All rights reserved.
//

#import "UINavigationBar+Night.h"
#import <objc/runtime.h>

@implementation UINavigationBar (ZTNight)

+ (void)load
{
    TLExchangeMethod(@selector(initWithFrame:), @selector(night_navbar_initWithFrame:));
}

- (instancetype)night_navbar_initWithFrame:(CGRect)frame
{
    UINavigationBar *obj = [self night_navbar_initWithFrame:frame];
    obj.dk_barTintColorPicker = DKColorPickerWithKey(WHITE);
    obj.dk_backgroundColorPicker = DKColorPickerWithKey(WHITE);
    obj.dk_tintColorPicker = DKColorPickerWithKey(TINT);
    obj.translucent = NO;
    return obj;
}

- (void)hiddenBottomLine
{
    UIImageView *navBarHairlineImageView = [self p_findHairlineImageViewUnder:self];
    [navBarHairlineImageView setHidden:YES];
}

- (UIImageView *)p_findHairlineImageViewUnder:(UIView *)view {
    if ([view isKindOfClass:UIImageView.class] && view.bounds.size.height <= 1.0) {
        return (UIImageView *)view;
    }
    for (UIView *subview in view.subviews) {
        UIImageView *imageView = [self p_findHairlineImageViewUnder:subview];
        if (imageView) {
            return imageView;
        }
    }
    return nil;
}

@end
