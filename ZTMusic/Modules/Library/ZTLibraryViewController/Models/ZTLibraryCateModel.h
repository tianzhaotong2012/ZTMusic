//
//  ZTLibraryCateModel.h
//  ZTMusic
//
//  Created by 李伯坤 on 2018/8/8.
//  Copyright © 2018年 李伯坤. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef NS_ENUM(NSInteger, ZTLibraryCateType) {
    ZTLibraryCateTypePlaylists,         // 播放列表
    ZTLibraryCateTypeArtists,           // 艺人
    ZTLibraryCateTypeAlbums,            // 专辑
    ZTLibraryCateTypeSongs,             // 歌曲
    ZTLibraryCateTypeMusicVideos,       // 音乐视频
    ZTLibraryCateTypeGenres,            // 选集
    ZTLibraryCateTypeComposers,         // 作曲者
    ZTLibraryCateTypeFavorites,         // 最爱
    ZTLibraryCateTypeDownloaded,        // 已下载
};

@interface ZTLibraryCateModel : NSObject

@property (nonatomic, assign) ZTLibraryCateType type;

@property (nonatomic, strong) NSString *title;

@property (nonatomic, strong) NSString *icon;

@property (nonatomic, assign) BOOL selected;

+ (NSArray<ZTLibraryCateModel *> *)selectedModels;

+ (NSArray<ZTLibraryCateModel *> *)allLibraryCateModels;

@end
