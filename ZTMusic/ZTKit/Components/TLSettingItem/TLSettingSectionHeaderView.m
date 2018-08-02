//
//  TLSettingSectionHeaderView.m
//  TLChat
//
//  Created by lbk on 2018/3/6.
//  Copyright © 2018年 lbk. All rights reserved.
//

#import "TLSettingSectionHeaderView.h"

#define     FONT_SETTING_SECTION        [UIFont systemFontOfSize:14.0f]

@implementation TLSettingSectionHeaderView

#pragma mark - # Protocol
+ (CGFloat)viewHeightByDataModel:(NSString *)dataModel
{
    CGFloat textHeight = [dataModel tt_sizeWithFont:FONT_SETTING_SECTION constrainedToWidth:SCREEN_WIDTH - 30].height;
    return textHeight + 20;
}

- (void)setViewDataModel:(id)dataModel
{
    [self.titleLabel setText:LOCSTR(dataModel)];
}

#pragma mark - # View
- (instancetype)initWithFrame:(CGRect)frame
{
    if (self = [super initWithFrame:frame]) {
        self.titleLabel = self.addLabel(1).numberOfLines(0)
        .font([UIFont boldSystemFontOfSize:14]).textColor([UIColor grayColor])
        .masonry(^ (MASConstraintMaker *make) {
            make.left.mas_equalTo(15);
            make.right.mas_equalTo(-15);
            make.bottom.mas_equalTo(-7);
            make.top.mas_equalTo(12);
        })
        .view;
    }
    return self;
}

@end
