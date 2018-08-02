//
//  UIScrollView+TLLoadMoreFooter.h
//  TLChat
//
//  Created by lbk on 2017/7/21.
//  Copyright © 2017年 lbk. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIScrollView (TLLoadMoreFooter)

- (void)tt_addLoadMoreFooterWithAction:(void (^)(void))loadMoreAction;
- (void)tt_beginLoadMore;
- (void)tt_endLoadMore;
- (void)tt_showNoMoreFooter;
- (void)tt_showNoMoreFooterWithTitle:(NSString *)title;
- (void)tt_removeLoadMoreFooter;

@end
