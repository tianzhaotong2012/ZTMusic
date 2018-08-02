//
//  ZTLauncherManager.h
//  ZTMusic
//
//  Created by 李伯坤 on 2018/7/30.
//  Copyright © 2018年 李伯坤. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef NS_ENUM(NSInteger, ZTTabPage) {
    ZTTabPageMarket = 0,
    ZTTabPageBreed,
    ZTTabPageHome,
    ZTTabPageTrade,
    ZTTabPageAccount,
};

@interface ZTLauncherManager : NSObject

+ (ZTLauncherManager *)sharedInstance;

/**
 *  启动，初始化
 */
- (void)launchInWindow:(UIWindow *)window;

- (void)relaunch;

- (instancetype)init NS_UNAVAILABLE;

- (BOOL)jumpToTabPage:(ZTTabPage)tabPage;

@end
