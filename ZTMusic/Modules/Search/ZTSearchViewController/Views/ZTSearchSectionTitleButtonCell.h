//
//  ZTSearchSectionTitleButtonCell.h
//  ZTMusic
//
//  Created by 李伯坤 on 2018/8/2.
//  Copyright © 2018年 李伯坤. All rights reserved.
//

#import "ZTSearchSectionTitleCell.h"

@interface ZTSearchSectionTitleButtonCell : ZTSearchSectionTitleCell

@property (nonatomic, copy) id (^eventAction)(NSInteger eventType, id data);

@end
