//
//  LCRouter.h
//  LCGO
//
//  Created by lbk on 2018/3/29.
//  Copyright © 2018年 lbk. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface LCRouter : NSObject

+ (LCRouter *)router;

/**
 * 是否可路由url
 */
- (BOOL)canRouterUrl:(NSString *)url;

/**
 * 是否可打开url，包含路由url和网络url
 */
- (BOOL)canOpenUrl:(NSString *)url;

/**
 * 打开url
 */
- (BOOL)openUrl:(NSString *)url;

/**
 * Push
 */
- (void)pushViewController:(UIViewController *)viewController animated:(BOOL)animated;

/**
 * Present
 */
- (void)presentViewController:(UIViewController *)viewControllerToPresent animated:(BOOL)animated completion:(void (^)(void))completion;

@end
