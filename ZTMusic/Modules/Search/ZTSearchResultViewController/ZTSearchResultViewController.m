//
//  ZTSearchResultViewController.m
//  ZTMusic
//
//  Created by 李伯坤 on 2018/8/2.
//  Copyright © 2018年 李伯坤. All rights reserved.
//

#import "ZTSearchResultViewController.h"
#import "ZTSearchResultAngel.h"

@interface ZTSearchResultViewController ()

@property (nonatomic, strong) UICollectionView *collectionView;

@property (nonatomic, strong) ZTSearchResultAngel *angel;

@property (nonatomic, strong) NSString *keyword;

@end

@implementation ZTSearchResultViewController

- (void)loadView
{
    [super loadView];
    [self setEdgesForExtendedLayout:UIRectEdgeNone];
    self.collectionView = self.view.addCollectionView(0).frame(self.view.bounds).backgroundColor([UIColor clearColor]).alwaysBounceVertical(YES).view;
    self.collectionView.dk_backgroundColorPicker = DKColorPickerWithKey(GRAY_BG);
    self.angel = [[ZTSearchResultAngel alloc] initWithHostView:self.collectionView];
    self.angel.navigationController = self.navigationController;
}

- (void)startSearch:(NSString *)word
{
    if (self.searchAction) {
        self.searchAction(word);
    }
    
    [TLUIUtility showLoading:nil];
    [self.angel requestSearch:word completeAction:^(BOOL success, id data) {
        [TLUIUtility hiddenLoading];
    }];
}

#pragma mark - # Delegate
//MARK: UISearchBarDelegate
- (BOOL)searchBar:(UISearchBar *)searchBar shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text
{
    if ([text isEqualToString:@"\n"]) {
        [self startSearch:searchBar.text];
        [searchBar resignFirstResponder];
        return NO;
    }
    return YES;
}

//MARK: UISearchResultsUpdating
- (void)updateSearchResultsForSearchController:(UISearchController *)searchController {
    if (![self.keyword isEqualToString:searchController.searchBar.text]) {
        self.keyword = searchController.searchBar.text;
        self.angel.clear();
        [self.collectionView reloadData];
    }
}

@end
