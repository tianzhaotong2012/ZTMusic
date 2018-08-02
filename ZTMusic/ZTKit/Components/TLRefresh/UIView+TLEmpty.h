//
//  UIView+TLEmpty.h
//  TLChat
//
//  Created by lbk on 2017/7/23.
//  Copyright © 2017年 lbk. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIView (TLEmpty)

- (void)showEmptyViewWithTitle:(NSString *)title;

- (void)showErrorViewWithTitle:(NSString *)title retryAction:(void (^)(id userData))retryAction;
- (void)showErrorViewWithTitle:(NSString *)title userData:(id)userData retryAction:(void (^)(id userData))retryAction;

@end
