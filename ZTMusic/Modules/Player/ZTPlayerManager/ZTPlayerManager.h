//
//  ZTPlayerManager.h
//  ZTMusic
//
//  Created by 李伯坤 on 2018/8/8.
//  Copyright © 2018年 李伯坤. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ZTPlayer.h"
#import "ZTSongModel.h"

@interface ZTPlayerManager : UIResponder

/// 播放器
@property (nonatomic, strong, readonly) ZTPlayer *player;

/// 当前正在播放的歌曲
@property (nonatomic, strong, readonly) ZTSongModel *songModel;

+ (ZTPlayerManager *)sharedInstance;

/**
 *  播放单首歌曲
 */
- (void)playMusic:(ZTSongModel *)songModel;

/**
 *  设置播放回调
 */
- (void)setStartPlayAction:(void (^)(ZTSongModel *songModel, CGFloat totalTime))startPlayAction
            progressAction:(void (^)(ZTSongModel *songModel, CGFloat currentTime, CGFloat totalTime))progressAction
            stopPlayAction:(void (^)(ZTSongModel *songModel, ZTPlayerStopType type))stopPlayAction;

@end
