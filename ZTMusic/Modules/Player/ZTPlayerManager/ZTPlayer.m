//
//  ZTPlayer.m
//  ZTMusic
//
//  Created by 李伯坤 on 2018/8/8.
//  Copyright © 2018年 李伯坤. All rights reserved.
//

#import "ZTPlayer.h"
#import <AVFoundation/AVFoundation.h>
#import <KTVHTTPCache/KTVHTTPCache.h>

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
    
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        [self setupHTTPCache];
    });
    
    return self;
}

- (void)setupHTTPCache
{
    [KTVHTTPCache logSetConsoleLogEnable:YES];
    NSError *error = nil;
    [KTVHTTPCache proxyStart:&error];
    if (error) {
        NSLog(@"Proxy Start Failure, %@", error);
    } else {
        NSLog(@"Proxy Start Success");
    }
    [KTVHTTPCache encodeSetURLConverter:^NSURL *(NSURL *URL) {
        NSLog(@"URL Filter reviced URL : %@", URL);
        return URL;
    }];
    [KTVHTTPCache downloadSetUnacceptableContentTypeDisposer:^BOOL(NSURL *URL, NSString *contentType) {
        NSLog(@"Unsupport Content-Type Filter reviced URL : %@, %@", URL, contentType);
        return NO;
    }];
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
    url = [url stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    [self setUrl:url];
    [self play];
}

- (void)play
{
    _isPlaying = YES;
    [self.player play];
}

- (void) setVolume:(float)volume{
    _volume = volume;
    [self.player setVolume:_volume];
}

- (float) getVolume{
    _volume = self.player.volume;
    return _volume;
}

- (void)setUrl:(NSString *)url
{
    //加入代理缓存
    Boolean is = [KTVHTTPCache proxyIsRunning];
    NSURL *proxyURL = [KTVHTTPCache proxyURLWithOriginalURL:[NSURL URLWithString:url]];
    if (@available(iOS 10.0, *)) {
        self.player.automaticallyWaitsToMinimizeStalling = NO;//关闭缓冲足够多
    } else {
        // Fallback on earlier versions
    }
    
    _url = url;
    if (self.playerItem) {
        [self.playerItem removeObserver:self forKeyPath:@"status"];
    }
    self.playerItem = [[AVPlayerItem alloc] initWithURL:proxyURL];
    [self.playerItem addObserver:self forKeyPath:@"status" options:NSKeyValueObservingOptionNew context:nil];
    [self.playerItem addObserver:self forKeyPath:@"playbackBufferEmpty" options:NSKeyValueObservingOptionNew context:nil];
    [self.playerItem addObserver:self forKeyPath:@"playbackLikelyToKeepUp" options:NSKeyValueObservingOptionNew context:nil];
    [self.player replaceCurrentItemWithPlayerItem:self.playerItem];
}

- (void)pause
{
    _isPlaying = NO;
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
    }else if ([keyPath isEqualToString:@"playbackBufferEmpty"]) { //监听播放器在缓冲数据的状态
                NSLog(@"缓冲不足暂停了");
                
    } else if ([keyPath isEqualToString:@"playbackLikelyToKeepUp"]) {
                NSLog(@"缓冲达到可播放程度了");
                //由于 AVPlayer缓存不足就会自动暂停，所以缓存充足了需要手动播放，才能继续播放
                
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
