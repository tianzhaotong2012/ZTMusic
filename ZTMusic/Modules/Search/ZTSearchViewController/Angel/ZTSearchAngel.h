//
//  ZTSearchAngel.h
//  ZTMusic
//
//  Created by 李伯坤 on 2018/8/2.
//  Copyright © 2018年 李伯坤. All rights reserved.
//

#import "ZZFLEXAngel.h"

@interface ZTSearchAngel : ZZFLEXAngel

- (instancetype)initWithHostView:(__kindof UIScrollView *)hostView searchAction:(void (^)(NSString *word))searchAction;

/**
 * 请求热搜模块
 */
- (void)requestHotSearchModuleWithCompleteAction:(LCBlockComplete)completeAction;

/**
 * 加载记录模块
 */
- (void)loadHistorySearchModule;

@end
