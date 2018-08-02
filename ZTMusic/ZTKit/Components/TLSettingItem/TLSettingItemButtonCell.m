//
//  TLSettingItemButtonCell.m
//  TLChat
//
//  Created by lbk on 2018/3/6.
//  Copyright © 2018年 lbk. All rights reserved.
//

#import "TLSettingItemButtonCell.h"

@interface TLSettingItemButtonCell ()

@property (nonatomic, strong) UILabel *titleLabel;

@end

@implementation TLSettingItemButtonCell

- (instancetype)initWithFrame:(CGRect)frame
{
    if (self = [super initWithFrame:frame]) {
        [self.arrowView setHidden:YES];
        
        self.titleLabel = self.contentView.addLabel(1)
        .font([UIFont boldSystemFontOfSize:16]).textColor([UIColor blackColor])
        .masonry(^ (MASConstraintMaker *make) {
            make.center.mas_equalTo(0);
            make.width.mas_lessThanOrEqualTo(self.contentView);
        })
        .view;
        self.titleLabel.dk_textColorPicker = DKColorPickerWithKey(BLACK);
    }
    return self;
}

- (void)setItem:(TLSettingItem *)item
{
    item.showDisclosureIndicator = NO;
    [super setItem:item];
    
    [self.titleLabel setText:LOCSTR(item.title)];
    
    if (item.userInfo && [item.userInfo isKindOfClass:[NSDictionary class]]) {
        UIColor *textColor = [item.userInfo objectForKey:@"textColor"];
        if (textColor) {
            [self.titleLabel setTextColor:textColor];
        }
    }
}

@end
