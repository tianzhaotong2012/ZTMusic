//
//  ZTArtistModel.m
//  zhuanzhuan
//
//  Created by ZZUIHelper on 2020/1/14.
//  Copyright © 2017年 ZZUIHelper. All rights reserved.
//

#import "ZTArtistDetailModel.h"

@implementation ZTArtistDetailModel

+ (NSDictionary *)mj_objectClassInArray
{
    return @{@"songs" : @"ZTSongModel"
             };
}

+ (void)requestWithArtistId:(NSString *)artistId completeAction:(LCBlockComplete)completeAction
{
    ZTRequest *request = [ZTRequest createWithModule:@"load_artist_info_json" params:@{@"artistId" : TLNoNilString(artistId)}];
    [request startRequestWithResponseClass:self completeAction:completeAction];
}

@end
