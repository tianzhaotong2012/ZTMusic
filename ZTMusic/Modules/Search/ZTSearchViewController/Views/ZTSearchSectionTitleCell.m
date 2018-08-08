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

@property (nonatomic, strong) UIButton *button;

@property (nonatomic, assign) BOOL withLine;

@end

@implementation ZTSearchSectionTitleCell

+ (CGFloat)viewHeightByDataModel:(id)dataModel
{
    return 58.0f;
}

- (void)setViewDataModel:(id)dataModel
{
    [self.titleLabel setText:LOCSTR(dataModel[@"title"])];
    self.button.zz_make.title(LOCSTR(dataModel[@"button"]));
    self.withLine = [dataModel[@"line"] boolValue];
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
        self.titleLabel = self.contentView.addLabel(0)
        .font([UIFont boldSystemFontOfSize:19]).adjustsFontSizeToFitWidth(YES)
        .masonry(^(MASConstraintMaker *make) {
            make.left.mas_equalTo(15);
            make.bottom.mas_equalTo(-8);
        })
        .view;
        [self.titleLabel dk_setTextColorPicker:DKColorPickerWithKey(BLACK)];
        
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
