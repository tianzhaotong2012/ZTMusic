//
//  ZTLibraryViewController.m
//  ZTMusic
//
//  Created by 李伯坤 on 2018/7/31.
//  Copyright © 2018年 李伯坤. All rights reserved.
//

#import "ZTLibraryViewController.h"
#import "ZTSettingViewController.h"
#import "ZTMusicPlayViewController.h"
#import "ZTLibraryCateModel.h"


#import "LCDatabase.h"
#import "TSong.h"


typedef NS_ENUM(NSInteger, ZTLibraryVCSectionType) {
    ZTLibraryVCSectionTypeCommon,
    ZTLibraryVCSectionTypeRecent,
    ZTLibraryVCSectionTypeRecentList,
};

@interface ZTLibraryViewController ()

@end

@implementation ZTLibraryViewController

- (void)loadView {
    [super loadView];
    [self.navigationItem setTitle:LOCSTR(@"资料库")];
    
    @weakify(self);
    [self addRightBarButtonWithImage:[UIImage imageNamed:@"nav_edit"] actionBlick:^{
        @strongify(self);
        ZTSettingViewController *settingVC = [[ZTSettingViewController alloc] init];
        [self.navigationController pushViewController:settingVC animated:YES];
    }];
    
    [self loadLibraryVCSubViews];
}

- (void)viewWillAppear:(BOOL)animated{
    _recentSongs = [[NSArray alloc] init];
    NSArray<TSong *> *tSongs = [[LCDatabase sharedInstance] selectOrder];
    NSUInteger c = tSongs.count;
    NSMutableArray *mutableArray = [NSMutableArray arrayWithCapacity:c];
    for (int i = 0; i < tSongs.count; i++) {
        TSong* tSong = [tSongs objectAtIndex:i];
        ZTSongModel* songModel = [[ZTSongModel alloc] init];
        songModel.postId = tSong.postId;
        songModel.title = tSong.title;
        songModel.poster = tSong.poster;
        ZTArtistModel* artist = [[ZTArtistModel alloc] init];
        artist.artistName = tSong.artistName;
        songModel.artist = artist;
        ZTSongPreviewModel* preview = [[ZTSongPreviewModel alloc] init];
        preview.mp3 = tSong.mp3;
        songModel.preview = preview;
        [mutableArray addObject:songModel];
    }
    _recentSongs = [mutableArray copy];
    [self loadLibraryVCSubViews];
}

- (void)loadLibraryVCSubViews
{
    self.clear();
    
    //播放列表 艺人 专辑 歌曲 模块
    /*NSArray *cateData = [ZTLibraryCateModel selectedModels];
    if (cateData.count > 0) {
        NSInteger sectionTag = ZTLibraryVCSectionTypeCommon;
        self.addSection(sectionTag).sectionInsets(UIEdgeInsetsMake(20, 20, 10, 20)).minimumLineSpacing(20).minimumInteritemSpacing(20);
        self.addCells(@"ZTLibraryCateCell").toSection(sectionTag).withDataModelArray(cateData);
    }*/
    
    {
        NSInteger sectionTag = ZTLibraryVCSectionTypeRecent;
        self.addSection(sectionTag);
        self.addCell(@"ZTSearchSectionTitleCell").toSection(sectionTag).withDataModel(@{@"title" : LOCSTR(@"最近添加")});
        
        NSInteger sectionRecentList = ZTLibraryVCSectionTypeRecentList;
        self.addSection(sectionRecentList);
    self.addCells(@"ZTForYouCell").toSection(sectionRecentList).withDataModelArray(_recentSongs).selectedAction(^ (ZTSongModel *model) {
        
            //-----------------播放跳转-------------------------------------------
            [[ZTMusicPlayViewController sharedInstance] startPlayMusic:model];
        });
    }
    
    [self reloadView];
}

@end
