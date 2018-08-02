//
//  ZTRequest.h
//  ZTMusic
//
//  Created by 李伯坤 on 2018/7/31.
//  Copyright © 2018年 李伯坤. All rights reserved.
//

#import "LCBaseRequest.h"

@interface ZTRequest : LCBaseRequest

+ (instancetype)createWithModule:(NSString *)module params:(NSDictionary *)params;
+ (instancetype)createWithModule:(NSString *)module method:(LCRequestMethod)method params:(NSDictionary *)params;

- (instancetype)initWithModule:(NSString *)module params:(NSDictionary *)params;
- (instancetype)initWithModule:(NSString *)module method:(LCRequestMethod)method params:(NSDictionary *)params;

@end
