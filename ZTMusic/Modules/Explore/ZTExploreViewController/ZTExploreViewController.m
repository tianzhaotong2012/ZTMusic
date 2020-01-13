//
//  ZTExploreViewController.m
//  zhuanzhuan
//
//  Created by ZZUIHelper on 2020/1/13.
//  Copyright © 2017年 ZZUIHelper. All rights reserved.
//

#import "ZTExploreViewController.h"
#import "ZTExploreMode.h"

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
                [TLUIUtility showErrorHint:@"网络请求失败"];
            }
        }
        if (completeAction) {
            completeAction(success, data);
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
            self.addCell(@"ZTStyleACell").toSection(i).withDataModel(model.songs).selectedAction(^ (ZTSongModel *model) {
                
            });
        }
        else if (model.type == 2) {
            self.addCells(@"ZTSearchResultArtistCell").toSection(i).withDataModelArray(model.artists);
        }
    }
    
    [self.collectionView reloadData];
}

@end
