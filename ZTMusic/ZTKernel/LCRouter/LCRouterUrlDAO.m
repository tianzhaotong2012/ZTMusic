//
//  LCRouterUrlDAO.m
//  LCGO
//
//  Created by 李伯坤 on 2018/7/5.
//  Copyright © 2018年 李伯坤. All rights reserved.
//

#import "LCRouterUrlDAO.h"

@implementation LCRouterUrlDAO
@synthesize url = _url;

- (instancetype)initWithUrl:(NSURL *)url
{
    if (self = [super init]) {
        self.url = url;
    }
    return self;
}

- (void)setUrl:(NSURL *)url
{
    _url = url;
    
    self.host = url.host;
    
    // 路径
    NSString *path = url.path;
    if ([path hasPrefix:@"/"]) {
        path = [path substringFromIndex:1];
    }
    
    NSArray *pathComponents = [path pathComponents];
    if (pathComponents.count >= 3) {
        self.tradeLine = pathComponents[0];
        self.pageName = pathComponents[1];
        self.eventName = pathComponents[2];
    }
    else if (pathComponents.count == 2) {
        self.tradeLine = TRADELINE_CORE;
        self.pageName = pathComponents[0];
        self.eventName = pathComponents[1];
    }
    else if (pathComponents.count == 1) {
        self.tradeLine = TRADELINE_CORE;
        self.pageName = pathComponents[0];
        self.eventName = EVENT_ROUTER;
    }
 
    // 参数
    self.params = url.parameters;
}

- (NSURL *)toRouterUrl
{
    if (!self.tradeLine || !self.params || !self.eventName) {
        return nil;
    }
    NSString *urlString = [NSString stringWithFormat:@"lcgo://%@/%@/%@/%@?",
                           self.host ? self.host : HOST_ROUTER,
                           self.tradeLine ? self.tradeLine : TRADELINE_CORE,
                           self.pageName,
                           self.eventName];
    
    NSMutableString *paramsString = [NSMutableString string];
    [self.params enumerateKeysAndObjectsUsingBlock:^(NSString *key, NSString *value, BOOL * _Nonnull stop) {
        if (paramsString.length > 0) {
            [paramsString appendString:@"&"];
        }
        [paramsString appendFormat:@"%@=%@", key, [value urlEncode]];
    }];
    urlString = [urlString stringByAppendingString:paramsString];
    
    NSURL *url = [NSURL URLWithString:urlString];
    return url;
}

- (BOOL)execute
{
    if ([self.host isEqualToString:HOST_ROUTER]) {
        // 类
        NSString *targetName = [NSString stringWithFormat:@"%@_%@_%@", HOST_ROUTER, self.tradeLine, self.pageName];
        Class targetClass = NSClassFromString(targetName);
        if (!targetClass) {
            return NO;
        }
        id target = [[targetClass alloc] init];
        
        // 方法
        NSString *actionName = [self.eventName hasSuffix:@":"] ? self.eventName : [self.eventName stringByAppendingString:@":"];
        SEL action = NSSelectorFromString(actionName);
        
        // 参数
        NSMutableDictionary *params = [[NSMutableDictionary alloc] init];
        [self.params enumerateKeysAndObjectsUsingBlock:^(NSString *key, NSString *value, BOOL * _Nonnull stop) {
            [params setObject:[value urlDecode] forKey:key];
        }];
        [params setObject:self forKey:@"urlDAO"];
        
        if ([target respondsToSelector:action]) {
#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Warc-performSelector-leaks"
            [target performSelector:action withObject:params];
#pragma clang diagnostic pop
            return YES;
        }
    }
   
    return NO;
}

@end
