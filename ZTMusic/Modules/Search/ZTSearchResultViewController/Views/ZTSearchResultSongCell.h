//
//  ZTSearchResultSongCell.h
//  ZTMusic
//
//  Created by 李伯坤 on 2018/8/6.
//  Copyright © 2018年 李伯坤. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ZTSongModel.h"

@interface ZTSearchResultSongCell : UICollectionViewCell <ZZFlexibleLayoutViewProtocol>

@property (nonatomic, strong) ZTSongModel *songModel;

@end
