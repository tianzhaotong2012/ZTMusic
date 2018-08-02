//
//  UIViewController+Night.m
//  LCGO
//
//  Created by 李伯坤 on 2018/7/9.
//  Copyright © 2018年 李伯坤. All rights reserved.
//

#import "UIViewController+Night.h"

@implementation UIViewController (Night)

+ (void)load
{
    TLExchangeMethod(@selector(init), @selector(night_vc_init));
}

- (instancetype)night_vc_init
{
    UIViewController *obj = [self night_vc_init];
    obj.extendedLayoutIncludesOpaqueBars = YES;
    return obj;
}


@end
