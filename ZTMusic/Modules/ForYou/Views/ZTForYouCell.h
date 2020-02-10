//
//  ZTForYouCell.h
//  zhuanzhuan
//
//  Created by ZZUIHelper on 2020/2/10.
//  Copyright © 2017年 ZZUIHelper. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ZTForYouCell : UICollectionViewCell <ZZFlexibleLayoutViewProtocol>
@property (nonatomic, copy) id (^eventAction)(NSInteger eventType, id data);
@end
