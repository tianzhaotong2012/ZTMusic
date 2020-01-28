//
//  ZTArtistViewController.m
//  zhuanzhuan
//
//  Created by ZZUIHelper on 2020/1/14.
//  Copyright © 2017年 ZZUIHelper. All rights reserved.
//

#import "ZTArtistViewController.h"
#import "ZTArtistDetailModel.h"
#import "TLWebViewController.h"
#import "ZTMusicPlayViewController.h"

typedef NS_ENUM(NSInteger, ZTArtistVCSectionType) {
    ZTArtistVCSectionTypeTop,
    ZTArtistVCSectionTypeSong,
};

@implementation ZTArtistViewController

- (void)loadView {
    [super loadView];
    [self.navigationItem setTitle:LOCSTR(@"歌手")];
    [self.view dk_setBackgroundColorPicker:DKColorPickerWithKey(WHITE)];
    self.definesPresentationContext = YES;
    
    @weakify(self);
    self.loadingView = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleGray];
    [self.navigationItem setRightBarButtonItem:[[UIBarButtonItem alloc] initWithCustomView:self.loadingView]];

}

#pragma mark - # Life Cycle
- (void)viewDidLoad {
    [super viewDidLoad];
    [self requestData];
}

- (void)requestData{
    [self.collectionView removeTipView];
    [self.loadingView startAnimating];
    [self requestArtistModuleWithArtistId:self.artistId CompleteAction:^(BOOL success, id data) {
        [self.loadingView stopAnimating];
    }];
}

- (void)requestArtistModuleWithArtistId:(NSString *)artistId CompleteAction:(LCBlockComplete)completeAction
{
    @weakify(self);
    [ZTArtistDetailModel requestWithArtistId:artistId completeAction:^(BOOL success, id data) {
        if (success) {
            [self loadArtistModuleWithModelArray:data];
        }
        else {
            if ([data isKindOfClass:[NSString class]]) {
                [TLUIUtility showErrorHint:(NSString *)data];
            }
            else {
                [TLUIUtility showErrorHint:@"网络请求失败"];
            }
        }
        if (completeAction) {
            completeAction(success, data);
        }
    }];
}

// 加载艺人页面
- (void)loadArtistModuleWithModelArray:(ZTArtistDetailModel *)artistDetail
{
   NSInteger sectionTag = ZTArtistVCSectionTypeSong;
   self.sectionForTag(sectionTag).clear();
    self.addSection(0);
    self.addCell(@"ZTArtistDetailTopView").toSection(0).withDataModel(artistDetail);
   self.addSection(1);
self.addCells(@"ZTSearchResultSongCell").toSection(1).withDataModelArray(artistDetail.songs).selectedAction(^ (ZTSongModel *model) {
        //播放跳转
        //初始化一个UIAlertController的警告框
        UIAlertController *alertController = [[UIAlertController alloc] init];
        //初始化一个UIAlertController的警告框将要用到的UIAlertAction style cancle
        UIAlertAction *cancle = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:^(UIAlertAction *action) {
                NSLog(@"提示框上的按钮 cancle 被点击了");
        }];
            //初始化一个UIAlertController的警告框将要用到的UIAlertAction style Default
            UIAlertAction *goPlay = [UIAlertAction actionWithTitle:@"试听（网络资源）" style:UIAlertActionStyleDefault handler:^(UIAlertAction *action) {
                [[ZTMusicPlayViewController sharedInstance] startPlayMusic:model];
            }];
            //初始化一个UIAlertController的警告框将要用到的UIAlertAction style Default
            UIAlertAction *goWeb = [UIAlertAction actionWithTitle:@"前往网页" style:UIAlertActionStyleDefault handler:^(UIAlertAction *action) {
                TLWebViewController *webVC = [[TLWebViewController alloc] initWithUrl:model.netSource];
                webVC.navigationController = self.navigationController;
                if (@available(iOS 11.0, *)) {
                    [self.navigationController.navigationBar setPrefersLargeTitles:false];
                }
                [self.navigationController pushViewController:webVC animated:YES];
            }];
            //将初始化好的UIAlertAction添加到UIAlertController中
            [alertController addAction:cancle];
            [alertController addAction:goPlay];
            [alertController addAction:goWeb];
            //将初始化好的j提示框显示出来
            [self presentViewController:alertController animated:true completion:nil];
    });
    [self.collectionView reloadData];
    
}

@end
