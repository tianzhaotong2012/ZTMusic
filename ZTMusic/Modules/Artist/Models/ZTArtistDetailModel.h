//
//  ZTArtistModel.h
//  zhuanzhuan
//
//  Created by ZZUIHelper on 2020/1/14.
//  Copyright © 2017年 ZZUIHelper. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "ZTSongModel.h"
#import "ZTArtistModel.h"

@interface ZTArtistDetailModel : NSObject

/// 艺人
@property (nonatomic, strong) ZTArtistModel *artist;

/// 歌曲
@property (nonatomic, strong) NSArray<ZTSongModel *> *songs;

+ (void)requestWithArtistId:(NSString *)artistId completeAction:(LCBlockComplete)completeAction;
@end
