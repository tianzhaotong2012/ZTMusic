//
//  ZTForYouCell.m
//  zhuanzhuan
//
//  Created by ZZUIHelper on 2020/2/10.
//  Copyright © 2017年 ZZUIHelper. All rights reserved.
//

#import "ZTForYouCell.h"
#import "ZTSongModel.h"

@interface ZTForYouCell ()

@property (nonatomic, strong) UIImageView *imageView;
@property (nonatomic, strong) UILabel *titleLabel;
@property (nonatomic, strong) UILabel *userLabel;

@end

@implementation ZTForYouCell

#pragma mark - # ZZFlexibleLayoutViewProtocol
+ (CGSize)viewSizeByDataModel:(id)dataModel{
    return CGSizeMake(SCREEN_WIDTH/2, SCREEN_WIDTH/2 * 1.3);
}

- (void)setViewDataModel:(ZTSongModel *)dataModel
{
    [self.imageView sd_setImageWithURL:dataModel.poster.toURL];
    [self.titleLabel setText:LOCSTR(dataModel.title)];
    [self.userLabel setText:LOCSTR(dataModel.artist.artistName)];
    [self setNeedsDisplay];
}

- (void)setViewEventAction:(id (^)(NSInteger, id))eventAction
{
    self.eventAction = eventAction;
}

- (void)viewIndexPath:(NSIndexPath *)indexPath sectionItemCount:(NSInteger)count
{
//    if (indexPath.row == 1) {
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
}

- (instancetype)initWithFrame:(CGRect)frame
{
    if (self = [super initWithFrame:frame]) {
        self.imageView = self.contentView.addImageView(1).cornerRadius(5).borderWidth(BORDER_WIDTH_1PX).borderColor([UIColor colorGrayForSeperator].CGColor)
        .contentMode(UIViewContentModeScaleAspectFill).clipsToBounds(YES)
        .masonry(^ (MASConstraintMaker *make) {
            make.left.mas_equalTo(12.5);
            make.top.mas_equalTo(15);
            make.bottom.mas_equalTo(-SCREEN_WIDTH/2 * 0.35);
            make.width.mas_equalTo(SCREEN_WIDTH/2 - 25);
        })
        .view;
        
        self.titleLabel = self.contentView.addLabel(2)
        .font([UIFont boldSystemFontOfSize:15])
        .masonry(^ (MASConstraintMaker *make) {
            make.left.mas_equalTo(self.imageView.mas_left).mas_offset(5);
            make.top.mas_equalTo(self.imageView.mas_bottom).mas_offset(15);
            make.right.mas_lessThanOrEqualTo(self.contentView);
        })
        .view;
        self.titleLabel.dk_textColorPicker = DKColorPickerWithKey(BLACK);
        
    }
    return self;
}

@end
