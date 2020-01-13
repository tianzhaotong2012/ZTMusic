//
//  ZTStyleACell.m
//  zhuanzhuan
//
//  Created by ZZUIHelper on 2020/1/13.
//  Copyright © 2017年 ZZUIHelper. All rights reserved.
//

#import "ZTStyleACell.h"

@interface ZTStyleACell ()

@property (nonatomic, strong) UIImageView *imageView;
@property (nonatomic, strong) UILabel *titleLabel;
@property (nonatomic, strong) UILabel *userLabel;

@end

@implementation ZTStyleACell

+ (CGFloat)viewHeightByDataModel:(id)dataModel
{
    return 228;
}

- (void)setViewDataModel:(ZTSongModel *)dataModel
{
    self.songModel = dataModel;
    [self.imageView sd_setImageWithURL:dataModel.poster.toURL];
    [self.titleLabel setText:dataModel.title];
    [self.userLabel setText:dataModel.artist.artistName];
}

- (void)viewIndexPath:(NSIndexPath *)indexPath sectionItemCount:(NSInteger)count
{
    if (indexPath.row == 1) {
        self.addSeparator(ZZSeparatorPositionTop);
    }
    else {
        self.removeSeparator(ZZSeparatorPositionTop);
    }
    if (indexPath.row == count - 1) {
        self.addSeparator(ZZSeparatorPositionBottom);
    }
    else {
        self.addSeparator(ZZSeparatorPositionBottom).beginAt(15);
    }
}

- (instancetype)initWithFrame:(CGRect)frame
{
    if (self = [super initWithFrame:frame]) {
        self.dk_backgroundColorPicker = DKColorPickerWithKey(WHITE);
        [self setSelectedBackgrounColor:[UIColor colorGrayForSeperator]];
        
        [self initSRSongCellSubviews];
    }
    return self;
}

- (void)initSRSongCellSubviews
{
    self.imageView = self.contentView.addImageView(0).contentMode(UIViewContentModeScaleAspectFill)
    .cornerRadius(5).borderWidth(BORDER_WIDTH_1PX).borderColor([UIColor colorGrayForSeperator].CGColor)
    .masonry(^ (MASConstraintMaker *make) {
        make.left.mas_equalTo(15);
        make.top.mas_equalTo(12);
        make.bottom.mas_equalTo(-60);
        make.width.mas_equalTo(168);
    })
    .view;
    
    self.titleLabel = self.contentView.addLabel(1)
    .font([UIFont systemFontOfSize:17])
    .masonry(^ (MASConstraintMaker *make) {
        make.left.mas_equalTo(self.imageView.mas_left).mas_offset(0);
        make.top.mas_equalTo(self.imageView.mas_bottom).mas_offset(12);
    })
    .view;
    self.titleLabel.dk_textColorPicker = DKColorPickerWithKey(BLACK);
    
    self.userLabel = self.contentView.addLabel(2)
    .font([UIFont systemFontOfSize:14]).textColor([UIColor lightGrayColor])
    .masonry(^ (MASConstraintMaker *make) {
        make.left.mas_equalTo(self.titleLabel);
        make.bottom.mas_equalTo(self.titleLabel).mas_offset(18);
    })
    .view;
}


@end
