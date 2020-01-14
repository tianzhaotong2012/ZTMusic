//
//  ZTStyleACell.m
//  zhuanzhuan
//
//  Created by ZZUIHelper on 2020/1/13.
//  Copyright © 2017年 ZZUIHelper. All rights reserved.
//

#import "ZTStyleACell.h"

@interface ZTStyleACell ()

@property (nonatomic, strong) UICollectionView *collectionView;

@property (nonatomic, strong) UIImageView *imageView;
@property (nonatomic, strong) UILabel *titleLabel;
@property (nonatomic, strong) UILabel *userLabel;

@end

@implementation ZTStyleACell

+ (CGFloat)viewHeightByDataModel:(NSArray *)dataModel
{
    return 228;
}

- (void)setViewEventAction:(id (^)(NSInteger, id))eventAction
{
    self.eventAction = eventAction;
}

- (void)setViewDataModel:(NSArray *)dataModel
{
    if (dataModel == self.songArray) {
        return;
    }
    self.songArray = dataModel;
    if (dataModel.count > 0) {
        NSInteger sectionType = 0;
        self.angel.addSection(sectionType).sectionInsets(UIEdgeInsetsMake(0, 15, 0, 5)).minimumLineSpacing(12).minimumInteritemSpacing(12);
        self.angel.addCells(@"ZTStyleAItemCell").toSection(sectionType).withDataModelArray(dataModel).selectedAction(^ (id data) {
           
            if (self.eventAction) {
                self.eventAction(0, data);
            }
           
        });
    }
}

- (void)viewIndexPath:(NSIndexPath *)indexPath sectionItemCount:(NSInteger)count
{
    if (indexPath.row == 1) {
        self.addSeparator(ZZSeparatorPositionTop);
    }
    else {
        self.removeSeparator(ZZSeparatorPositionTop);
    }
    if (indexPath.row == count - 1) {
        self.addSeparator(ZZSeparatorPositionBottom);
    }
    else {
        self.addSeparator(ZZSeparatorPositionBottom).beginAt(5);
    }
}

- (instancetype)initWithFrame:(CGRect)frame
{
    if (self = [super initWithFrame:frame]) {
        self.dk_backgroundColorPicker = DKColorPickerWithKey(WHITE);
        [self setSelectedBackgrounColor:[UIColor colorGrayForSeperator]];
        
        self.collectionView = self.contentView.addCollectionView(0)
        .scrollsToTop(NO).showsHorizontalScrollIndicator(NO)
        .masonry(^ (MASConstraintMaker *make) {
            make.left.right.mas_equalTo(0);
            make.height.mas_equalTo(228);
            make.bottom.mas_equalTo(0);
        })
        .view;
        [(UICollectionViewFlowLayout *)self.collectionView.collectionViewLayout setScrollDirection:UICollectionViewScrollDirectionHorizontal];
        self.collectionView.dk_backgroundColorPicker = DKColorPickerWithKey(WHITE);
        
        self.angel = [[ZZFLEXAngel alloc] initWithHostView:self.collectionView];
    }
    return self;
}




@end

#pragma mark - ## ZTStyleAItemCell
@interface ZTStyleAItemCell : UICollectionViewCell <ZZFlexibleLayoutViewProtocol>

@property (nonatomic, strong) ZTSongModel *songModel;
@property (nonatomic, strong) UIImageView *imageView;
@property (nonatomic, strong) UILabel *titleLabel;
@property (nonatomic, strong) UILabel *userLabel;

@end

@implementation ZTStyleAItemCell

+ (CGSize)viewSizeByDataModel:(id)dataModel
{
    return CGSizeMake(158, 204);
}

- (void)setViewDataModel:(ZTSongModel *)dataModel
{
    self.songModel = dataModel;
    [self.imageView sd_setImageWithURL:dataModel.poster.toURL];
    [self.titleLabel setText:dataModel.title];
    [self.userLabel setText:dataModel.artist.artistName];
    
}

- (id)initWithFrame:(CGRect)frame
{
    if (self = [super initWithFrame:frame]) {
        
        self.imageView = self.contentView.addImageView(1).cornerRadius(5).borderWidth(BORDER_WIDTH_1PX).borderColor([UIColor colorGrayForSeperator].CGColor)
        .contentMode(UIViewContentModeScaleAspectFill).clipsToBounds(YES)
        .masonry(^ (MASConstraintMaker *make) {
            make.left.mas_equalTo(0);
            make.top.mas_equalTo(0);
            make.bottom.mas_equalTo(-60);
            make.width.mas_equalTo(158);
        })
        .view;
        
        self.titleLabel = self.contentView.addLabel(2)
        .font([UIFont boldSystemFontOfSize:15])
        .masonry(^ (MASConstraintMaker *make) {
            make.left.mas_equalTo(self.imageView.mas_left).mas_offset(2);
            make.top.mas_equalTo(self.imageView.mas_bottom).mas_offset(8);
            make.right.mas_lessThanOrEqualTo(self.contentView);
        })
        .view;
        self.titleLabel.dk_textColorPicker = DKColorPickerWithKey(BLACK);
        
        self.userLabel = self.contentView.addLabel(2)
        .font([UIFont systemFontOfSize:12]).textColor([UIColor grayColor])
        .masonry(^ (MASConstraintMaker *make) {
            make.left.mas_equalTo(self.titleLabel.mas_left).mas_offset(2);
            make.bottom.mas_equalTo(self.titleLabel.mas_bottom).mas_offset(25);
            make.right.mas_lessThanOrEqualTo(self.contentView);
        })
        .view;
    }
    return self;
}

@end

