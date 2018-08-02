//
//  ZZFlexibleLayoutSeperatorCell.m
//  ZZFlexibleLayoutFrameworkDemo
//
//  Created by 李伯坤 on 2016/12/27.
//  Copyright © 2016年 李伯坤. All rights reserved.
//

#import "ZZFlexibleLayoutSeperatorCell.h"

@implementation ZZFlexibleLayoutSeperatorModel

- (id)initWithSize:(CGSize)size andColor:(UIColor *)color
{
    if (self = [super init]) {
        self.size = size;
        self.color = color;
    }
    return self;
}

@end

@implementation ZZFlexibleLayoutSeperatorCell

+ (CGSize)viewSizeByDataModel:(ZZFlexibleLayoutSeperatorModel *)dataModel
{
    return dataModel.size;
}

- (id)initWithFrame:(CGRect)frame
{
    if (self = [super initWithFrame:frame]) {
        self.dk_backgroundColorPicker = DKColorPickerWithKey(WHITE);
    }
    return self;
}

- (void)setViewDataModel:(ZZFlexibleLayoutSeperatorModel *)dataModel
{
    if (dataModel.color) {
        [self setBackgroundColor:dataModel.color];
    }
}

@end
