//
//  LCRouter.m
//  LCGO
//
//  Created by 李伯坤 on 2018/3/29.
//  Copyright © 2018年 李伯坤. All rights reserved.
//

#import "LCRouter.h"
#import "LCRouterUrlDAO.h"
#import "TLWebViewController.h"

@implementation LCRouter

+ (LCRouter *)router
{
    static LCRouter *router;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        router = [[LCRouter alloc] init];
    });
    return router;
}

- (BOOL)canRouterUrl:(NSString *)url
{
    if ([url hasPrefix:@"lcgo://router"]) {
        return YES;
    }
    return NO;
}

- (BOOL)canOpenUrl:(NSString *)url
{
    if ([self canRouterUrl:url]) {
        return YES;
    }
    else if ([url hasPrefix:@"http"]) {
        return YES;
    }
    return NO;
}

- (BOOL)openUrl:(NSString *)url
{
    if (![self canOpenUrl:url]) {
        return NO;
    }
    
    if ([url hasPrefix:@"lcgo://"]) {
        LCRouterUrlDAO *urlDAO = [[LCRouterUrlDAO alloc] initWithUrl:url.toURL];
        return [urlDAO execute];
    }
    else if (url.toURL && [url containsString:@"target=safari"]) {
        [[UIApplication sharedApplication] openURL:url.toURL];
    }
    else {
        TLWebViewController *webVC = [[TLWebViewController alloc] initWithUrl:url];
        [self pushViewController:webVC animated:YES];
    }
    return YES;
}

- (void)presentViewController:(UIViewController *)viewControllerToPresent animated:(BOOL)animated completion:(void (^)(void))completion
{
    if (self.currentViewController) {
        [self.currentViewController presentViewController:viewControllerToPresent animated:animated completion:completion];
    }
}

- (void)pushViewController:(UIViewController *)viewController animated:(BOOL)animated
{
    if (self.currentNavigationController) {
        [self.currentNavigationController pushViewController:viewController animated:animated];
    }
}

#pragma mark - # Private Methods

- (UIViewController *)currentViewController
{
    __kindof UIViewController *vc = [UIApplication sharedApplication].keyWindow.visibleViewController;
    if ([vc isKindOfClass:[UINavigationController class]]) {
        return vc.childViewControllers.firstObject;
    }
    else if ([vc isKindOfClass:[UIViewController class]]) {
        return vc;
    }
    return nil;
}

- (UINavigationController *)currentNavigationController
{
    __kindof UIViewController *vc = [UIApplication sharedApplication].keyWindow.visibleViewController;
    if ([vc isKindOfClass:[UINavigationController class]]) {
        return vc;
    }
    else if (vc.navigationController) {
        return vc.navigationController;
    }
    return nil;
}

@end
