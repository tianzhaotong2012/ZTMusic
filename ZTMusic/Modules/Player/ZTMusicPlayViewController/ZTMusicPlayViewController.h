//
//  ZTMusicPlayViewController.h
//  ZTMusic
//
//  Created by 李伯坤 on 2018/8/7.
//  Copyright © 2018年 李伯坤. All rights reserved.
//

#import "ZZFlexibleLayoutViewController.h"
#import "ZTSongModel.h"

@interface ZTMusicPlayViewController : ZZFlexibleLayoutViewController

+ (ZTMusicPlayViewController *)sharedInstance;

- (void)startPlayMusic:(ZTSongModel *)musicModel;

@end
