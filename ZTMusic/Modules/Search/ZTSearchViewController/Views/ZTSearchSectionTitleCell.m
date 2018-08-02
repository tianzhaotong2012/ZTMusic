//
//  ZTSearchSectionTitleCell.m
//  ZTMusic
//
//  Created by 李伯坤 on 2018/8/2.
//  Copyright © 2018年 李伯坤. All rights reserved.
//

#import "ZTSearchSectionTitleCell.h"

@interface ZTSearchSectionTitleCell ()

@property (nonatomic, strong) UILabel *titleLabel;

@end

@implementation ZTSearchSectionTitleCell

+ (CGFloat)viewHeightByDataModel:(id)dataModel
{
    return 50.0f;
}

- (void)setViewDataModel:(id)dataModel
{
    [self.titleLabel setText:LOCSTR(dataModel)];
}

- (void)viewIndexPath:(NSIndexPath *)indexPath sectionItemCount:(NSInteger)count
{
    if (indexPath.row < count - 1) {
        self.addSeparator(ZZSeparatorPositionBottom).beginAt(15);
    }
    else {
        self.removeSeparator(ZZSeparatorPositionBottom);
    }
}

- (instancetype)initWithFrame:(CGRect)frame
{
    if (self = [super initWithFrame:frame]) {
        [self setBackgroundColor:[UIColor whiteColor]];
        
        self.titleLabel = self.contentView.addLabel(0)
        .font([UIFont boldSystemFontOfSize:19]).adjustsFontSizeToFitWidth(YES)
        .masonry(^(MASConstraintMaker *make) {
            make.left.mas_equalTo(15);
            make.bottom.mas_equalTo(-8);
        })
        .view;
    }
    return self;
}

@end
