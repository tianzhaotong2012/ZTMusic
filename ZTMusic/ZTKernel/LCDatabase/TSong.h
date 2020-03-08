#import <Foundation/Foundation.h>

@interface TSong : NSObject

@property(nonatomic, assign) NSInteger localID;

@property(nonatomic, strong) NSString *postId;
@property(nonatomic, strong) NSString *title;
@property(nonatomic, strong) NSString *poster;
@property(nonatomic, strong) NSString *mp3;
@property (nonatomic, strong) NSString *artistName;

@end
