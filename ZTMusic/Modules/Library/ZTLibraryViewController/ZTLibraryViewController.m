//
//  ZTLibraryViewController.m
//  ZTMusic
//
//  Created by 李伯坤 on 2018/7/31.
//  Copyright © 2018年 李伯坤. All rights reserved.
//

#import "ZTLibraryViewController.h"
#import "ZTSettingViewController.h"

@interface ZTLibraryViewController ()

@end

@implementation ZTLibraryViewController

- (void)loadView {
    [super loadView];
    [self.navigationItem setTitle:LOCSTR(@"资料库")];
    
    @weakify(self);
    [self addRightBarButtonWithImage:[UIImage imageNamed:@"nav_setting"] actionBlick:^{
        @strongify(self);
        ZTSettingViewController *settingVC = [[ZTSettingViewController alloc] init];
        [self.navigationController pushViewController:settingVC animated:YES];
    }];
    
    self.addSection(0);
    self.addSeperatorCell(CGSizeMake(-1, 1024), [UIColor whiteColor]).toSection(0);
    [self reloadView];
}


@end
