//
//  ZTSearchResultModel.h
//  ZTMusic
//
//  Created by 李伯坤 on 2018/8/6.
//  Copyright © 2018年 李伯坤. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "ZTSongModel.h"
#import "ZTArtistModel.h"

@interface ZTSearchResultModel : NSObject

/// 分组类型，1歌曲、2艺人、3专辑、4歌单
@property (nonatomic, assign) NSInteger type;

/// 分组标题
@property (nonatomic, strong) NSString *sectionTitle;

/// 歌曲
@property (nonatomic, strong) NSArray<ZTSongModel *> *songs;

/// 歌手
@property (nonatomic, strong) NSArray<ZTArtistModel *> *artists;

+ (void)requestWithKeyword:(NSString *)keyword completeAction:(LCBlockComplete)completeAction;

@end
