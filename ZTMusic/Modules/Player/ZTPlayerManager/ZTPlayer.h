//
//  ZTPlayer.h
//  ZTMusic
//
//  Created by 李伯坤 on 2018/8/8.
//  Copyright © 2018年 李伯坤. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef NS_ENUM(NSInteger, ZTPlayerStopType) {
    ZTPlayerStopTypeComplete,
    ZTPlayerStopTypePause,
    ZTPlayerStopTypeFailed,
};

@interface ZTPlayer : NSObject

/// 当前正在播放歌曲的url
@property (nonatomic, strong) NSString *url;

/// 开始播放回调
@property (nonatomic, copy) void (^startPlayAction)(ZTPlayer *player, CGFloat totalTime);
/// 播放进度回调
@property (nonatomic, copy) void (^progressAction)(ZTPlayer *player, CGFloat currentTime, CGFloat totalTime);
/// 停止播放回调
@property (nonatomic, copy) void (^stopPlayAction)(ZTPlayer *player, ZTPlayerStopType type);

/**
 *  设置播放回调
 */
- (void)setStartPlayAction:(void (^)(ZTPlayer *player, CGFloat totalTime))startPlayAction
            progressAction:(void (^)(ZTPlayer *player, CGFloat currentTime, CGFloat totalTime))progressAction
            stopPlayAction:(void (^)(ZTPlayer *player, ZTPlayerStopType type))stopPlayAction;

/**
 *  是否正在播放
 */
@property (nonatomic, assign, readonly) BOOL isPlaying;

/**
 *  播放进度
 */
@property (nonatomic, assign) float playingProcess;

/**
 *  播放音量
 */
@property (nonatomic, assign) float volume;

/**
 *  播放指定的url
 */
- (void)playWithUrl:(NSString *)url;

/**
 *  播放
 */
- (void)play;

/**
 *  暂停
 */
- (void)pause;

/**
 *   获取音量
 */
- (float)getVolume;

/**
 *   设置音量
 */
- (void)setVolume:(float)volume;

@end
