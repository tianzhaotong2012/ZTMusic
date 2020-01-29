//
//  ZTSearchResultAngel.m
//  ZTMusic
//
//  Created by 李伯坤 on 2018/8/2.
//  Copyright © 2018年 李伯坤. All rights reserved.
//

#import "ZTSearchResultAngel.h"
#import "ZTSearchResultModel.h"
#import "ZTMusicPlayViewController.h"
#import "ZTArtistViewController.h"
#import "TLWebViewController.h"

@interface ZTSearchResultAngel ()

@end

@implementation ZTSearchResultAngel

- (void)requestSearch:(NSString *)word completeAction:(LCBlockComplete)completeAction
{
    @weakify(self);
    [ZTSearchResultModel requestWithKeyword:word completeAction:^(BOOL success, id data) {
        @strongify(self);
        if (success) {
            [self loadListUIWithSearchResult:data];
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

- (void)loadListUIWithSearchResult:(NSArray *)searchResult
{
    self.clear();
    
    for (int i = 0; i < searchResult.count; i++) {
        ZTSearchResultModel *model = searchResult[i];
        
        self.addSection(i);
        if (model.sectionTitle) {
            self.addCell(@"ZTSearchResultTitleCell").toSection(i).withDataModel(@{@"title" : model.sectionTitle});
        }
        if (model.type == 1) {
            self.addCells(@"ZTSearchResultSongCell").toSection(i).withDataModelArray(model.songs).selectedAction(^ (ZTSongModel *model) {
                //[[ZTMusicPlayViewController sharedInstance] startPlayMusic:model];
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
                [self.navigationController presentViewController:alertController animated:true completion:nil];
                
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
