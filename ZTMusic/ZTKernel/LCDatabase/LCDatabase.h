//
//  LCDatabase.h
//  LCGO
//
//  Created by 李伯坤 on 2018/3/11.
//  Copyright © 2018年 李伯坤. All rights reserved.
//

#import <Foundation/Foundation.h>

@class WCTTable;
@interface LCDatabase : NSObject

/// 账户
//@property (nonatomic, strong, readonly) WCTTable *accountTable;

//歌曲
@property (nonatomic, strong, readonly) WCTTable *songTable;

+ (LCDatabase *)sharedInstance;

- (void)clear;

@end
