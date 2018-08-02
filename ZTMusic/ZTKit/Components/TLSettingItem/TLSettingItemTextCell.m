//
//  TLSettingItemTextCell.m
//  LCGO
//
//  Created by lbk on 2018/4/12.
//  Copyright © 2018年 lbk. All rights reserved.
//

#import "TLSettingItemTextCell.h"

@interface TLSettingItemTextCell ()

@property (nonatomic, strong) UILabel *titleLabel;

@end

@implementation TLSettingItemTextCell

+ (CGFloat)viewHeightByDataModel:(TLSettingItem *)dataModel
{
    CGFloat height = [dataModel.title tt_sizeWithFont:[UIFont systemFontOfSize:15] constrainedToWidth:SCREEN_WIDTH - 20].height + 30;
    return height;
}

- (instancetype)initWithFrame:(CGRect)frame
{
    if (self = [super initWithFrame:frame]) {
        self.dk_backgroundColorPicker = DKColorPickerWithKey(WHITE);
        [self.arrowView setHidden:YES];
        
        self.titleLabel = self.contentView.addLabel(1)
        .font([UIFont boldSystemFontOfSize:16]).textColor([UIColor blackColor])
        .numberOfLines(0).font([UIFont systemFontOfSize:15])
        .masonry(^ (MASConstraintMaker *make) {
            make.top.mas_equalTo(15);
            make.left.mas_equalTo(10);
            make.right.mas_equalTo(-10);
            make.bottom.mas_equalTo(-15);
        })
        .view;
        self.titleLabel.dk_textColorPicker = DKColorPickerWithKey(BLACK);
    }
    return self;
}

- (void)setItem:(TLSettingItem *)item
{
    item.disableHighlight = YES;
    item.showDisclosureIndicator = NO;
    [super setItem:item];
    
    [self.titleLabel setText:LOCSTR(item.title)];
}

@end
