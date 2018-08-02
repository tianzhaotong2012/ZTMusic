//
//  TLSettingItemInputCell.m
//  LCGO
//
//  Created by lbk on 2018/4/12.
//  Copyright © 2018年 lbk. All rights reserved.
//

#import "TLSettingItemInputCell.h"

@interface TLSettingItemInputCell () <UITextFieldDelegate>

@property (nonatomic, strong) UILabel *titleLabel;

@property (nonatomic, strong) UITextField *textField;

@end

@implementation TLSettingItemInputCell

- (void)setViewEventAction:(id (^)(NSInteger, id))eventAction
{
    self.eventAction = eventAction;
}

- (id)initWithFrame:(CGRect)frame
{
    if (self = [super initWithFrame:frame]) {
        [self p_initSettingItemSubviews];
    }
    return self;
}

- (void)setItem:(TLSettingItem *)item
{
    item.disableHighlight = YES;
    item.showDisclosureIndicator = NO;
    [super setItem:item];
    
    [self.titleLabel setText:LOCSTR(item.title)];
    [self.textField setText:item.subTitle];
    [self.textField setPlaceholder:item.userInfo];
}

#pragma mark - # UI
- (void)p_initSettingItemSubviews
{
    self.titleLabel = self.contentView.addLabel(1)
    .font([UIFont boldSystemFontOfSize:16]).textColor([UIColor blackColor])
    .masonry(^(MASConstraintMaker *make) {
        make.centerY.mas_equalTo(0);
        make.left.mas_equalTo(15);
        make.width.mas_equalTo(70);
    })
    .view;
    self.titleLabel.dk_textColorPicker = DKColorPickerWithKey(BLACK);
    
    @weakify(self);
    self.textField = self.contentView.addTextField(1).delegate(self)
    .font([UIFont boldSystemFontOfSize:16]).clearButtonMode(UITextFieldViewModeWhileEditing)
    .masonry(^ (MASConstraintMaker *make) {
        make.left.mas_equalTo(self.titleLabel.mas_right);
        make.right.mas_equalTo(-15);
        make.top.mas_equalTo(10);
        make.bottom.mas_equalTo(-10);
    })
    .eventBlock(UIControlEventEditingChanged, ^ (UITextField *sender) {
        @strongify(self);
        self.item.subTitle = sender.text;
        if (self.eventAction) {
            self.eventAction(0, sender.text);
        }
    })
    .view;
    self.textField.dk_textColorPicker = DKColorPickerWithKey(BLACK);
}

#pragma mark - # Delgate
- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string
{
    if ([string isEqualToString:@"\n"]) {
        [textField resignFirstResponder];
        if (self.eventAction) {
            self.eventAction(1, textField.text);
        }
        return NO;
    }
    return YES;
}

@end
