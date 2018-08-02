//
//  LCBaseRequest.m
//  LCGO
//
//  Created by lbk on 2018/3/9.
//  Copyright © 2018年 lbk. All rights reserved.
//

#import "LCBaseRequest.h"
#import <AFNetworking/AFNetworking.h>
#import <MJExtension/MJExtension.h>

@interface LCBaseRequest ()

@property (nonatomic, strong) AFHTTPSessionManager *manager;

@end

@implementation LCBaseRequest

+ (instancetype)createWithUrl:(NSString *)url method:(LCRequestMethod)method params:(NSDictionary *)params
{
    LCBaseRequest *request = [[LCBaseRequest alloc] initWithUrl:url method:method params:params];
    return request;
}

- (instancetype)initWithUrl:(NSString *)url method:(LCRequestMethod)method params:(NSDictionary *)params
{
    if (self = [self init]) {
        self.url = url;
        self.method = method;
        self.params = params;
    }
    return self;
}


- (void)startRequestWithCompleteAction:(LCBlockComplete)completeAction
{
    [self startRequestWithResponseClass:nil completeAction:completeAction];
}

- (void)startRequestWithResponseClass:(Class)responseClass completeAction:(LCBlockComplete)completeAction
{
    [self startRequestWithResponseClass:responseClass respDataKeyPathArray:nil completeAction:completeAction];
}

- (void)startRequestWithResponseClass:(Class)responseClass respDataKeyPathArray:(NSArray *)respDataKeyPathArray completeAction:(LCBlockComplete)completeAction
{
    void (^success)(NSURLSessionDataTask *, id) = ^(NSURLSessionDataTask *task, NSDictionary *respObject) {
        if (!completeAction) {
            return;
        }
        if ([respObject[@"errNo"] integerValue] == 0) {
            NSDictionary *jsonData = respObject[@"data"];
            if (respDataKeyPathArray.count > 0) {
                for (NSString *key in respDataKeyPathArray) {
                    if (key && jsonData && [jsonData isKindOfClass:[NSDictionary class]]) {
                        jsonData = [jsonData objectForKey:key];
                    }
                }
            }
            
            if (responseClass) {
                id data;
                if ([jsonData isKindOfClass:[NSArray class]]) {
                    data = [responseClass mj_objectArrayWithKeyValuesArray:jsonData];
                }
                else if ([jsonData isKindOfClass:[NSDictionary class]]){
                    data = [responseClass mj_objectWithKeyValues:jsonData];
                }
                else {
                    data = jsonData;
                }
                completeAction(YES, data);
            }
            else {
                completeAction(YES, jsonData);
            }
        }
        else {
            NSString *errMsg = respObject[@"errMsg"];
            NSLog(@"【ERROR】【Network】网络请求失败：%@", errMsg);
            completeAction(NO, errMsg);
        }
    };
    
    void (^failure)(NSURLSessionDataTask *, NSError *) = ^(NSURLSessionDataTask *task, NSError *error) {
        if (completeAction) {
            completeAction(NO, @"网络请求失败");
        }
    };
    
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    {
        manager.operationQueue.maxConcurrentOperationCount = 200;
        manager.requestSerializer = [AFHTTPRequestSerializer serializer];
        manager.responseSerializer = [AFJSONResponseSerializer serializer];
        manager.responseSerializer.acceptableContentTypes = [NSSet setWithObjects:@"application/json", @"text/json", @"text/javascript", @"text/html", @"text/plain", nil];
        [manager.requestSerializer setValue:@"application/json" forHTTPHeaderField:@"Accept"];
    }
    NSDictionary *params = self.params;
    NSString *url = self.url;
    
    if (self.method == LCRequestMethodGet) {
        [manager GET:url parameters:params progress:nil success:success failure:failure];
    }
    else if (self.method == LCRequestMethodPost){
        [manager POST:url parameters:params progress:nil success:success failure:failure];
    }
}

- (void)startRequestWithResponseModel:(id)responseModel completeAction:(LCBlockComplete)completeAction
{
    [self startRequestWithResponseModel:responseModel respDataKeyPathArray:nil completeAction:completeAction];
}

- (void)startRequestWithResponseModel:(id)responseModel respDataKeyPathArray:(NSArray *)respDataKeyPathArray completeAction:(LCBlockComplete)completeAction
{
    void (^success)(NSURLSessionDataTask *, id) = ^(NSURLSessionDataTask *task, NSDictionary *respObject) {
        if (!completeAction) {
            return;
        }
        if ([respObject[@"errNo"] integerValue] == 0) {
            NSDictionary *jsonData = respObject[@"data"];
            if (respDataKeyPathArray.count > 0) {
                for (NSString *key in respDataKeyPathArray) {
                    if (key && jsonData && [jsonData isKindOfClass:[NSDictionary class]]) {
                        jsonData = [jsonData objectForKey:key];
                    }
                }
            }
            
            if (responseModel && [jsonData isKindOfClass:[NSDictionary class]]){
                [responseModel mj_setKeyValues:jsonData];;
                completeAction(YES, responseModel);
            }
            else {
                completeAction(YES, jsonData);
            }
        }
        else {
            NSString *errMsg = respObject[@"errMsg"];
            NSLog(@"【ERROR】【Network】网络请求失败：%@", errMsg);
            completeAction(NO, errMsg);
        }
    };
    
    void (^failure)(NSURLSessionDataTask *, NSError *) = ^(NSURLSessionDataTask *task, NSError *error) {
        if (completeAction) {
            completeAction(NO, @"网络请求失败");
        }
    };
    
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    {
        manager.requestSerializer = [AFHTTPRequestSerializer serializer];
        manager.responseSerializer = [AFJSONResponseSerializer serializer];
        manager.responseSerializer.acceptableContentTypes = [NSSet setWithObjects:@"application/json", @"text/json", @"text/javascript", @"text/html", @"text/plain", nil];
        [manager.requestSerializer setValue:@"application/json" forHTTPHeaderField:@"Accept"];
    }
    NSDictionary *params = self.params;
    NSString *url = self.url;
    
    if (self.method == LCRequestMethodGet) {
        [manager GET:url parameters:params progress:nil success:success failure:failure];
    }
    else if (self.method == LCRequestMethodPost){
        [manager POST:url parameters:params progress:nil success:success failure:failure];
    }
}


@end
