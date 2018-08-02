//
//  LCBaseRequest.h
//  LCGO
//
//  Created by 李伯坤 on 2018/3/9.
//  Copyright © 2018年 李伯坤. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef NS_ENUM(NSInteger, LCRequestMethod) {
    LCRequestMethodGet = 0,
    LCRequestMethodPost,
};

@interface LCBaseRequest : NSObject

@property (nonatomic, strong) NSString *url;
@property (nonatomic, assign) LCRequestMethod method;
@property (nonatomic, strong) NSDictionary *params;

+ (instancetype)createWithUrl:(NSString *)url method:(LCRequestMethod)method params:(NSDictionary *)params;

- (instancetype)initWithUrl:(NSString *)url method:(LCRequestMethod)method params:(NSDictionary *)params;


- (void)startRequestWithCompleteAction:(LCBlockComplete)completeAction;
- (void)startRequestWithResponseClass:(Class)responseClass completeAction:(LCBlockComplete)completeAction;
- (void)startRequestWithResponseClass:(Class)responseClass respDataKeyPathArray:(NSArray *)respDataKeyPathArray completeAction:(LCBlockComplete)completeAction;

- (void)startRequestWithResponseModel:(id)responseModel completeAction:(LCBlockComplete)completeAction;
- (void)startRequestWithResponseModel:(id)responseModel respDataKeyPathArray:(NSArray *)respDataKeyPathArray completeAction:(LCBlockComplete)completeAction;

@end
