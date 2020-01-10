//
//  ZTMusicPlayViewController.m
//  ZTMusic
//
//  Created by 李伯坤 on 2018/8/7.
//  Copyright © 2018年 李伯坤. All rights reserved.
//

#import "ZTMusicPlayViewController.h"
#import <LNPopupController/LNPopupController.h>
#import "ZTPlayerManager.h"

@interface ZTMusicPlayViewController ()

@property (nonatomic, strong) ZTSongModel *songModel;

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
    
    [[ZTPlayerManager sharedInstance] setStartPlayAction:^(ZTSongModel *songModel, CGFloat totalTime) {
        NSLog(@"[ZTPlayerManager] 开始播放，总时长：%.2lf", totalTime);
    } progressAction:^(ZTSongModel *songModel, CGFloat currentTime, CGFloat totalTime) {
        NSLog(@"[ZTPlayerManager] 播放中，总时长：%.2lf，当前：%.2lf", totalTime, currentTime);
    } stopPlayAction:^(ZTSongModel *songModel, ZTPlayerStopType type) {
        NSLog(@"[ZTPlayerManager] 停止播放：%ld", type);
        [self.popupItem setLeftBarButtonItems:@[self.playItem]];
    }];
}

- (void)startPlayMusic:(ZTSongModel *)musicModel
{
    self.songModel = musicModel;
    self.popupItem.leftBarButtonItems = @[self.pauseItem];
    
    self.popupItem.title = musicModel.title;
    self.popupItem.subtitle = musicModel.artist.artistName;
    self.popupItem.image = musicModel.posterImage;
    @weakify(self);
    [[SDWebImageDownloader sharedDownloader] downloadImageWithURL:musicModel.poster.toURL options:SDWebImageDownloaderHighPriority progress:nil completed:^(UIImage * _Nullable image, NSData * _Nullable data, NSError * _Nullable error, BOOL finished) {
        @strongify(self);
        musicModel.posterImage = image;
        if (finished && image && self.songModel == musicModel) {
            self.popupItem.image = image;
        }
    }];
    
    [[ZTPlayerManager sharedInstance] playMusic:musicModel];
}

#pragma mark - # Event
- (void)playButtonClick
{
    [self.popupItem setLeftBarButtonItems:@[self.pauseItem]];
    [[ZTPlayerManager sharedInstance].player play];
}

- (void)pauseButtonClick
{
    [self.popupItem setLeftBarButtonItems:@[self.playItem]];
    [[ZTPlayerManager sharedInstance].player pause];
}

- (void)nextButtonClick
{
    
}

#pragma mark - # UI
- (void)loadPlayerVCSubviews
{
    @weakify(self);
    UIBarButtonItem *(^createBarButton)(NSString *imageName, SEL selector) = ^UIBarButtonItem *(NSString *imageName, SEL selector) {
        UIButton *button = UIButton.zz_create(0).image([UIImage imageNamed:imageName]).frame(CGRectMake(0, 0, 55, 40))
        .eventBlock(UIControlEventTouchUpInside, ^(UIButton *sender) {
            @strongify(self);
            [self performSelectorOnMainThread:selector withObject:nil waitUntilDone:NO];
        }).view;
        UIBarButtonItem *item = [[UIBarButtonItem alloc] initWithCustomView:button];
        return item;
    };
    
    self.playItem = createBarButton(@"play", @selector(playButtonClick));
    self.pauseItem = createBarButton(@"pause", @selector(pauseButtonClick));
    self.nextItem = createBarButton(@"nextFwd", @selector(nextButtonClick));
    
    self.popupItem.title = @"未在播放";
    self.popupItem.image = [UIImage imageNamed:@"music_placeholder"];
    self.popupItem.leftBarButtonItems = @[self.playItem];
    self.popupItem.rightBarButtonItems = @[self.nextItem];
}

@end
