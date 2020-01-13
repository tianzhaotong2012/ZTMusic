//
//  ZTExploreSectionTitleCell.h
//  zhuanzhuan
//
//  Created by ZZUIHelper on 2020/1/13.
//  Copyright © 2017年 ZZUIHelper. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ZTExploreSectionTitleCell : UICollectionViewCell <ZZFlexibleLayoutViewProtocol>
@property (nonatomic, copy) id (^eventAction)(NSInteger eventType, id data);

@end
