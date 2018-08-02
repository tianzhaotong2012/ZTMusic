//
//  TLSettingItem.h
//  TLChat
//
//  Created by lbk on 16/2/7.
//  Copyright © 2016年 lbk. All rights reserved.
//

#import <Foundation/Foundation.h>

#define     CELL_ST_ITEM_NORMAL                 @"TLSettingItemNormalCell"
#define     CELL_ST_ITEM_BUTTON                 @"TLSettingItemButtonCell"
#define     CELL_ST_ITEM_SWITCH                 @"TLSettingItemSwitchCell"
#define     CELL_ST_ITEM_INPUT                  @"TLSettingItemInputCell"
#define     CELL_ST_ITEM_TEXT                   @"TLSettingItemTextCell"
#define     VIEW_ST_HEADER                      @"TLSettingSectionHeaderView"
#define     VIEW_ST_FOOTER                      @"TLSettingSectionFooterView"


#define     TLCreateSettingItem(title)          [TLSettingItem createItemWithTitle:title]

typedef NS_ENUM(NSInteger, TLSettingItemType) {
    TLSettingItemTypeDefalut = 0,
    TLSettingItemTypeTitleButton,
    TLSettingItemTypeSwitch,
    TLSettingItemTypeOther,
};

@interface TLSettingItem : NSObject

@property (nonatomic, assign) NSInteger tag;


/**
 *  主标题
 */
@property (nonatomic, strong) NSString *title;

/**
 *  副标题
 */
@property (nonatomic, strong) NSString *subTitle;

/**
 *  右图片(本地)
 */
@property (nonatomic, strong) NSString *rightImagePath;

/**
 *  右图片(网络)
 */
@property (nonatomic, strong) NSString *rightImageURL;

/**
 *  是否显示箭头（默认YES）
 */
@property (nonatomic, assign) BOOL showDisclosureIndicator;

/**
 *  停用高亮（默认NO）
 */
@property (nonatomic, assign) BOOL disableHighlight;

/**
 *  cell类型，默认default
 */
@property (nonatomic, assign) TLSettingItemType type;

@property (nonatomic, assign) BOOL selected;

@property (nonatomic, assign) CGSize size;

@property (nonatomic, strong) id userInfo;

+ (TLSettingItem *)createItemWithTitle:(NSString *)title;

- (NSString *)cellClassName;

@end
