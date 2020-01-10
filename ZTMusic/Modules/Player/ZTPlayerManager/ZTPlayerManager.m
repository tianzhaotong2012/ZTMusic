//
//  ZTPlayerManager.m
//  ZTMusic
//
//  Created by 李伯坤 on 2018/8/8.
//  Copyright © 2018年 李伯坤. All rights reserved.
//

#import "ZTPlayerManager.h"
#import <MediaPlayer/MediaPlayer.h>

@interface ZTPlayerManager ()


@end

@implementation ZTPlayerManager

+ (ZTPlayerManager *)sharedInstance
{
    static ZTPlayerManager *manager;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        manager = [[ZTPlayerManager alloc] init];
    });
    return manager;
}

- (instancetype)init
{
    if (self = [super init]) {
        _player = [[ZTPlayer alloc] init];
        
        [[UIApplication sharedApplication] beginReceivingRemoteControlEvents];
    }
    return self;
}

- (void)setStartPlayAction:(void (^)(ZTSongModel *songModel, CGFloat totalTime))startPlayAction
            progressAction:(void (^)(ZTSongModel *songModel, CGFloat currentTime, CGFloat totalTime))progressAction
            stopPlayAction:(void (^)(ZTSongModel *songModel, ZTPlayerStopType type))stopPlayAction
{
    @weakify(self);
    [self.player setStartPlayAction:^(ZTPlayer *player, CGFloat totalTime) {
        @strongify(self);
        [self p_updateLockedScreenMusicWithTotal:totalTime current:0];
        if (startPlayAction) {
            startPlayAction(self.songModel, totalTime);
        }
    } progressAction:^(ZTPlayer *player, CGFloat currentTime, CGFloat totalTime) {
        @strongify(self);
        [self p_updateLockedScreenMusicWithTotal:totalTime current:currentTime];
        if (progressAction) {
            progressAction(self.songModel, currentTime, totalTime);
        }
    } stopPlayAction:^(ZTPlayer *player, ZTPlayerStopType type) {
        @strongify(self);
        if (stopPlayAction) {
            stopPlayAction(self.songModel, type);
        }
    }];
}

- (void)playMusic:(ZTSongModel *)songModel
{
    _songModel = songModel;
    [self.player playWithUrl:songModel.preview.mp3];
}

- (void)remoteControlReceivedWithEvent:(UIEvent*)event
{
    if (event.type == UIEventTypeRemoteControl) {
        switch (event.subtype) {
            case UIEventSubtypeRemoteControlTogglePlayPause:
                [self.player play];
                break;
            case UIEventSubtypeRemoteControlPreviousTrack:
                NSLog(@"播放上一曲按钮");
                break;
            case UIEventSubtypeRemoteControlNextTrack:
                NSLog(@"播放下一曲按钮");
                break;
            case UIEventSubtypeRemoteControlPause:
                [self.player pause];
                break;
            default:
                break;
        }
    }
}

#pragma mark - # Private Methods
- (void)p_updateLockedScreenMusicWithTotal:(CGFloat)total current:(CGFloat)current
{
    NSMutableDictionary *info = [NSMutableDictionary dictionary];
    info[MPMediaItemPropertyAlbumTitle] = self.songModel.title;
    info[MPMediaItemPropertyArtist] = self.songModel.artist.artistName;
    info[MPMediaItemPropertyTitle] = self.songModel.title;
    info[MPMediaItemPropertyPlaybackDuration] = @(total);
    info[MPNowPlayingInfoPropertyElapsedPlaybackTime] = @(current);
    if (self.songModel.posterImage) {
        info[MPMediaItemPropertyArtwork] = [[MPMediaItemArtwork alloc] initWithImage:self.songModel.posterImage];
    }
    [MPNowPlayingInfoCenter defaultCenter].nowPlayingInfo = info;
}

@end
