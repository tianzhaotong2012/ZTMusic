//
//  ZTSongModel.h
//  ZTMusic
//
//  Created by 李伯坤 on 2018/8/6.
//  Copyright © 2018年 李伯坤. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "ZTArtistModel.h"

@class ZTSongPreviewModel;
@interface ZTSongModel : NSObject

/// id
@property (nonatomic, strong) NSString *postId;

/// 标题
@property (nonatomic, strong) NSString *title;

/// 图片
@property (nonatomic, strong) NSString *poster;

/// 资源
@property (nonatomic, strong) ZTSongPreviewModel *preview;

/// 作者
@property (nonatomic, strong) ZTArtistModel *artist;

/// 别名
@property (nonatomic, strong) NSString *slug;

/// 分享链接
@property (nonatomic, strong) NSString *shareUrl;

@end

@interface ZTSongPreviewModel : NSObject

/// mp3
@property (nonatomic, strong) NSString *mp3;

@end
