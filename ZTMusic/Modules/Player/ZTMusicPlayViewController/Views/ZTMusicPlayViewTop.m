//
//  ZTMusicPlayViewTop.m
//  zhuanzhuan
//
//  Created by ZZUIHelper on 2020/1/28.
//  Copyright © 2017年 ZZUIHelper. All rights reserved.
//

#import "ZTMusicPlayViewTop.h"

@interface ZTMusicPlayViewTop ()

@property (nonatomic, strong) UIImageView *imageView;

@property (nonatomic, strong) UILabel *titleLabel;

@property (nonatomic, strong) UILabel *userLabel;

@property (nonatomic, strong) UIButton *button;

@property (nonatomic, assign) BOOL withLine;

@end

@implementation ZTMusicPlayViewTop

+ (CGFloat)viewHeightByDataModel:(id)dataModel
{
    return SCREEN_WIDTH;
}

- (void)setViewDataModel:(ZTSongModel *)dataModel
{
    [self.imageView sd_setImageWithURL:dataModel.poster.toURL placeholderImage:[UIImage imageNamed:@"poster"]];
    [self.titleLabel setText:![LOCSTR(dataModel.title) isEqual:@""]?LOCSTR(dataModel.title):LOCSTR(@"未在播放")];
    [self.userLabel setText:![LOCSTR(dataModel.artist.artistName) isEqual:@""]?LOCSTR(dataModel.artist.artistName):LOCSTR(@"歌手")];
    
    [self setNeedsDisplay];
}

- (void)setViewEventAction:(id (^)(NSInteger, id))eventAction
{
    self.eventAction = eventAction;
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
        self.imageView = self.contentView.addImageView(1).cornerRadius(10).borderWidth(BORDER_WIDTH_1PX).borderColor([UIColor colorGrayForSeperator].CGColor)
        .contentMode(UIViewContentModeScaleAspectFill).clipsToBounds(YES)
        .masonry(^ (MASConstraintMaker *make) {
            make.left.mas_equalTo(50);
            make.top.mas_equalTo(40);
            make.bottom.mas_equalTo(-90);
            make.right.mas_equalTo(-50);
        })
        .view;
        
        self.titleLabel = self.contentView.addLabel(2)
        .font([UIFont boldSystemFontOfSize:15])
        .masonry(^ (MASConstraintMaker *make) {
            make.left.mas_equalTo(30);
            make.top.mas_equalTo(self.imageView.mas_bottom).mas_offset(25);
            make.right.mas_lessThanOrEqualTo(self.contentView);
        })
        .view;
        self.titleLabel.dk_textColorPicker = DKColorPickerWithKey(BLACK);
        
        self.userLabel = self.contentView.addLabel(2)
        .font([UIFont systemFontOfSize:15]).textColor([UIColor colorPink])
        .masonry(^ (MASConstraintMaker *make) {
            make.left.mas_equalTo(self.titleLabel.mas_left).mas_offset(0);
            make.top.mas_equalTo(self.titleLabel.mas_bottom).mas_offset(8);
            make.right.mas_lessThanOrEqualTo(self.contentView);
        })
        .view;
        
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
