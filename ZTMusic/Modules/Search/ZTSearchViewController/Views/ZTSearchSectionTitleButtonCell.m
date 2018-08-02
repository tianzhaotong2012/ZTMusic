//
//  ZTSearchSectionTitleButtonCell.m
//  ZTMusic
//
//  Created by 李伯坤 on 2018/8/2.
//  Copyright © 2018年 李伯坤. All rights reserved.
//

#import "ZTSearchSectionTitleButtonCell.h"

@interface ZTSearchSectionTitleButtonCell ()

@property (nonatomic, strong) UIButton *button;

@end

@implementation ZTSearchSectionTitleButtonCell

- (void)setViewDataModel:(NSDictionary *)dataModel
{
    [super setViewDataModel:dataModel[@"title"]];
    self.button.zz_make.title(LOCSTR(dataModel[@"button"]));
}

- (void)setViewEventAction:(id (^)(NSInteger, id))eventAction
{
    self.eventAction = eventAction;
}

- (instancetype)initWithFrame:(CGRect)frame
{
    if (self = [super initWithFrame:frame]) {
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
