//
//  LCRouter+Register.h
//  LCGO
//
//  Created by 李伯坤 on 2018/7/5.
//  Copyright © 2018年 李伯坤. All rights reserved.
//

#import "LCRouter.h"
#import "LCRouterUrlDAO.h"

#define     HOST_ROUTER             @"router"
#define     TRADELINE_CORE          @"core"
#define     EVENT_ROUTER            @"routerEvent"

typedef void (^LCRouterEventAction)(LCRouter *router, LCRouterUrlDAO *urlDAO, NSDictionary *params);

@interface LCRouter (Register)

/**
 *  注册普通路由节点
 *
 *  @param tradeline    业务线名称
 *  @param pageName     页面名称
 *  @param eventName    路由事件名称
 *  @param eventAction  路由事件
 */
+ (BOOL)registerNodeWithTradeline:(NSString *)tradeline
                         pageName:(NSString *)pageName
                        eventName:(NSString *)eventName
                      eventAction:(LCRouterEventAction)eventAction;

/**
 *  注册节点
 *
 *  @param host         域名
 *  @param tradeline    业务线名称
 *  @param pageName     页面名称
 *  @param eventName    路由事件名称
 *  @param eventAction  路由事件
 */
+ (BOOL)registerNodeWithHost:(NSString *)host
                   Tradeline:(NSString *)tradeline
                    pageName:(NSString *)pageName
                   eventName:(NSString *)eventName
                 eventAction:(LCRouterEventAction)eventAction;

@end
