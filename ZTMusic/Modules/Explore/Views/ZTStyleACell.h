//
//  ZTStyleACell.h
//  zhuanzhuan
//
//  Created by ZZUIHelper on 2020/1/13.
//  Copyright © 2017年 ZZUIHelper. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ZTSongModel.h"

@interface ZTStyleACell : UICollectionViewCell <ZZFlexibleLayoutViewProtocol>

@property (nonatomic, strong) ZZFLEXAngel *angel;
@property (nonatomic, strong) NSArray *songArray;

@end
