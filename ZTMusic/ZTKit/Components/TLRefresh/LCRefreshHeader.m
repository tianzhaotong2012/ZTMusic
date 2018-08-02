//
//  LCRefreshHeader.m
//  LCGO
//
//  Created by 李伯坤 on 2018/6/14.
//  Copyright © 2018年 李伯坤. All rights reserved.
//

#import "LCRefreshHeader.h"

@interface LCRefreshHeader ()

@property (nonatomic, strong) UIImageView *arrowView;

@property (nonatomic, strong) UILabel *stateLabel;

@property (nonatomic, strong) UIActivityIndicatorView *loadingView;

@end

@implementation LCRefreshHeader

- (void)prepare
{
    [super prepare];

    [self addSubview:_stateLabel = [UILabel mj_label]];
    [self addSubview:_arrowView = [[UIImageView alloc] initWithImage:[NSBundle mj_arrowImage]]];
    [self addSubview:_loadingView = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleGray]];
    self.arrowView.mj_size = self.arrowView.image.size;
    self.arrowView.tintColor = self.stateLabel.textColor;
    self.stateLabel.frame = self.bounds;
}

- (void)placeSubviews
{
    [super placeSubviews];
    
    CGFloat arrowCenterX = (self.mj_w - self.stateLabel.mj_textWith) / 2 - 25;
    CGPoint arrowCenter = CGPointMake(arrowCenterX, self.mj_h * 0.5);
    [UIView performWithoutAnimation:^{
        self.loadingView.center = self.arrowView.center = arrowCenter;
    }];
}

- (void)setState:(MJRefreshState)state
{
    MJRefreshCheckState
    if (state == MJRefreshStateIdle) {
        if (oldState == MJRefreshStateRefreshing) {
            self.arrowView.transform = CGAffineTransformIdentity;
            [self.loadingView stopAnimating];
            self.stateLabel.text = @"刷新完成";
            [UIView animateWithDuration:MJRefreshSlowAnimationDuration animations:^{
                self.loadingView.alpha = 0.0;
            } completion:^(BOOL finished) {
                
                // 如果执行完动画发现不是idle状态，就直接返回，进入其他状态
                if (self.state != MJRefreshStateIdle) return;
                
                self.stateLabel.text = @"下拉刷新";
                self.loadingView.alpha = 1.0;
                self.arrowView.hidden = NO;
            }];
        }
        else {
            self.stateLabel.text = @"下拉刷新";
            [self.loadingView stopAnimating];
            self.arrowView.hidden = NO;
            [UIView animateWithDuration:MJRefreshFastAnimationDuration animations:^{
                self.arrowView.transform = CGAffineTransformIdentity;
            }];
        }
    }
    else if (state == MJRefreshStatePulling) {
        self.stateLabel.text = @"松开刷新";
        [self.loadingView stopAnimating];
        self.arrowView.hidden = NO;
        [UIView animateWithDuration:MJRefreshFastAnimationDuration animations:^{
            self.arrowView.transform = CGAffineTransformMakeRotation(0.000001 - M_PI);
        }];
    }
    else if (state == MJRefreshStateRefreshing) {
        self.stateLabel.text = @"正在刷新...";
        self.loadingView.alpha = 1.0; // 防止refreshing -> idle的动画完毕动作没有被执行
        [self.loadingView startAnimating];
        self.arrowView.hidden = YES;
    }
}

@end
