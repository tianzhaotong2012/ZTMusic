//
//  LCRouter+Register.m
//  LCGO
//
//  Created by 李伯坤 on 2018/7/5.
//  Copyright © 2018年 李伯坤. All rights reserved.
//

#import "LCRouter+Register.h"

@implementation LCRouter (Register)

+ (BOOL)registerNodeWithTradeline:(NSString *)tradeline pageName:(NSString *)pageName eventName:(NSString *)eventName eventAction:(LCRouterEventAction)eventAction
{
    return [self registerNodeWithHost:HOST_ROUTER Tradeline:tradeline pageName:pageName eventName:eventName eventAction:eventAction];
}

+ (BOOL)registerNodeWithHost:(NSString *)host Tradeline:(NSString *)tradeline pageName:(NSString *)pageName eventName:(NSString *)eventName eventAction:(LCRouterEventAction)eventAction
{
    if (tradeline.length == 0) {
        tradeline = TRADELINE_CORE;
    }
    if (eventName.length == 0) {
        eventName = EVENT_ROUTER;
    }
    if (host.length == 0 || pageName.length == 0 || !eventAction) {
        return NO;
    }
    
    NSString *className = [NSString stringWithFormat:@"%@_%@_%@", host, tradeline, pageName];
    Class actionClass = NSClassFromString(className);
    
    // 创建action类
    if (!actionClass) {
        actionClass = objc_allocateClassPair([NSObject class], className.UTF8String, 0);
        objc_registerClassPair(actionClass);
    }
    
    // 添加event方法
    eventName = [eventName hasSuffix:@":"] ? eventName : [eventName stringByAppendingString:@":"];
    SEL eventSEL = NSSelectorFromString(eventName);
    if (!class_getInstanceMethod(actionClass, eventSEL)) {
        IMP imp = imp_implementationWithBlock(^ (id model, SEL _cmd, NSMutableDictionary *params){
            if (eventAction) {
                LCRouterUrlDAO *urlDAO = [params objectForKey:@"urlDAO"];
                [params removeObjectForKey:@"urlDAO"];
                eventAction([LCRouter router], urlDAO, params);
            }
        });
        class_addMethod(actionClass, eventSEL, imp, "@@:");
    }
    
    return YES;
}

@end
