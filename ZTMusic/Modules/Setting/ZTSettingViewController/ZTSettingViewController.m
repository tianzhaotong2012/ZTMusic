//
//  ZTSettingViewController.m
//  ZTMusic
//
//  Created by 李伯坤 on 2018/7/31.
//  Copyright © 2018年 李伯坤. All rights reserved.
//

#import "ZTSettingViewController.h"
#import "TLSettingItem.h"
#import "ZTAppConfig.h"
#import <DKNightVersion/DKNightVersion.h>

typedef NS_ENUM(NSInteger, ZTSettingVCSectionType) {
    ZTSettingVCSectionTypeNight,
    ZTSettingVCSectionTypeAbount,
};


@interface ZTSettingViewController ()

@end

@implementation ZTSettingViewController


+ (void)load
{
    [LCRouter registerNodeWithTradeline:@"app" pageName:@"setting" eventName:@"jump" eventAction:^(LCRouter *router, LCRouterUrlDAO *urlDAO, NSDictionary *params) {
        ZTSettingViewController *vc = [ZTSettingViewController mj_objectWithKeyValues:params];
        [router pushViewController:vc animated:YES];
    }];
}

- (void)loadView
{
    [super loadView];
    [self setTitle:LOCSTR(@"设置")];
    self.collectionView.dk_backgroundColorPicker = DKColorPickerWithKey(GRAY_BG);
    
    [self loadSettingUI];
}

#pragma mark - # UI
- (void)loadSettingUI
{
    @weakify(self);
    self.clear();
    
    // 夜间模式
    {
        NSInteger sectionTag = ZTSettingVCSectionTypeNight;
        self.addSection(sectionTag).sectionInsets(UIEdgeInsetsMake(20, 0, 0, 0));
        
        TLSettingItem *batchAll = TLCreateSettingItem(@"夜间模式");
        batchAll.subTitle = @([ZTAppConfig sharedInstance].night).stringValue;
        self.addCell(CELL_ST_ITEM_SWITCH).toSection(sectionTag).withDataModel(batchAll).eventAction(^id (NSInteger eventType, NSNumber *data) {
            @strongify(self);
            [ZTAppConfig sharedInstance].night = data.boolValue;
            if (data.boolValue) {
                [[DKNightVersionManager sharedManager] nightFalling];
            }
            else {
                [[DKNightVersionManager sharedManager] dawnComing];
            }
            
            if (@available(iOS 11.0, *)) {
                NSDictionary *largerTitleTA = @{NSFontAttributeName : [UIFont boldSystemFontOfSize:35],
                                                NSForegroundColorAttributeName : [ZTAppConfig sharedInstance].night ? HexColor(0xeeeeee) : [UIColor blackColor]
                                                };
                [[UINavigationBar appearance] setLargeTitleTextAttributes:largerTitleTA];
                [self.navigationController.navigationBar setLargeTitleTextAttributes:largerTitleTA];
            }
            
            NSDictionary *normalTitleTA = @{NSFontAttributeName : [UIFont boldSystemFontOfSize:17],
                                            NSForegroundColorAttributeName : [ZTAppConfig sharedInstance].night ? HexColor(0xeeeeee) : [UIColor blackColor]};
            [[UINavigationBar appearance] setTitleTextAttributes:normalTitleTA];
            [self.navigationController.navigationBar setTitleTextAttributes:normalTitleTA];
            return nil;
        });
    }
    
    // 公告
    {
        NSInteger sectionTag = ZTSettingVCSectionTypeAbount;
        
        TLSettingItem *versionItem = TLCreateSettingItem(@"关于");
//        versionItem.subTitle = [LCAppManager sharedInstance].version;
        self.addCell(CELL_ST_ITEM_NORMAL).toSection(sectionTag).withDataModel(versionItem).selectedAction(^ (id data) {
            @strongify(self);
//            LCAboutViewController *aboutVC = [[LCAboutViewController alloc] init];
//            PushVC(aboutVC);
        });
    }
    
    [self reloadView];
}

@end
