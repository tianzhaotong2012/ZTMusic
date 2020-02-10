//
//  ZTForYouModel.m
//  zhuanzhuan
//
//  Created by ZZUIHelper on 2020/2/10.
//  Copyright © 2017年 ZZUIHelper. All rights reserved.
//

#import "ZTForYouModel.h"

@implementation ZTForYouModel

+ (NSDictionary *)mj_objectClassInArray
{
    return @{@"songs" : @"ZTSongModel"
             };
}

+ (void)requestWithPage:(NSString *)page withPageNum:(NSString *)pageNum completeAction:(LCBlockComplete)completeAction{
    ZTRequest *request = [ZTRequest createWithModule:@"load_music_list_json" params:@{@"page" : TLNoNilString(page), @"pageNum" : TLNoNilString(pageNum)}];
       [request startRequestWithResponseClass:self completeAction:completeAction];
}

@end
