//
//  TLSettingSectionFooterView.m
//  TLChat
//
//  Created by lbk on 2018/3/6.
//  Copyright © 2018年 lbk. All rights reserved.
//

#import "TLSettingSectionFooterView.h"

#define     FONT_SETTING_SECTION        [UIFont systemFontOfSize:14.0f]

@interface TLSettingSectionFooterView ()

@property (nonatomic, strong) UILabel *titleLabel;

@end

@implementation TLSettingSectionFooterView

#pragma mark - # Protocol
+ (CGFloat)viewHeightByDataModel:(NSString *)dataModel
{
    CGFloat textHeight = [dataModel tt_sizeWithFont:FONT_SETTING_SECTION constrainedToWidth:SCREEN_WIDTH - 30].height;
    return textHeight + 15;
}

- (void)setViewDataModel:(id)dataModel
{
    [self.titleLabel setText:LOCSTR(dataModel)];
}

#pragma mark - # View
- (instancetype)initWithFrame:(CGRect)frame
{
    if (self = [super initWithFrame:frame]) {
        self.titleLabel = self.addLabel(1)
        .font([UIFont boldSystemFontOfSize:14]).textColor([UIColor grayColor])
        .numberOfLines(0)
        .masonry(^ (MASConstraintMaker *make) {
            make.left.mas_equalTo(15);
            make.right.mas_equalTo(-15);
            make.top.mas_equalTo(8);
            make.bottom.mas_equalTo(-7);
        })
        .view;
    }
    return self;
}

@end
