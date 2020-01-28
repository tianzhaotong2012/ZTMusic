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
    self.popupItem.leftBarButtonItems = @[ self.pauseItem ];
    
    self.popupItem.title = musicModel.title;
    //self.popupItem.subtitle = musicModel.artist.artistName;
    //self.popupItem.image = musicModel.posterImage;
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
        UIButton *button = UIButton.zz_create(0).image([UIImage imageNamed:imageName]).frame(CGRectMake(0, 0, 55, 55))
        .eventBlock(UIControlEventTouchUpInside, ^(UIButton *sender) {
            
            [self performSelectorOnMainThread:selector withObject:nil waitUntilDone:NO];
        }).view;
        UIBarButtonItem *item = [[UIBarButtonItem alloc] initWithCustomView:button];
        return item;
    };

    self.playItem = createBarButton(@"play", @selector(playButtonClick));
    self.pauseItem = createBarButton(@"pause", @selector(pauseButtonClick));
    self.nextItem = createBarButton(@"nextFwd", @selector(nextButtonClick));
//
    self.popupItem.title = LOCSTR(@"未在播放");
    self.popupItem.image = [UIImage imageNamed:@"genre7"];
//    self.popupItem.leftBarButtonItems = @[self.playItem];
//    //self.popupItem.rightBarButtonItems = @[self.nextItem];
    
//    UIBarButtonItem* play = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"play"] style:UIBarButtonItemStylePlain target:self action:@selector(playButtonClick:)];
//        play.accessibilityLabel = NSLocalizedString(@"Play", @"");
//        play.accessibilityIdentifier = @"PlayButton";
//        play.accessibilityTraits = UIAccessibilityTraitButton;
//        
//        UIBarButtonItem* stop = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"stop"] style:UIBarButtonItemStylePlain target:self action:@selector(pauseButtonClick:)];
//        stop.accessibilityLabel = NSLocalizedString(@"Stop", @"");
//        stop.accessibilityIdentifier = @"StopButton";
//        stop.accessibilityTraits = UIAccessibilityTraitButton;
//        
//        UIBarButtonItem* next = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"nextFwd"] style:UIBarButtonItemStylePlain target:self action:@selector(nextButtonClick:)];
//        next.accessibilityLabel = NSLocalizedString(@"Next Track", @"");
//        next.accessibilityIdentifier = @"NextButton";
//        next.accessibilityTraits = UIAccessibilityTraitButton;
       
//    self.playItem = play;
//    self.pauseItem = stop;
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
            //self.popupItem.leftBarButtonItems = nil;
        }
    
}

@end
