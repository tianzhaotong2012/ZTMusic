//
//  ZTMusicPlayViewTop.h
//  zhuanzhuan
//
//  Created by ZZUIHelper on 2020/1/28.
//  Copyright © 2017年 ZZUIHelper. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ZTSongModel.h"

@interface ZTMusicPlayViewTop : UICollectionViewCell <ZZFlexibleLayoutViewProtocol>
@property (nonatomic, copy) id (^eventAction)(NSInteger eventType, id data);
@end
