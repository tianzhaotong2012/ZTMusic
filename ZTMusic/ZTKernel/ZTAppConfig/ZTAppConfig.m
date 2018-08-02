//
//  ZTAppConfig.m
//  ZTMusic
//
//  Created by 李伯坤 on 2018/7/31.
//  Copyright © 2018年 李伯坤. All rights reserved.
//

#import "ZTAppConfig.h"

void __lc_setInfo(NSString *key, id value) {
    if (value) {
        [[NSUserDefaults standardUserDefaults] setObject:value forKey:key];
    }
    else {
        [[NSUserDefaults standardUserDefaults] removeObjectForKey:key];
    }
}

id __lc_getInfo(NSString *key) {
    return [[NSUserDefaults standardUserDefaults] objectForKey:key];
}

#define     __method_bool(setter, getter, key, default)           \
- (void)setter:(BOOL)value  {           \
__lc_setInfo(key, @(value));     \
}               \
- (BOOL)getter {      \
NSNumber *number = __lc_getInfo(key);     \
return number ? number.boolValue : default;     \
}

#define     __method_int(setter, getter, key, default)           \
- (void)setter:(NSInteger)value  {           \
__lc_setInfo(key, @(value));     \
}               \
- (NSInteger)getter {      \
NSNumber *number = __lc_getInfo(key);     \
return number ? number.integerValue : default;     \
}

#define     __method_double(setter, getter, key, default)           \
- (void)setter:(CGFloat)value  {           \
__lc_setInfo(key, @(value));     \
}               \
- (CGFloat)getter {      \
NSNumber *number = __lc_getInfo(key);     \
return number ? number.doubleValue : default;     \
}

#define     __method_string(setter, getter, key, default)           \
- (void)setter:(NSString *)value  {           \
__lc_setInfo(key,value);     \
}               \
- (NSString *)getter {      \
NSString *str = __lc_getInfo(key);     \
return str ? str : default;     \
}

@implementation ZTAppConfig

+ (ZTAppConfig *)sharedInstance
{
    static ZTAppConfig *appConfig;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        appConfig = [[ZTAppConfig alloc] init];
    });
    return appConfig;
}

- (void)reset
{
    
}

#pragma mark - # APP
/// 夜间模式
__method_bool(setNight, night, @"night", NO)

@end
