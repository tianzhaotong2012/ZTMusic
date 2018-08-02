//
//  TLSettingItem.m
//  TLChat
//
//  Created by lbk on 16/2/7.
//  Copyright © 2016年 lbk. All rights reserved.
//

#import "TLSettingItem.h"

@implementation TLSettingItem

+ (TLSettingItem *)createItemWithTitle:(NSString *)title
{
    TLSettingItem *item = [[TLSettingItem alloc] init];
    item.title = LOCSTR(title);
    return item;
}

- (id)init
{
    if (self = [super init]) {
        self.showDisclosureIndicator = YES;
    }
    return self;
}

- (NSString *)cellClassName
{
    switch (self.type) {
        case TLSettingItemTypeDefalut:
            return @"TLSettingCell";
            break;
        case TLSettingItemTypeTitleButton:
            return @"TLSettingButtonCell";
            break;
        case TLSettingItemTypeSwitch:
            return @"TLSettingSwitchCell";
            break;
        default:
            break;
    }
    return nil;
}

@end
