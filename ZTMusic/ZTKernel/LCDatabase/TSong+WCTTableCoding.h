#import "TSong.h"
#import <WCDB/WCDB.h>

@interface TSong (WCTTableCoding) <WCTTableCoding>
//WCDB_PROPERTY用于在头文件中声明绑定到数据库表的字段,写在分类里,不写在.h里面,这样view和controller不会 引入导入<WCDB/WCDB.h>的文件

WCDB_PROPERTY(localID)
WCDB_PROPERTY(postId)
WCDB_PROPERTY(title)
WCDB_PROPERTY(poster)
WCDB_PROPERTY(mp3)
WCDB_PROPERTY(artistName)

@end
