//
//  ZTExploreViewController.m
//  zhuanzhuan
//
//  Created by ZZUIHelper on 2020/1/13.
//  Copyright © 2017年 ZZUIHelper. All rights reserved.
//

#import "ZTExploreViewController.h"
#import "ZTExploreMode.h"
#import "ZTArtistViewController.h"
#import "TLWebViewController.h"
#import "ZTMusicPlayViewController.h"

typedef NS_ENUM(NSInteger, ZTExploreVCSectionType) {
    ZTExploreVCSectionTypeTop,
    ZTExploreVCSectionTypeSong,
    ZTExploreVCSectionTypeArtist,
};

@implementation ZTExploreViewController

- (void)loadView {
    [super loadView];
    [self.navigationItem setTitle:LOCSTR(@"发现")];
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
    [self requestExploreModuleWithCompleteAction:^(BOOL success, id data) {
        [self.loadingView stopAnimating];
    }];
}

- (void)requestExploreModuleWithCompleteAction:(LCBlockComplete)completeAction
{
    @weakify(self);
    [ZTExploreMode requestWithCompleteAction:^(BOOL success, id data) {
        @strongify(self);
        if (success) {
            [self loadExploreModuleWithModelArray:data];
        }
        else {
            if ([data isKindOfClass:[NSString class]]) {
                [TLUIUtility showErrorHint:(NSString *)data];
            }
            else {
                [TLUIUtility showAlertWithTitle:LOCSTR(@"网络请求失败") message:LOCSTR(@"请检查网络并开启授权网络访问") cancelButtonTitle:LOCSTR(@"退出去联网") otherButtonTitles:@[LOCSTR(@"立即重试")] actionHandler:^(NSInteger buttonIndex) {
                    if(buttonIndex == 0){
                        exit(0);
                    }
                    if(buttonIndex == 1){
                        [self requestData];
                    }
                }
                 ];
            }
        }
        if (completeAction) {
            completeAction(success, data);
            if(success == NO){
                [TLUIUtility showAlertWithTitle:LOCSTR(@"网络请求失败") message:LOCSTR(@"请检查网络并开启授权网络访问") cancelButtonTitle:LOCSTR(@"退出去联网") otherButtonTitles:@[LOCSTR(@"立即重试")] actionHandler:^(NSInteger buttonIndex) {
                    if(buttonIndex == 0){
                        exit(0);
                    }
                    if(buttonIndex == 1){
                        [self requestData];
                    }
                }
                 ];
            }
        }
    }];
}

// 加载发现模块
- (void)loadExploreModuleWithModelArray:(NSArray *)array
{
    NSInteger sectionTag = ZTExploreVCSectionTypeTop;
    self.sectionForTag(sectionTag).clear();
    
    for (int i = 0; i < array.count; i++) {
        ZTExploreMode *model = array[i];
        
        self.addSection(i);
        if (model.sectionTitle) {
            self.addCell(@"ZTExploreSectionTitleCell").toSection(i).withDataModel(@{@"title" : model.sectionTitle});
        }
        if (model.type == 1) {
            self.addCell(@"ZTStyleACell").toSection(i).withDataModel(model.songs).eventAction(^ id(NSInteger eventType, ZTSongModel *model) {
                
                //-----------------播放跳转-------------------------------------------
                //初始化一个UIAlertController的警告框
                UIAlertController *alertController = [[UIAlertController alloc] init];
                //初始化一个UIAlertController的警告框将要用到的UIAlertAction style cancle
                UIAlertAction *cancle = [UIAlertAction actionWithTitle:LOCSTR(@"取消") style:UIAlertActionStyleCancel handler:^(UIAlertAction *action) {
                        NSLog(@"cancle 被点击了");
                }];
                //初始化一个UIAlertController的警告框将要用到的UIAlertAction style Default
                UIAlertAction *goPlay = [UIAlertAction actionWithTitle:LOCSTR(@"试听(网络资源)") style:UIAlertActionStyleDefault handler:^(UIAlertAction *action) {
                        [[ZTMusicPlayViewController sharedInstance] startPlayMusic:model];
                }];
                //初始化一个UIAlertController的警告框将要用到的UIAlertAction style Default
                UIAlertAction *goWeb = [UIAlertAction actionWithTitle:LOCSTR(@"前往网页") style:UIAlertActionStyleDefault handler:^(UIAlertAction *action) {
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
                //将初始化好的提示框显示出来
                [self presentViewController:alertController animated:true completion:nil];
                
                return nil;
            });
        }
        else if (model.type == 2) {
            self.addCells(@"ZTSearchResultArtistCell").toSection(i).withDataModelArray(model.artists).selectedAction(^ (ZTArtistModel *model) {
                        ZTArtistViewController *artistVC = [[ZTArtistViewController alloc] init];
                artistVC.artistId = model.artistId;
                        [self.navigationController pushViewController:artistVC animated:YES];
                    });;
        }
    }
    
    [self.collectionView reloadData];
}

@end
