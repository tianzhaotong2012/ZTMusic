//
//  ZTArtistViewController.h
//  zhuanzhuan
//
//  Created by ZZUIHelper on 2020/1/14.
//  Copyright © 2017年 ZZUIHelper. All rights reserved.
//

#import "ZZFlexibleLayoutViewController.h"

@interface ZTArtistViewController : ZZFlexibleLayoutViewController

@property (nonatomic, strong) NSString *artistId;
@property (nonatomic, strong) UIActivityIndicatorView *loadingView;

@end
