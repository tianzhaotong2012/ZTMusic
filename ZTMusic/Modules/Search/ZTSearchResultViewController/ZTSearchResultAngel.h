//
//  ZTSearchResultAngel.h
//  ZTMusic
//
//  Created by 李伯坤 on 2018/8/2.
//  Copyright © 2018年 李伯坤. All rights reserved.
//

#import "ZZFLEXAngel.h"

@interface ZTSearchResultAngel : ZZFLEXAngel

@property(nonatomic,weak) UINavigationController *navigationController;

- (void)requestSearch:(NSString *)word completeAction:(LCBlockComplete)completeAction;

@end
