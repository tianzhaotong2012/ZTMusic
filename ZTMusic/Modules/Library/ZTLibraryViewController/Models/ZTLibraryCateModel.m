//
//  ZTLibraryCateModel.m
//  ZTMusic
//
//  Created by 李伯坤 on 2018/8/8.
//  Copyright © 2018年 李伯坤. All rights reserved.
//

#import "ZTLibraryCateModel.h"

static inline ZTLibraryCateModel *createLibraryCateModel(ZTLibraryCateType type, NSString *title, NSString *icon) {
    ZTLibraryCateModel *model = [[ZTLibraryCateModel alloc] init];
    model.type = type;
    model.title = title;
    model.icon = icon;
    return model;
}

@implementation ZTLibraryCateModel

+ (NSArray<ZTLibraryCateModel *> *)allLibraryCateModels
{
    NSArray *data = @[createLibraryCateModel(ZTLibraryCateTypePlaylists, @"播放列表", @"library_playlist"),
                      createLibraryCateModel(ZTLibraryCateTypeArtists, @"艺人", @"library_artists"),
                      createLibraryCateModel(ZTLibraryCateTypeAlbums, @"专辑", @"library_albums"),
                      createLibraryCateModel(ZTLibraryCateTypeSongs, @"歌曲", @"library_songs"),
                      createLibraryCateModel(ZTLibraryCateTypeMusicVideos, @"音乐视频", @"library_videos"),
                      createLibraryCateModel(ZTLibraryCateTypeFavorites, @"最爱", @"library_favorites"),
                      createLibraryCateModel(ZTLibraryCateTypeGenres, @"选集", @"library_genres"),
                      createLibraryCateModel(ZTLibraryCateTypeComposers, @"作曲者", @"library_composers"),
                      createLibraryCateModel(ZTLibraryCateTypeDownloaded, @"已下载", @"library_dowloaded"),
                      ];
    return data;
}

+ (NSArray<ZTLibraryCateModel *> *)selectedModels
{
    NSArray *allData = [self allLibraryCateModels];
    NSMutableArray *data = [[NSMutableArray alloc] init];
    for (ZTLibraryCateModel *model in allData) {
        if (model.selected) {
            [data addObject:model];
        }
    }
    return data;
}

+ (NSDictionary *)__selectedCateInfo
{
    NSDictionary *libraryCateInfo = [[NSUserDefaults standardUserDefaults] objectForKey:@"libraryCateInfo"];
    if (!libraryCateInfo) {
        libraryCateInfo = @{@(ZTLibraryCateTypePlaylists).stringValue : @(YES),
                            @(ZTLibraryCateTypeArtists).stringValue : @(YES),
                            @(ZTLibraryCateTypeAlbums).stringValue : @(YES),
                            @(ZTLibraryCateTypeSongs).stringValue : @(YES),
                            };
        [self __updateSelectedCateInfo:libraryCateInfo];
    }
    return libraryCateInfo;
}

+ (void)__updateSelectedCateInfo:(NSDictionary *)libraryCateInfo
{
    [[NSUserDefaults standardUserDefaults] setObject:libraryCateInfo forKey:@"libraryCateInfo"];
}

- (BOOL)selected
{
    NSDictionary *libraryCateInfo = [[self class] __selectedCateInfo];
    BOOL selected = [libraryCateInfo[@(self.type).stringValue] boolValue];
    return selected;
}

- (void)setSelected:(BOOL)selected
{
    NSMutableDictionary *libraryCateInfo = [[[self class] __selectedCateInfo] mutableCopy];
    [libraryCateInfo setObject:@(selected) forKey:@(self.type).stringValue];
    [[self class] __updateSelectedCateInfo:libraryCateInfo];
}

@end
