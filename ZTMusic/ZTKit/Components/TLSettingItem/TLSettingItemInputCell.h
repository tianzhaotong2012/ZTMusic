//
//  TLSettingItemInputCell.h
//  LCGO
//
//  Created by 李伯坤 on 2018/4/12.
//  Copyright © 2018年 李伯坤. All rights reserved.
//

#import "TLSettingItemBaseCell.h"

@interface TLSettingItemInputCell : TLSettingItemBaseCell

@property (nonatomic, copy) id (^eventAction)(NSInteger eventType, id data);

@end
