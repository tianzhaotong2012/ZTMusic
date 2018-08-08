//
//  ZTLibraryCateCell.m
//  ZTMusic
//
//  Created by 李伯坤 on 2018/8/7.
//  Copyright © 2018年 李伯坤. All rights reserved.
//

#import "ZTLibraryCateCell.h"
#import "ZTLibraryCateModel.h"

@interface ZTLibraryCateCell ()

@property (nonatomic, strong) UILabel *titleLabel;
@property (nonatomic, strong) UIImageView *iconView;

@property (nonatomic, strong) ZTLibraryCateModel *cateModel;

@end

@implementation ZTLibraryCateCell

+ (CGSize)viewSizeByDataModel:(id)dataModel
{
    NSInteger width = (SCREEN_WIDTH - 20 * 3) / 2.0;
    return CGSizeMake(width, 43);
}

- (void)setViewDataModel:(ZTLibraryCateModel *)dataModel
{
    self.cateModel = dataModel;
    [self.titleLabel setText:LOCSTR(dataModel.title)];
    [self.iconView setImage:dataModel.icon ? [UIImage imageNamed:dataModel.icon] : nil];
}

- (instancetype)initWithFrame:(CGRect)frame
{
    if (self = [super initWithFrame:frame]) {
        self.dk_backgroundColorPicker = DKColorPickerWithKey(GRAY_BG);
        [self setSelectedBackgrounColor:[UIColor colorPink]];
        self.zz_make.cornerRadius(8.0f);
        
        self.iconView = self.contentView.addImageView(1)
        .contentMode(UIViewContentModeScaleAspectFill)
        .masonry(^(MASConstraintMaker *make) {
            make.right.mas_equalTo(-15);
            make.centerY.mas_equalTo(0);
            make.size.mas_equalTo(17);
        })
        .view;
        
        self.titleLabel = self.contentView.addLabel(0)
        .font([UIFont boldSystemFontOfSize:17]).textColor([UIColor colorPink]).adjustsFontSizeToFitWidth(YES)
        .masonry(^(MASConstraintMaker *make) {
            make.left.mas_equalTo(12);
            make.centerY.mas_equalTo(0);
            make.right.mas_lessThanOrEqualTo(self.iconView.mas_left);
        })
        .view;
    }
    return self;
}

- (void)setHighlighted:(BOOL)highlighted
{
    [super setHighlighted:highlighted];
    
    UIImage *image = self.cateModel.icon ? [UIImage imageNamed:self.cateModel.icon] : nil;
    if (highlighted) {
        image = [image imageWithColor:[UIColor whiteColor]];
    }
    [self.iconView setImage:image];
    UIColor *textColor = highlighted ? [UIColor whiteColor] : [UIColor colorPink];
    self.titleLabel.zz_make.textColor(textColor);
    
}

@end
