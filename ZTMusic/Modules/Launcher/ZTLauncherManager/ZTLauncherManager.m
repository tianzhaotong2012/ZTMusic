//
//  ZTLauncherManager.m
//  ZTMusic
//
//  Created by 李伯坤 on 2018/7/30.
//  Copyright © 2018年 李伯坤. All rights reserved.
//

#import "ZTLauncherManager.h"
//#import <LNPopupController/LNPopupController.h>
#import "LNPopupController.h"
#import "ZTAppConfig.h"

#import "ZTMusicPlayViewController.h"
#import "ZTExploreViewController.h"
#import "ZTLibraryViewController.h"
#import "ZTSearchViewController.h"

@implementation ZTLauncherManager

+ (ZTLauncherManager *)sharedInstance
{
    static ZTLauncherManager *rootVCManager;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        rootVCManager = [[self alloc] init];
    });
    return rootVCManager;
}

- (void)launchInWindow:(UIWindow *)window
{
    @weakify(self);
    NSLog(@"【Launcher】开始加载根控制器");
    
    [[UINavigationBar appearance] setShadowImage:[UIImage new]];
    [[UINavigationBar appearance] setTitleTextAttributes:@{NSFontAttributeName : [UIFont boldSystemFontOfSize:17], NSForegroundColorAttributeName : [ZTAppConfig sharedInstance].night ? HexColor(0xeeeeee) : [UIColor blackColor]}];
    [[UIBarButtonItem appearance] setTitleTextAttributes:@{NSFontAttributeName : [UIFont boldSystemFontOfSize:16]} forState:UIControlStateNormal];
    
    [[UITabBar appearance] setShadowImage:[UIImage new]];
    [[UITabBar appearance] setBackgroundImage:[UIImage new]];
    [[UITabBarItem appearance] setTitleTextAttributes:@{NSFontAttributeName : [UIFont boldSystemFontOfSize:11]} forState:UIControlStateNormal];
    
    [self p_showRootTabBarControllerInWindow:window];
}

- (void)relaunch
{
    [self launchInWindow:[UIApplication sharedApplication].keyWindow];
}

- (BOOL)jumpToTabPage:(ZTTabPage)tabPage
{
    UITabBarController *tabBarController = (UITabBarController *)[UIApplication sharedApplication].keyWindow.rootViewController;
    if ([tabBarController isKindOfClass:[UITabBarController class]]) {
        [tabBarController setSelectedIndex:tabPage];
        return YES;
    }
    return NO;
}

- (void)dealloc
{
    [NSObject cancelPreviousPerformRequestsWithTarget:self];
}

#pragma mark - # Private Methods
- (void)p_showRootTabBarControllerInWindow:(UIWindow *)window
{
    NSLog(@"【Launcher】显示根TabVC");
    [window removeAllSubviews];
    
    UITabBarController *vc = [self rootTabBarController];
    [window setRootViewController:vc];
    [window addSubview:vc.view];
    [window makeKeyAndVisible];
}

#pragma mark - # Getters
- (UITabBarController *)rootTabBarController
{
    UINavigationController *(^createItemVC)(Class vcClass, NSString *title, NSString *image, NSString *imageSelected) = ^UINavigationController *(Class vcClass, NSString *title, NSString *image, NSString *imageSelected) {
        __kindof UIViewController *vc = [[vcClass alloc] init];
        [vc.tabBarItem setTitle:LOCSTR(title)];
        [vc.tabBarItem setImage:TLImage(image)];
        [vc.tabBarItem setSelectedImage:TLImage(imageSelected)];
        UINavigationController *navController = [[UINavigationController alloc] initWithRootViewController:vc];
        [navController.view setBackgroundColor:[UIColor whiteColor]];
        if (@available(iOS 11.0, *)) {
            [navController.navigationBar setLargeTitleTextAttributes:@{NSFontAttributeName : [UIFont boldSystemFontOfSize:35],
                                                                       NSForegroundColorAttributeName : [ZTAppConfig sharedInstance].night ? HexColor(0xeeeeee) : [UIColor blackColor]
                                                                       }];
            [navController.navigationBar setPrefersLargeTitles:YES];
        }
        
        return navController;
    };
    
    NSMutableArray *vcArray = [[NSMutableArray alloc] init];
//    [vcArray addObject:createItemVC([ZTLibraryViewController class], @"资料库", @"tabbar_library", @"tabbar_library")];
//    [vcArray addObject:createItemVC([ZTSearchViewController class], @"喜欢", @"tabbar_favorite", @"tabbar_favorite")];
    [vcArray addObject:createItemVC([ZTExploreViewController class], @"发现", @"tabbar_explore", @"tabbar_explore")];
    [vcArray addObject:createItemVC([ZTSearchViewController class], @"搜索", @"tabbar_search", @"tabbar_search")];
    
    UITabBarController *tabBarController = [[UITabBarController alloc] init];
    tabBarController.tabBar.dk_barTintColorPicker = DKColorPickerWithKey(WHITE);
    tabBarController.tabBar.dk_backgroundColorPicker = DKColorPickerWithKey(WHITE);
    tabBarController.tabBar.dk_tintColorPicker = DKColorPickerWithKey(TINT);
    [tabBarController setViewControllers:vcArray];
    
    [tabBarController presentPopupBarWithContentViewController:[ZTMusicPlayViewController sharedInstance] animated:YES completion:nil];
    
    
    return tabBarController;
}

@end
