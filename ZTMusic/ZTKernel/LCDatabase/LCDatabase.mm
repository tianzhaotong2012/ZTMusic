//
//  LCDatabase.m
//  LCGO
//
//  Created by lbk on 2018/3/11.
//  Copyright © 2018年 lbk. All rights reserved.
//

#import "LCDatabase.h"
#import <WCDB/WCDB.h>

@interface LCDatabase ()

@property (nonatomic, strong) WCTDatabase *db;

@property (nonatomic, strong) NSMutableArray *tableArray;

@end

@implementation LCDatabase

+ (LCDatabase *)sharedInstance
{
    static LCDatabase *db;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        db = [[LCDatabase alloc] init];
    });
    return db;
}

- (instancetype)init
{
    if (self = [super init]) {
        [self createTable];
    }
    return self;
}

- (void)createTable
{
    self.tableArray = [[NSMutableArray alloc] init];
    WCTTable *(^createTable)(NSString *tableName, Class tableClass) = ^WCTTable *(NSString *tableName, Class tableClass) {
        if (![self.db createTableAndIndexesOfName:tableName withClass:tableClass]) {
            NSLog(@"【ERROR】【DB】【账户】%@表创建失败", tableName);
        }
        else {
            WCTTable *table = [self.db getTableOfName:tableName withClass:tableClass];
            [self.tableArray addObject:table];
            return table;
        }
        return nil;
    };
    
//    _accountTable = createTable(@"Account", LCUser.class);
    //_songTable = createTable(@"Song",ZTSongModel.class);
}

- (void)clear
{
    for (WCTTable *table in self.tableArray) {
        [table deleteAllObjects];
    }
}

#pragma mark - # Getters
- (WCTDatabase *)db
{
    if (!_db) {
        NSString *path = [[NSFileManager documentsPath] stringByAppendingPathComponent:@"db"];
        if (![[NSFileManager defaultManager] fileExistsAtPath:path]) {
            [[NSFileManager defaultManager] createDirectoryAtPath:path withIntermediateDirectories:NO attributes:nil error:nil];
        }
        path = [path stringByAppendingPathComponent:@"account"];
        _db = [[WCTDatabase alloc] initWithPath:path];
    }
    return _db;
}

@end
