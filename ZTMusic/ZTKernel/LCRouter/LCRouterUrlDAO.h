//
//  LCRouterUrlDAO.h
//  LCGO
//
//  Created by 李伯坤 on 2018/7/5.
//  Copyright © 2018年 李伯坤. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface LCRouterUrlDAO : NSObject

@property (nonatomic, strong, readonly) NSURL *url;

@property (nonatomic, strong) NSString *host;

@property (nonatomic, strong) NSString *tradeLine;

@property (nonatomic, strong) NSString *pageName;

@property (nonatomic, strong) NSString *eventName;

@property (nonatomic, strong) NSDictionary *params;

- (instancetype)initWithUrl:(NSURL *)url;

- (NSURL *)toRouterUrl;

- (BOOL)execute;

@end
