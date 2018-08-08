//
//  ZTSearchWordCell.m
//  ZTMusic
//
//  Created by 李伯坤 on 2018/8/2.
//  Copyright © 2018年 李伯坤. All rights reserved.
//

#import "ZTSearchWordCell.h"

@interface ZTSearchWordCell ()

@property (nonatomic, strong) UILabel *titleLabel;

@end

@implementation ZTSearchWordCell

+ (CGFloat)viewHeightByDataModel:(id)dataModel
{
    return 52.0f;
}

- (void)setViewDataModel:(id)dataModel
{
    [self.titleLabel setText:dataModel];
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
        [self setSelectedBackgrounColor:[UIColor colorPink]];
        self.titleLabel = self.contentView.addLabel(0)
        .font([UIFont systemFontOfSize:22]).textColor([UIColor colorPink]).adjustsFontSizeToFitWidth(YES)
        .masonry(^(MASConstraintMaker *make) {
            make.left.mas_equalTo(15);
            make.centerY.mas_equalTo(0);
        })
        .view;
    }
    return self;
}

- (void)setHighlighted:(BOOL)highlighted
{
    [super setHighlighted:highlighted];
    
    UIColor *textColor = highlighted ? [UIColor whiteColor] : [UIColor colorPink];
    self.titleLabel.zz_make.textColor(textColor);
}

@end
