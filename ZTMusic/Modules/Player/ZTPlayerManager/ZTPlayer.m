//
//  ZTPlayer.m
//  ZTMusic
//
//  Created by 李伯坤 on 2018/8/8.
//  Copyright © 2018年 李伯坤. All rights reserved.
//

#import "ZTPlayer.h"
#import <AVFoundation/AVFoundation.h>

@interface ZTPlayer ()

@property (nonatomic, strong) AVPlayer *player;

@property (nonatomic, strong) AVPlayerItem *playerItem;

@end

@implementation ZTPlayer
@synthesize isPlaying = _isPlaying;

- (instancetype)init
{
    if (self = [super init]) {
        // 支持后台播放
        [[AVAudioSession sharedInstance] setCategory:AVAudioSessionCategoryPlayback error:nil];
        // 激活
        [[AVAudioSession sharedInstance] setActive:YES error:nil];
        
        [self p_initAVPlayer];
    }
    return self;
}

- (void)dealloc
{
    [self.playerItem removeObserver:self forKeyPath:@"status"];
}

- (void)setStartPlayAction:(void (^)(ZTPlayer *player, CGFloat totalTime))startPlayAction
            progressAction:(void (^)(ZTPlayer *player, CGFloat currentTime, CGFloat totalTime))progressAction
            stopPlayAction:(void (^)(ZTPlayer *player, ZTPlayerStopType type))stopPlayAction
{
    _startPlayAction = startPlayAction;
    _progressAction = progressAction;
    _stopPlayAction = stopPlayAction;
}

- (void)playWithUrl:(NSString *)url
{
    [self setUrl:url];
    [self play];
}

- (void)play
{
    _isPlaying = YES;
    [self.player play];
}

- (void)setUrl:(NSString *)url
{
    _url = url;
    if (self.playerItem) {
        [self.playerItem removeObserver:self forKeyPath:@"status"];
    }
    self.playerItem = [[AVPlayerItem alloc] initWithURL:self.url.toURL];
    [self.playerItem addObserver:self forKeyPath:@"status" options:NSKeyValueObservingOptionNew context:nil];
    
    [self.player replaceCurrentItemWithPlayerItem:self.playerItem];
}

- (void)pause
{
    [self.player pause];
}

#pragma mark - # Event
- (void)playbackFinished:(NSNotification *)notification
{
    _isPlaying = NO;
    if (self.stopPlayAction) {
        self.stopPlayAction(self, ZTPlayerStopTypeComplete);
    }
}

- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary<NSString *,id> *)change context:(void *)context {
    if ([keyPath isEqualToString:@"status"]) {
        if (self.player.currentItem.status == AVPlayerStatusReadyToPlay) {
            if (self.startPlayAction) {
                NSTimeInterval totalTime = CMTimeGetSeconds(self.player.currentItem.duration);
                self.startPlayAction(self, totalTime);
            }
        }
        else if (self.player.currentItem.status == AVPlayerStatusFailed) {
            _isPlaying = NO;
            if (self.stopPlayAction) {
                self.stopPlayAction(self, ZTPlayerStopTypeFailed);
            }
        }
    }
}

#pragma mark - # Private Methods
- (void)p_initAVPlayer
{
    self.player = [[AVPlayer alloc] init];
    @weakify(self);
    [self.player addPeriodicTimeObserverForInterval:CMTimeMake(1.0, 1.0) queue:dispatch_get_main_queue() usingBlock:^(CMTime time) {
        @strongify(self);
        AVPlayerItem *item = self.player.currentItem;
        NSTimeInterval total = CMTimeGetSeconds(item.duration);
        if(isnan(total) || total < 0.1) {
            return ;
        }
        NSTimeInterval current = CMTimeGetSeconds(item.currentTime);
        if(isnan(current) || current < 0.0f) {
            current = .0f;
        }
        if (self.progressAction) {
            self.progressAction(self, current, total);
        }
    }];
    
    // 播放完成
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(playbackFinished:) name:AVPlayerItemDidPlayToEndTimeNotification object:nil];
}

@end
