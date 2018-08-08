//
//  ZTSearchResultArtistCell.m
//  ZTMusic
//
//  Created by 李伯坤 on 2018/8/7.
//  Copyright © 2018年 李伯坤. All rights reserved.
//

#import "ZTSearchResultArtistCell.h"

@interface ZTSearchResultArtistCell ()

@property (nonatomic, strong) UIImageView *imageView;
@property (nonatomic, strong) UILabel *titleLabel;

@end


@implementation ZTSearchResultArtistCell

+ (CGFloat)viewHeightByDataModel:(id)dataModel
{
    return 84;
}

- (void)setViewDataModel:(ZTArtistModel *)dataModel
{
    self.artistModel = dataModel;
    [self.imageView sd_setImageWithURL:dataModel.artistPoster.toURL];
    [self.titleLabel setText:dataModel.artistName];
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
    .cornerRadius(30).borderWidth(BORDER_WIDTH_1PX).borderColor([UIColor colorGrayForSeperator].CGColor)
    .masonry(^ (MASConstraintMaker *make) {
        make.left.mas_equalTo(15);
        make.top.mas_equalTo(12);
        make.bottom.mas_equalTo(-12);
        make.width.mas_equalTo(60);
    })
    .view;
    
    self.titleLabel = self.contentView.addLabel(1)
    .font([UIFont systemFontOfSize:17])
    .masonry(^ (MASConstraintMaker *make) {
        make.left.mas_equalTo(self.imageView.mas_right).mas_offset(12);
        make.centerY.mas_equalTo(self.imageView);
    })
    .view;
    self.titleLabel.dk_textColorPicker = DKColorPickerWithKey(BLACK);
    
    self.addImageView(2).image([UIImage imageNamed:@"right_arrow"])
    .masonry(^(MASConstraintMaker *make) {
        make.centerY.mas_equalTo(0);
        make.size.mas_equalTo(CGSizeMake(8, 13));
        make.right.mas_equalTo(-15);
    });
}

@end
