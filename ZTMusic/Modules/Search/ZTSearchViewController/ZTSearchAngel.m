//
//  ZTSearchAngel.m
//  ZTMusic
//
//  Created by 李伯坤 on 2018/8/2.
//  Copyright © 2018年 李伯坤. All rights reserved.
//

#import "ZTSearchAngel.h"

#define     KEY_SEARCH_HISTORY          @"search_history"

typedef NS_ENUM(NSInteger, ZTSearchVCSectionType) {
    ZTSearchVCSectionTypeRecord,
    ZTSearchVCSectionTypeHot,
};

@interface ZTSearchAngel ()

@property (nonatomic, copy) void (^searchAction)(NSString *word);

@end

@implementation ZTSearchAngel

- (instancetype)initWithHostView:(__kindof UIScrollView *)hostView searchAction:(void (^)(NSString *word))searchAction
{
    if (self = [super initWithHostView:hostView]) {
        self.searchAction = searchAction;
        self.addSection(ZTSearchVCSectionTypeRecord);
        self.addSection(ZTSearchVCSectionTypeHot).sectionInsets(UIEdgeInsetsMake(0, 0, 50, 0));
    }
    return self;
}

- (void)requestHotSearchModuleWithCompleteAction:(LCBlockComplete)completeAction
{
    @weakify(self);
    ZTRequest *request = [ZTRequest createWithModule:@"load_hot_search_json" params:nil];
    [request startRequestWithCompleteAction:^(BOOL success, NSDictionary *data) {
        @strongify(self);
        NSArray *hotSearchData;
        if (success) {
            if ([data isKindOfClass:[NSDictionary class]]) {
                hotSearchData = [data objectForKey:@"hotSearch"];
            }
        }
        else {
            if ([data isKindOfClass:[NSDictionary class]]) {
                NSString *tips = [data objectForKey:@"errMsg"];
                [TLUIUtility showErrorHint:tips];
            }
            else if ([data isKindOfClass:[NSString class]]) {
                [TLUIUtility showErrorHint:(NSString *)data];
            }
        }
        [self loadHotSearchModuleWithModelArray:hotSearchData];
        if (completeAction) {
            completeAction(success, data);
        }
    }];
}

// 加载热搜模块
- (void)loadHotSearchModuleWithModelArray:(NSArray *)array
{
    NSInteger sectionTag = ZTSearchVCSectionTypeHot;
    self.sectionForTag(sectionTag).clear();
    if (array.count > 0) {
        self.addCell(@"ZTSearchSectionTitleCell").toSection(sectionTag).withDataModel(@{@"title" : @"热门搜索", @"line" : @"1"});
        self.addCells(@"ZTSearchWordCell").toSection(sectionTag).withDataModelArray(array).selectedAction(self.searchAction);
    }
    [self.collectionView reloadData];
}

// 加载记录模块
- (void)loadHistorySearchModule
{
    @weakify(self);
    NSArray *array = [[NSUserDefaults standardUserDefaults] objectForKey:KEY_SEARCH_HISTORY];
    NSInteger sectionTag = ZTSearchVCSectionTypeRecord;
    self.sectionForTag(sectionTag).clear();
    if (array.count > 0) {
        self.addCell(@"ZTSearchSectionTitleCell").toSection(sectionTag).withDataModel(@{@"title" : @"最近搜索", @"button" : @"清空", @"line" : @"1"})
        .eventAction(^id (NSInteger eventType, id data) {
            @strongify(self);
            UIAlertController *alertController = [UIAlertController alertControllerWithTitle:nil message:nil preferredStyle:UIAlertControllerStyleActionSheet];
            [alertController addAction:[UIAlertAction actionWithTitle:LOCSTR(@"清除最近搜索") style:UIAlertActionStyleDestructive handler:^(UIAlertAction * _Nonnull action) {
                @strongify(self);
                [[NSUserDefaults standardUserDefaults] removeObjectForKey:KEY_SEARCH_HISTORY];
                [self loadHistorySearchModule];
            }]];
            UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:LOCSTR(@"取消") style:UIAlertActionStyleCancel handler:nil];
            [cancelAction setValue:[UIColor colorPink] forKey:@"titleTextColor"];
            [alertController addAction:cancelAction];
            
            [[UIApplication sharedApplication].keyWindow.rootViewController presentViewController:alertController animated:YES completion:nil];
            return nil;
        });
        self.addCells(@"ZTSearchWordCell").toSection(sectionTag).withDataModelArray(array).selectedAction(self.searchAction);
    }
    [self.collectionView reloadData];
}

// 添加搜索记录
- (void)addHistorySearchWordRecord:(NSString *)word
{
    if (word.length == 0) {
        return;
    }
    NSMutableArray *array = [[[NSUserDefaults standardUserDefaults] objectForKey:KEY_SEARCH_HISTORY] mutableCopy];
    if (!array) {
        array = [[NSMutableArray alloc] init];
    }
    if ([array containsObject:word]) {
        [array removeObject:word];
    }
    [array insertObject:word atIndex:0];
    while (array.count > 3) {
        [array removeLastObject];
    }
    [[NSUserDefaults standardUserDefaults] setObject:array forKey:KEY_SEARCH_HISTORY];
    
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.3 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [self loadHistorySearchModule];
    });
}

@end
