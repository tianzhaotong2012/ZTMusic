//
//  ZTMusicPlayViewController.m
//  ZTMusic
//
//  Created by 李伯坤 on 2018/8/7.
//  Copyright © 2018年 李伯坤. All rights reserved.
//

#import "ZTMusicPlayViewController.h"
#import <LNPopupController/LNPopupController.h>
#import <AVFoundation/AVFoundation.h>

@interface ZTMusicPlayViewController ()

@property (nonatomic, strong) ZTSongModel *songModel;
@property (nonatomic, strong) AVPlayer *player;

@property (nonatomic, strong) UIBarButtonItem *playItem;
@property (nonatomic, strong) UIBarButtonItem *pauseItem;
@property (nonatomic, strong) UIBarButtonItem *nextItem;

@end

@implementation ZTMusicPlayViewController

+ (ZTMusicPlayViewController *)sharedInstance
{
    static ZTMusicPlayViewController *vc;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        vc = [[ZTMusicPlayViewController alloc] init];
    });
    return vc;
}

- (void)loadView
{
    [super loadView];
    
    [self loadPlayerVCSubviews];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    // 支持后台播放
    [[AVAudioSession sharedInstance] setCategory:AVAudioSessionCategoryPlayback error:nil];
    // 激活
    [[AVAudioSession sharedInstance] setActive:YES error:nil];
    // 开始监控
    [[UIApplication sharedApplication] beginReceivingRemoteControlEvents];
    
    self.player = [[AVPlayer alloc] init];
    @weakify(self);
    [self.player addPeriodicTimeObserverForInterval:CMTimeMake(1.0, 1.0) queue:dispatch_get_main_queue() usingBlock:^(CMTime time) {
        @strongify(self);
        AVPlayerItem *item = self.player.currentItem;
        NSTimeInterval total = CMTimeGetSeconds(item.duration);
        NSTimeInterval current = CMTimeGetSeconds(item.currentTime);
        self.popupItem.progress = current / total;
    }];
    
    // 播放完成
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(playbackFinished:) name:AVPlayerItemDidPlayToEndTimeNotification object:[self.player currentItem]];
}

- (void)startPlayMusic:(ZTSongModel *)musicModel
{
    self.songModel = musicModel;
    self.popupItem.leftBarButtonItems = @[self.pauseItem];
    
    self.popupItem.title = musicModel.title;
    self.popupItem.subtitle = musicModel.artist.artistName;
    @weakify(self);
    [[SDWebImageDownloader sharedDownloader] downloadImageWithURL:musicModel.poster.toURL options:SDWebImageDownloaderHighPriority progress:nil completed:^(UIImage * _Nullable image, NSData * _Nullable data, NSError * _Nullable error, BOOL finished) {
        @strongify(self);
        if (finished && image && self.songModel == musicModel) {
            self.popupItem.image = image;
        }
    }];
    
    AVPlayerItem *item = [[AVPlayerItem alloc] initWithURL:musicModel.preview.mp3.toURL];
    [self.player replaceCurrentItemWithPlayerItem:item];
    [self.player play];
}

#pragma mark - # Control
- (void)playbackFinished:(NSNotification *)notification
{
    self.popupItem.leftBarButtonItems = @[self.playItem];
}

#pragma mark - # UI
- (void)loadPlayerVCSubviews
{
    UIBarButtonItem *(^createBarButtonItemWithImageName)(NSString *imageName) = ^UIBarButtonItem *(NSString *imageName) {
        UIButton *button = UIButton.zz_create(0).image([UIImage imageNamed:imageName]).frame(CGRectMake(0, 0, 55, 40)).view;
        UIBarButtonItem *item = [[UIBarButtonItem alloc] initWithCustomView:button];
        return item;
    };
    
    self.playItem = createBarButtonItemWithImageName(@"play");
    self.pauseItem = createBarButtonItemWithImageName(@"pause");
    self.nextItem = createBarButtonItemWithImageName(@"nextFwd");
    
    self.popupItem.title = @"未在播放";
    self.popupItem.image = [UIImage imageWithColor:[UIColor colorPink]];
    self.popupItem.leftBarButtonItems = @[self.playItem];
    self.popupItem.rightBarButtonItems = @[self.nextItem];
}

@end
