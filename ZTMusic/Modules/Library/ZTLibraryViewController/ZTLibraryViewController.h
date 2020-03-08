//
//  ZTLibraryViewController.h
//  ZTMusic
//
//  Created by 李伯坤 on 2018/7/31.
//  Copyright © 2018年 李伯坤. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ZTSongModel.h"

@interface ZTLibraryViewController : ZZFlexibleLayoutViewController

@property (nonatomic, strong) NSArray<ZTSongModel *> *recentSongs;

@end
