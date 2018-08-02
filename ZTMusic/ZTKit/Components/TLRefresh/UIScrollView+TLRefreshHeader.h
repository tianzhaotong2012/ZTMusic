//
//  UIScrollView+TLRefreshHeader.h
//  TLChat
//
//  Created by lbk on 2017/7/21.
//  Copyright © 2017年 lbk. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIScrollView (TLRefreshHeader)

- (void)tt_addRefreshHeaderWithAction:(void (^)())refreshAction;
- (void)tt_beginRefreshing;
- (void)tt_endRefreshing;
- (void)tt_removeRefreshHeader;

@end
