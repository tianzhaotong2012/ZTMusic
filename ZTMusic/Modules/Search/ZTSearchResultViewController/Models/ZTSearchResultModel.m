//
//  ZTSearchResultModel.m
//  ZTMusic
//
//  Created by 李伯坤 on 2018/8/6.
//  Copyright © 2018年 李伯坤. All rights reserved.
//

#import "ZTSearchResultModel.h"

@implementation ZTSearchResultModel : NSObject 

+ (NSDictionary *)mj_objectClassInArray
{
    return @{@"songs" : @"ZTSongModel",
             @"artists" : @"ZTArtistModel",
             };
}

+ (void)requestWithKeyword:(NSString *)keyword completeAction:(LCBlockComplete)completeAction
{
    ZTRequest *request = [ZTRequest createWithModule:@"load_search_results_json" params:@{@"query" : TLNoNilString(keyword)}];
    [request startRequestWithResponseClass:self completeAction:completeAction];
}

@end
