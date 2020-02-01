//
//  ZTMusicPlayViewController.m
//  ZTMusic
//
//  Created by 李伯坤 on 2018/8/7.
//  Copyright © 2018年 李伯坤. All rights reserved.
//

#import "ZTMusicPlayViewController.h"
//#import <LNPopupController/LNPopupController.h>
#import "LNPopupController.h"
#import "ZTPlayerManager.h"
#import "TLWebViewController.h"

#import "TLSettingItem.h"
#import "ZTAppConfig.h"
#import <DKNightVersion/DKNightVersion.h>

@interface ZTMusicPlayViewController ()

@property (nonatomic, strong) ZTSongModel *songModel;

@property (nonatomic, strong) UIBarButtonItem *playItem;
@property (nonatomic, strong) UIBarButtonItem *pauseItem;
@property (nonatomic, strong) UIBarButtonItem *nextItem;
@property (nonatomic, strong) UIBarButtonItem *loadingItem;

@end

@implementation ZTMusicPlayViewController

typedef NS_ENUM(NSInteger, ZTSettingVCSectionType) {
    ZTMusicPlayViewTop
};

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
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    [[ZTPlayerManager sharedInstance] setStartPlayAction:^(ZTSongModel *songModel, CGFloat totalTime) {
        NSLog(@"[ZTPlayerManager] 开始播放，总时长：%.2lf", totalTime);
        self.popupItem.title = LOCSTR(@"正在解析内容...");
    } progressAction:^(ZTSongModel *songModel, CGFloat currentTime, CGFloat totalTime) {
        NSLog(@"[ZTPlayerManager] 播放中，总时长：%.2lf，当前：%.2lf", totalTime, currentTime);
        //self.popupItem.title = [songModel.title stringByAppendingFormat:@" %.2lf / %.2lf", currentTime, totalTime];
        self.popupItem.title = songModel.title;
        self.popupItem.progress = currentTime/totalTime;
        if(self.popupItem.leftBarButtonItems.firstObject == self.loadingItem){
                 self.popupItem.leftBarButtonItems = @[ self.pauseItem ];
        }
    } stopPlayAction:^(ZTSongModel *songModel, ZTPlayerStopType type) {
        NSLog(@"[ZTPlayerManager] 停止播放：%ld", type);
        self.popupItem.leftBarButtonItems = @[ self.playItem ];
        self.popupItem.title = songModel.title;
    }];
    
    [self loadPlayerVCSubviews];
    [self refreshUI];
}

- (void)viewDidLayoutSubviews{
    [super viewDidLayoutSubviews];
}

- (void)refreshUI{
    NSInteger sectionTag = ZTMusicPlayViewTop;
    self.sectionForTag(sectionTag).clear();
     self.addSection(0);
     self.addCell(@"ZTMusicPlayViewTop").toSection(0).withDataModel(_songModel);
    
    [self.collectionView reloadData];
}

- (void)startPlayMusic:(ZTSongModel *)musicModel
{
    self.songModel = musicModel;
    //self.popupItem.leftBarButtonItems = @[self.pauseItem];
    self.popupItem.leftBarButtonItems = @[ self.loadingItem ];
    
    self.popupItem.title = musicModel.title;
    //self.popupItem.subtitle = musicModel.artist.artistName;
    //self.popupItem.image = musicModel.posterImage;
    self.popupItem.image = [UIImage imageNamed:@"AppIcon60x60@3x"];
    @weakify(self);
    [[SDWebImageDownloader sharedDownloader] downloadImageWithURL:musicModel.poster.toURL options:SDWebImageDownloaderHighPriority progress:nil completed:^(UIImage * _Nullable image, NSData * _Nullable data, NSError * _Nullable error, BOOL finished) {
        @strongify(self);
        musicModel.posterImage = image;
        if (finished && image && self.songModel == musicModel) {
            self.popupItem.image = image;
        }
    }];
    
    [[ZTPlayerManager sharedInstance] playMusic:musicModel];
    
    [self refreshUI];

}

#pragma mark - # Event
- (void)playButtonClick
{
    //[self.popupItem setLeftBarButtonItems:@[self.pauseItem]];
    self.popupItem.leftBarButtonItems = @[ self.pauseItem ]; 
    [[ZTPlayerManager sharedInstance].player play];
    
    [self refreshUI];
}

- (void)pauseButtonClick
{
    //[self.popupItem setLeftBarButtonItems:@[self.playItem]];
    self.popupItem.leftBarButtonItems = @[ self.playItem ];
    
    [[ZTPlayerManager sharedInstance].player pause];
    
    [self refreshUI];
}

- (void)nextButtonClick
{
    
}

#pragma mark - # UI
- (void)loadPlayerVCSubviews
{
    UIBarButtonItem *(^createBarButton)(NSString *imageName, SEL selector) = ^UIBarButtonItem *(NSString *imageName, SEL selector) {
        UIButton *button = UIButton.zz_create(0).image([UIImage imageNamed:imageName]).frame(CGRectMake(0, 0, 96, 55))
        .eventBlock(UIControlEventTouchUpInside, ^(UIButton *sender) {

            [self performSelectorOnMainThread:selector withObject:nil waitUntilDone:NO];
        }).view;
        UIBarButtonItem *item = [[UIBarButtonItem alloc] initWithCustomView:button];
        return item;
    };

    self.playItem = createBarButton(@"play", @selector(playButtonClick));
    self.pauseItem = createBarButton(@"pause", @selector(pauseButtonClick));
    self.nextItem = createBarButton(@"nextFwd", @selector(nextButtonClick));

    UIActivityIndicatorView* loadingView = [[UIActivityIndicatorView alloc] initWithFrame:(CGRectMake(0, 0, 96, 55))];
    loadingView.color = [UIColor colorPink];
    [loadingView startAnimating];
    self.loadingItem = [[UIBarButtonItem alloc] initWithCustomView:loadingView];
    
    
    
//    self.popupItem.leftBarButtonItems = @[self.playItem];
//    //self.popupItem.rightBarButtonItems = @[self.nextItem];
    
//    UIBarButtonItem* play = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"play"] style:UIBarButtonItemStylePlain target:self action:@selector(playButtonClick:)];
//
//        UIBarButtonItem* pause = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"pause"] style:UIBarButtonItemStylePlain target:self action:@selector(pauseButtonClick:)];
//
//        UIBarButtonItem* next = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"nextFwd"] style:UIBarButtonItemStylePlain target:self action:@selector(nextButtonClick:)];
//
//    self.playItem = play;
//    self.pauseItem = pause;
//    self.nextItem = next;
    
    NSString* const PopupSettingsBarStyle = @"PopupSettingsBarStyle";
        if([[[NSUserDefaults standardUserDefaults] objectForKey:PopupSettingsBarStyle] unsignedIntegerValue] == LNPopupBarStyleCompact
    #if ! TARGET_OS_MACCATALYST
           || NSProcessInfo.processInfo.operatingSystemVersion.majorVersion < 10
    #endif
           )
        {
            //self.popupItem.leftBarButtonItems = @[ self.playItem ];
            //self.popupItem.rightBarButtonItems = @[ next, stop ];
        }
        else
        {
            self.popupItem.leftBarButtonItems = @[ self.playItem ];
            self.popupItem.rightBarButtonItems = nil;
        }
    
    self.popupItem.title = LOCSTR(@"未在播放");
    self.popupItem.image = [UIImage imageNamed:@"AppIcon60x60@3x"];
    self.popupItem.progress = 0.0;
}

@end
