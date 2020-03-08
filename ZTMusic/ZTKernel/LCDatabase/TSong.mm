#import "TSong+WCTTableCoding.h"
#import "TSong.h"
#import <WCDB/WCDB.h>

@implementation TSong
//WCDB_IMPLEMENTATION，用于在类文件中定义绑定到数据库表的类
WCDB_IMPLEMENTATION(TSong)
//WCDB_SYNTHESIZE，用于在类文件中定义绑定到数据库表的字段
WCDB_SYNTHESIZE(TSong, localID)
WCDB_SYNTHESIZE(TSong, postId)
WCDB_SYNTHESIZE(TSong, title)
WCDB_SYNTHESIZE(TSong, poster)
WCDB_SYNTHESIZE(TSong, mp3)
WCDB_SYNTHESIZE(TSong, artistName)


//默认使用属性名作为数据库表的字段名。对于属性名与字段名不同的情况，可以使用WCDB_SYNTHESIZE_COLUMN(className, propertyName, columnName)进行映射。
//WCDB_SYNTHESIZE_COLUMN(tSong, totalScore, "db_totalScore")

//WCDB_SYNTHESIZE_DEFAULT(tSong, createDate, WCTDefaultTypeCurrentDate) //设置一个默认值

//唯一约束
WCDB_UNIQUE(TSong, postId)

//主键
WCDB_PRIMARY_ASC_AUTO_INCREMENT(TSong, localID)

@end
