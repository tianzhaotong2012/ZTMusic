//
//  ZTForYouModel.h
//  zhuanzhuan
//
//  Created by ZZUIHelper on 2020/2/10.
//  Copyright © 2017年 ZZUIHelper. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "ZTSongModel.h"

@interface ZTForYouModel : NSObject

/// 歌曲
@property (nonatomic, strong) NSArray<ZTSongModel *> *songs;

+ (void)requestWithPage:(NSString *) page withPageNum:(NSString *) pageNum completeAction:(LCBlockComplete)completeAction;

@end
