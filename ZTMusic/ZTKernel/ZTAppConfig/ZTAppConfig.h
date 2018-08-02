//
//  ZTAppConfig.h
//  ZTMusic
//
//  Created by 李伯坤 on 2018/7/31.
//  Copyright © 2018年 李伯坤. All rights reserved.
//

#import <Foundation/Foundation.h>

void __lc_setInfo(NSString *key, id value);
id __lc_getInfo(NSString *key);

@interface ZTAppConfig : NSObject

/// 夜间模式
@property (nonatomic, assign) BOOL night;

+ (ZTAppConfig *)sharedInstance;

- (void)reset;

@end
