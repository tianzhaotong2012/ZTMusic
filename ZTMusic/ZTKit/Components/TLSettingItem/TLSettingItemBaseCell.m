//
//  TLSettingItemBaseCell.m
//  TLChat
//
//  Created by lbk on 2018/3/6.
//  Copyright © 2018年 lbk. All rights reserved.
//

#import "TLSettingItemBaseCell.h"

@implementation TLSettingItemBaseCell

#pragma mark - # Protocol
+ (CGFloat)viewHeightByDataModel:(id)dataModel
{
    return 52.0f;
}

- (void)setViewDataModel:(id)dataModel
{
    [self setItem:dataModel];
}

//- (void)viewIndexPath:(NSIndexPath *)indexPath sectionItemCount:(NSInteger)count
//{
//    if (indexPath.row == 0) {
//        self.addSeparator(ZZSeparatorPositionTop);
//    }
//    else {
//        self.removeSeparator(ZZSeparatorPositionTop);
//    }
//    if (indexPath.row == count - 1) {
//        self.addSeparator(ZZSeparatorPositionBottom);
//    }
//    else {
//        self.addSeparator(ZZSeparatorPositionBottom).beginAt(15);
//    }
//}

#pragma mark - # Cell
- (id)initWithFrame:(CGRect)frame
{
    if (self = [super initWithFrame:frame]) {
        self.dk_backgroundColorPicker = DKColorPickerWithKey(WHITE);
        [self setSelectedBackgrounColor:[UIColor colorGrayForSeperator]];
        
        // 箭头
        self.arrowView = self.addImageView(10)
        .image([UIImage imageNamed:@"right_arrow"])
        .masonry(^(MASConstraintMaker *make) {
            make.centerY.mas_equalTo(0);
            make.size.mas_equalTo(CGSizeMake(8, 13));
            make.right.mas_equalTo(-15);
        })
        .view;
    }
    return self;
}

- (void)setItem:(TLSettingItem *)item
{
    _item = item;
    
    [self setSelectedBackgrounColor:item.disableHighlight ? nil : [UIColor colorGrayForSeperator]];
    [self.arrowView setHidden:!item.showDisclosureIndicator];
}

@end
