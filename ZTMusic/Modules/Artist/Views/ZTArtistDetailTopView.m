//
//  ZTArtistDetailTopView.m
//  zhuanzhuan
//
//  Created by ZZUIHelper on 2020/1/14.
//  Copyright © 2017年 ZZUIHelper. All rights reserved.
//

#import "ZTArtistDetailTopView.h"
#import "ZTArtistDetailModel.h"

@interface ZTArtistDetailTopView ()

@property (nonatomic, strong) UIImageView *imageView;

@property (nonatomic, strong) UILabel *titleLabel;

@property (nonatomic, strong) UIButton *button;

@property (nonatomic, assign) BOOL withLine;

@end

@implementation ZTArtistDetailTopView

+ (CGFloat)viewHeightByDataModel:(id)dataModel
{
    return 168.0f;
}

- (void)setViewDataModel:(ZTArtistDetailModel *)dataModel
{
    [self.imageView sd_setImageWithURL:dataModel.artist.artistPoster.toURL];
    [self.titleLabel setText:LOCSTR(dataModel.artist.artistName)];
    [self setNeedsDisplay];
}

- (void)setViewEventAction:(id (^)(NSInteger, id))eventAction
{
    self.eventAction = eventAction;
}

- (void)viewIndexPath:(NSIndexPath *)indexPath sectionItemCount:(NSInteger)count
{
    if (self.withLine) {
        if (indexPath.row < count - 1) {
            self.addSeparator(ZZSeparatorPositionBottom).beginAt(15);
        }
        else {
            self.removeSeparator(ZZSeparatorPositionBottom);
        }
    }
}

- (instancetype)initWithFrame:(CGRect)frame
{
    if (self = [super initWithFrame:frame]) {
        self.imageView = self.contentView.addImageView(1).cornerRadius(5).borderWidth(BORDER_WIDTH_1PX).borderColor([UIColor colorGrayForSeperator].CGColor)
        .contentMode(UIViewContentModeScaleAspectFill).clipsToBounds(YES)
        .masonry(^ (MASConstraintMaker *make) {
            make.left.mas_equalTo(15);
            make.top.mas_equalTo(15);
            make.bottom.mas_equalTo(-15);
            make.width.mas_equalTo(138);
        })
        .view;
        
        self.titleLabel = self.contentView.addLabel(2)
        .font([UIFont boldSystemFontOfSize:15])
        .masonry(^ (MASConstraintMaker *make) {
            make.left.mas_equalTo(self.imageView.mas_right).mas_offset(12);
            make.top.mas_equalTo(self.imageView.mas_top).mas_offset(15);
            make.right.mas_lessThanOrEqualTo(self.contentView);
        })
        .view;
        self.titleLabel.dk_textColorPicker = DKColorPickerWithKey(BLACK);
        
        @weakify(self);
        self.button = self.contentView.addButton(1)
        .titleColor([UIColor colorPink]).titleFont([UIFont systemFontOfSize:16])
        .eventBlock(UIControlEventTouchUpInside, ^(UIButton *sender) {
            if (self.eventAction) {
                self.eventAction(0, nil);
            }
        })
        .masonry(^ (MASConstraintMaker *make) {
            make.right.mas_equalTo(-15);
            make.bottom.mas_equalTo(-3);
        })
        .view;
    }
    return self;
}

@end
