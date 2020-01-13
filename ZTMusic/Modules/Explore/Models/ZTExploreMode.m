//
//  ZTExploreMode.m
//  zhuanzhuan
//
//  Created by ZZUIHelper on 2020/1/13.
//  Copyright © 2017年 ZZUIHelper. All rights reserved.
//

#import "ZTExploreMode.h"

@implementation ZTExploreMode
+ (NSDictionary *)mj_objectClassInArray
{
    return @{@"songs" : @"ZTSongModel",
             @"artists" : @"ZTArtistModel",
             };
}

+ (void)requestWithCompleteAction:(LCBlockComplete)completeAction
{
    ZTRequest *request = [ZTRequest createWithModule:@"load_explore_page_json" params:nil];
    [request startRequestWithResponseClass:self completeAction:completeAction];
}
@end
