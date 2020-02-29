//
//  ZTLibraryViewController.m
//  ZTMusic
//
//  Created by 李伯坤 on 2018/7/31.
//  Copyright © 2018年 李伯坤. All rights reserved.
//

#import "ZTLibraryViewController.h"
#import "ZTSettingViewController.h"
#import "ZTLibraryCateModel.h"

typedef NS_ENUM(NSInteger, ZTLibraryVCSectionType) {
    ZTLibraryVCSectionTypeCommon,
    ZTLibraryVCSectionTypeRecent,
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

- (void)loadLibraryVCSubViews
{
    self.clear();
    
    NSArray *cateData = [ZTLibraryCateModel selectedModels];
    if (cateData.count > 0) {
        NSInteger sectionTag = ZTLibraryVCSectionTypeCommon;
        self.addSection(sectionTag).sectionInsets(UIEdgeInsetsMake(20, 20, 10, 20)).minimumLineSpacing(20).minimumInteritemSpacing(20);
        self.addCells(@"ZTLibraryCateCell").toSection(sectionTag).withDataModelArray(cateData);
    }
    
    {
        NSInteger sectionTag = ZTLibraryVCSectionTypeRecent;
        self.addSection(sectionTag);
        self.addCell(@"ZTSearchSectionTitleCell").toSection(sectionTag).withDataModel(@{@"title" : LOCSTR(@"最近添加")});
    }
    
    [self reloadView];
}

@end
