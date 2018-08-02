//
//  UIScrollView+TLRefreshHeader.m
//  TLChat
//
//  Created by 李伯坤 on 2017/7/21.
//  Copyright © 2017年 李伯坤. All rights reserved.
//

#import "UIScrollView+TLRefreshHeader.h"
#import "LCRefreshHeader.h"

@implementation UIScrollView (TLRefreshHeader)

- (void)tt_addRefreshHeaderWithAction:(void (^)())refreshAction
{
    LCRefreshHeader *header = [LCRefreshHeader headerWithRefreshingBlock:refreshAction];
    [self setMj_header:header];
}

- (void)tt_beginRefreshing
{
    [self.mj_header beginRefreshing];
}

- (void)tt_endRefreshing
{
    [self.mj_header endRefreshing];
}

- (void)tt_removeRefreshHeader
{
    [self setMj_header:nil];
}

@end
