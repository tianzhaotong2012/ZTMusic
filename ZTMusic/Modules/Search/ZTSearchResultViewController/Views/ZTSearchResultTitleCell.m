//
//  ZTSearchResultTitleCell.m
//  ZTMusic
//
//  Created by 李伯坤 on 2018/8/7.
//  Copyright © 2018年 李伯坤. All rights reserved.
//

#import "ZTSearchResultTitleCell.h"

@implementation ZTSearchResultTitleCell

- (instancetype)initWithFrame:(CGRect)frame
{
    if (self = [super initWithFrame:frame]) {
        self.dk_backgroundColorPicker = DKColorPickerWithKey(GRAY_BG);
    }
    return self;
}

@end
