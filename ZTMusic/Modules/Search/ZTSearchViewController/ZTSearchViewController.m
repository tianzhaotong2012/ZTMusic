//
//  ZTSearchViewController.m
//  ZTMusic
//
//  Created by 李伯坤 on 2018/7/31.
//  Copyright © 2018年 李伯坤. All rights reserved.
//

#import "ZTSearchViewController.h"
#import "ZTSearchAngel.h"
#import "ZTSearchResultViewController.h"

@interface ZTSearchViewController ()

@property (nonatomic, strong) UIActivityIndicatorView *loadingView;
@property (nonatomic, strong) UISearchController *searchController;
@property (nonatomic, strong) UICollectionView *collectionView;
@property (nonatomic, strong) ZTSearchAngel *searchAngel;
@property (nonatomic, strong) ZTSearchResultViewController *resultVC;

@end

@implementation ZTSearchViewController

- (void)loadView {
    [super loadView];
    [self.navigationItem setTitle:LOCSTR(@"搜索")];
    [self.view dk_setBackgroundColorPicker:DKColorPickerWithKey(WHITE)];
    self.definesPresentationContext = YES;
    
    [self loadSearchVCUI];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    [self requestData];
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    
    [self p_hiddenNavBarBottomLine:self.searchController.searchBar.superview];
}

#pragma mark - # Request
- (void)requestData
{
    @weakify(self);
    [self.loadingView startAnimating];
    [self.searchAngel requestHotSearchModuleWithCompleteAction:^(BOOL success, id data) {
        @strongify(self);
        [self.loadingView stopAnimating];
    }];
}

- (void)showSearchViewAndSearh:(NSString *)word
{
    [self.searchController.searchBar setText:word];
    [self.searchController setActive:YES];
    [self.resultVC startSearch:word];
}

#pragma mark - # UI
- (void)loadSearchVCUI
{
    @weakify(self);
    self.loadingView = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleGray];
    [self.navigationItem setRightBarButtonItem:[[UIBarButtonItem alloc] initWithCustomView:self.loadingView]];
    
    [self addChildViewController:self.resultVC];
    if (@available(iOS 11.0, *)) {
        self.navigationItem.searchController = self.searchController;
        self.navigationItem.hidesSearchBarWhenScrolling = NO;
    }
    else {
    }
    
    self.collectionView = self.view.addCollectionView(0).backgroundColor([UIColor clearColor])
    .masonry(^ (MASConstraintMaker *make) {
        make.edges.mas_equalTo(0);
    }).view;
    
    self.searchAngel = [[ZTSearchAngel alloc] initWithHostView:self.collectionView searchAction:^(NSString *word) {
        @strongify(self);
        [self showSearchViewAndSearh:word];
    }];
    [self.searchAngel loadHistorySearchModule];
}

#pragma mark - # Private Methods
- (void)p_hiddenNavBarBottomLine:(UIView *)view {
    if ([view isKindOfClass:UIImageView.class] && view.bounds.size.height <= 1.0) {
        [view setHidden:YES];
    }
    for (UIView *subview in view.subviews) {
        [self p_hiddenNavBarBottomLine:subview];
    }
}

#pragma mark - # Getters
- (UISearchController *)searchController
{
    if (!_searchController) {
        UISearchController *searchController = [[UISearchController alloc] initWithSearchResultsController:self.resultVC];
        [searchController.searchBar dk_setTintColorPicker:DKColorPickerWithKey(TINT)];
        [searchController.searchBar dk_setBarTintColorPicker:DKColorPickerWithKey(WHITE)];
        [searchController.searchBar dk_setBackgroundColorPicker:DKColorPickerWithKey(WHITE)];
        [searchController.searchBar setPlaceholder:LOCSTR(@"音乐")];
        [searchController.searchBar setScopeButtonTitles:@[LOCSTR(@"网络"), LOCSTR(@"资料库")]];
        searchController.searchResultsUpdater = self.resultVC;
        searchController.searchBar.delegate = self.resultVC;
        _searchController = searchController;
    }
    return _searchController;
}

- (ZTSearchResultViewController *)resultVC
{
    if (!_resultVC) {
        @weakify(self);
        ZTSearchResultViewController *resultVC = [[ZTSearchResultViewController alloc] init];
        [resultVC setSearchAction:^(NSString *word) {
            @strongify(self);
            [self.searchAngel addHistorySearchWordRecord:word];
        }];
        _resultVC = resultVC;
    }
    return _resultVC;
}

@end
