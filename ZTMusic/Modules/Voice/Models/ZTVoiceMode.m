//
//  ZTExploreMode.m
//  zhuanzhuan
//
//  Created by ZZUIHelper on 2020/1/13.
//  Copyright © 2017年 ZZUIHelper. All rights reserved.
//

#import "ZTVoiceMode.h"

@implementation ZTVoiceMode
+ (NSDictionary *)mj_objectClassInArray
{
    return @{@"songs" : @"ZTSongModel",
             @"artists" : @"ZTArtistModel",
             };
}

+ (void)requestWithCompleteAction:(LCBlockComplete)completeAction
{
    ZTRequest *request = [ZTRequest createWithModule:@"load_voice_page_json" params:nil];
    [request startRequestWithResponseClass:self completeAction:completeAction];
}

@end
