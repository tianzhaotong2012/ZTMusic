//
//  TLSettingItemSwitchCell.m
//  TLChat
//
//  Created by 李伯坤 on 2018/3/7.
//  Copyright © 2018年 李伯坤. All rights reserved.
//

#import "TLSettingItemSwitchCell.h"

@interface TLSettingItemSwitchCell ()

@property (nonatomic, strong) UILabel *titleLabel;

@property (nonatomic, strong) UISwitch *switchControl;

@end

@implementation TLSettingItemSwitchCell

- (void)setViewEventAction:(id (^)(NSInteger, id))eventAction{
    self.eventAction = eventAction;
}

- (id)initWithFrame:(CGRect)frame
{
    if (self = [super initWithFrame:frame]) {
        [self p_initSettingItemSwitchCellSubviews];
    }
    return self;
}

- (void)setItem:(TLSettingItem *)item
{
    item.showDisclosureIndicator = NO;
    item.disableHighlight = YES;
    [super setItem:item];
    
    [self.titleLabel setText:LOCSTR(item.title)];
    [self.switchControl setOn:item.subTitle.boolValue];
}

#pragma mark - # UI
- (void)p_initSettingItemSwitchCellSubviews
{
    @weakify(self);
    self.titleLabel = self.contentView.addLabel(1)
    .font([UIFont boldSystemFontOfSize:16]).textColor([UIColor blackColor])
    .masonry(^(MASConstraintMaker *make) {
        make.centerY.mas_equalTo(0);
        make.left.mas_equalTo(15);
        make.right.mas_lessThanOrEqualTo(-80);
    })
    .view;
    self.titleLabel.dk_textColorPicker = DKColorPickerWithKey(BLACK);
    
    self.switchControl = self.contentView.addSwitch(2)
    .masonry(^(MASConstraintMaker *make) {
        make.centerY.mas_equalTo(0);
        make.right.mas_lessThanOrEqualTo(-15);
    })
    .eventBlock(UIControlEventValueChanged, ^(UISwitch *sender) {
        @strongify(self);
        if (self.eventAction) {
            self.eventAction(0, @(sender.on).stringValue);
        }
    })
    .view;

}
@end
