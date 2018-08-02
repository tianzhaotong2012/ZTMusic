//
//  ZTRequest.m
//  ZTMusic
//
//  Created by 李伯坤 on 2018/7/31.
//  Copyright © 2018年 李伯坤. All rights reserved.
//

#import "ZTRequest.h"

@implementation ZTRequest

+ (instancetype)createWithModule:(NSString *)module params:(NSDictionary *)params
{
    return [ZTRequest createWithModule:module method:LCRequestMethodPost params:params];
}

+ (instancetype)createWithModule:(NSString *)module method:(LCRequestMethod)method params:(NSDictionary *)params
{
    return [[ZTRequest alloc] initWithModule:module method:method params:params];
}

- (instancetype)initWithModule:(NSString *)module params:(NSDictionary *)params
{
    return [self initWithModule:module method:LCRequestMethodPost params:params];
}

- (instancetype)initWithModule:(NSString *)module method:(LCRequestMethod)method params:(NSDictionary *)params
{
    NSString *url = @"http://www.musicleft.com/wp-admin/admin-ajax.php";
    NSMutableDictionary *dic = params ? params.mutableCopy : @{}.mutableCopy;
    [dic setObject:TLNoNilString(module) forKey:@"action"];
    return [self initWithUrl:url method:method params:dic];
}


@end
