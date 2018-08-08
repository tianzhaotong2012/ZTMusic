//
//  ZTSearchResultViewController.h
//  ZTMusic
//
//  Created by 李伯坤 on 2018/8/2.
//  Copyright © 2018年 李伯坤. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ZTSearchResultViewController : UIViewController <UISearchResultsUpdating, UISearchBarDelegate>

/// 搜索回调
@property (nonatomic, copy) void (^searchAction)(NSString *word);

- (void)startSearch:(NSString *)word;

@end
