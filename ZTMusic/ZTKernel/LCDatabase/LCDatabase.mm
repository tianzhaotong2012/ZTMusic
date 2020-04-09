//
//  LCDatabase.m
//  LCGO
//
//  Created by lbk on 2018/3/11.
//  Copyright © 2018年 lbk. All rights reserved.
//

#import "LCDatabase.h"
#import <WCDB/WCDB.h>
#import "TSong+WCTTableCoding.h"

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
    _songTable = createTable(@"tSong",TSong.class);
}

- (BOOL)insertData:(TSong *)tSong {
    tSong.isAutoIncrement = YES;
    BOOL result = [self.db insertObject:tSong into:@"tSong"];
    
    //关闭数据库,_database如果能自己释放的话,会自动关闭,就不用手动调用关闭了
    [self.db close];

    if (!result) {
        NSLog(@"插入失败");
        return NO;
    }else{
        NSLog(@"插入成功");
        return YES;
    }
}

// 查询数据  用localID排序
- (NSArray<TSong *> *)selectOrder {
    NSArray<TSong *> *objects2 = [self.db getObjectsOfClass:TSong.class fromTable:@"tSong" orderBy:TSong.localID.operator*(-1).order()];
    [objects2 enumerateObjectsUsingBlock:^(TSong *obj, NSUInteger idx, BOOL * _Nonnull stop) {
        NSLog(@"数据库查询用localID排序 --> %@ \n",obj.title);
    }];
    return objects2;
}

// 查询next
- (TSong *)nextSong:(NSString *) postId{
   TSong *objects1 = [self.db getOneObjectOfClass:TSong.class fromTable:@"tSong" where:TSong.postId == postId];
    if(objects1 == nil){return nil;}
    NSArray<TSong *> *objects2 = [self.db getObjectsOfClass:TSong.class fromTable:@"tSong" where:TSong.localID > objects1.localID orderBy:TSong.localID.operator*(1).order()];
    return objects2.firstObject;
}

// 查询prev
- (TSong *)prevSong:(NSString *) postId{
    TSong *objects1 = [self.db getOneObjectOfClass:TSong.class fromTable:@"tSong" where:TSong.postId == postId];
    if(objects1 == nil){return nil;}
    NSArray<TSong *> *objects2 = [self.db getObjectsOfClass:TSong.class fromTable:@"tSong" where:TSong.localID < objects1.localID orderBy:TSong.localID.operator*(1).order()];
    return objects2.lastObject;
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
