//
//  ZTExploreMode.h
//  zhuanzhuan
//
//  Created by ZZUIHelper on 2020/1/13.
//  Copyright © 2017年 ZZUIHelper. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "ZTSongModel.h"
#import "ZTArtistModel.h"

@interface ZTExploreMode : NSObject
/// 分组类型，1歌曲、2艺人、3专辑、4歌单
@property (nonatomic, assign) NSInteger type;

/// 分组标题
@property (nonatomic, strong) NSString *sectionTitle;

/// 歌曲
@property (nonatomic, strong) NSArray<ZTSongModel *> *songs;

/// 歌手
@property (nonatomic, strong) NSArray<ZTArtistModel *> *artists;

+ (void)requestWithCompleteAction:(LCBlockComplete)completeAction;

@end
