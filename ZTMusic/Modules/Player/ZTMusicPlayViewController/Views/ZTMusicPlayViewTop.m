//
//  ZTMusicPlayViewTop.m
//  zhuanzhuan
//
//  Created by ZZUIHelper on 2020/1/28.
//  Copyright © 2017年 ZZUIHelper. All rights reserved.
//

#import "ZTMusicPlayViewTop.h"
#import "ZTPlayerManager.h"

@interface ZTMusicPlayViewTop ()

@property (nonatomic, strong) UIImageView *imageView;

@property (nonatomic, strong) UILabel *titleLabel;

@property (nonatomic, strong) UILabel *userLabel;

@property (nonatomic, strong) UIButton *button;

@property (nonatomic, assign) BOOL withLine;

@property (nonatomic, strong) UIButton *playButton;

@property (nonatomic, strong) UIButton *prevButton;

@property (nonatomic, strong) UIButton *nextButton;

@property (nonatomic, strong) UIProgressView *processView;

//音量条(托控件)
@property (nonatomic, nonatomic) UISlider *volume;

@end

@implementation ZTMusicPlayViewTop

+ (CGFloat)viewHeightByDataModel:(id)dataModel
{
    return SCREEN_HEIGHT;
}

- (void)setViewDataModel:(ZTSongModel *)dataModel
{
    [self.imageView sd_setImageWithURL:dataModel.poster.toURL placeholderImage:[UIImage imageNamed:@"poster"]];
    [self.titleLabel setText:![LOCSTR(dataModel.title) isEqual:@""]?LOCSTR(dataModel.title):LOCSTR(@"未在播放")];
    [self.userLabel setText:![LOCSTR(dataModel.artist.artistName) isEqual:@""]?LOCSTR(dataModel.artist.artistName):LOCSTR(@"歌手")];

    if([[ZTPlayerManager sharedInstance].player isPlaying] == YES){
     self.playButton.zz_make.image([UIImage imageNamed:@"nowPlaying_pause"]);
    }else{
      self.playButton.zz_make.image([UIImage imageNamed:@"nowPlaying_play"]);
    }
    self.prevButton.zz_make.backgroundImage([UIImage imageNamed:@"nowPlaying_prev"]);
    self.nextButton.zz_make.backgroundImage([UIImage imageNamed:@"nowPlaying_next"]);
    
    self.volume = [[UISlider alloc] initWithFrame:CGRectMake(100, 200, 100, 20)];
    
    [self.processView setProgress:[[ZTPlayerManager sharedInstance].player playingProcess]];
    
    [self setNeedsDisplay];
}

- (void)setViewEventAction:(id (^)(NSInteger, id))eventAction
{
    self.eventAction = eventAction;
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
        self.addSeparator(ZZSeparatorPositionBottom).beginAt(15);
    }
}

- (instancetype)initWithFrame:(CGRect)frame
{
    if (self = [super initWithFrame:frame]) {
//        self.imageView = self.contentView.addImageView(1).cornerRadius(10).borderWidth(BORDER_WIDTH_1PX).borderColor([UIColor colorGrayForSeperator].CGColor)
//        .contentMode(UIViewContentModeScaleAspectFill).clipsToBounds(YES)
//        .masonry(^ (MASConstraintMaker *make) {
//            make.left.mas_equalTo(50);
//            make.top.mas_equalTo(40);
//            make.height.mas_equalTo(SCREEN_WIDTH*0.7);
//            make.right.mas_equalTo(-50);
//        })
//        .view;
        
        self.imageView = self.contentView.addImageView(1).shadow(CGSizeMake(-2, 10),6,[UIColor grayColor],0.4).cornerRadius(5).masksToBounds(NO).masonry(^ (MASConstraintMaker *make) {
           make.left.mas_equalTo(50);
            make.top.mas_equalTo(40);
            make.height.mas_equalTo(SCREEN_WIDTH*0.7);
            make.right.mas_equalTo(-50);
        })
        .view.addImageView(1).borderWidth(BORDER_WIDTH_1PX).borderColor([UIColor colorGrayForSeperator].CGColor).shadow(CGSizeMake(0, 10),2,[UIColor grayColor],0.3).cornerRadius(5)
        .contentMode(UIViewContentModeScaleAspectFill).masksToBounds(YES)
        .masonry(^ (MASConstraintMaker *make) {
            make.left.mas_equalTo(0);
            make.top.mas_equalTo(0);
            make.bottom.mas_equalTo(0);
            make.right.mas_equalTo(0);
        })
        .view;
        
        self.titleLabel = self.contentView.addLabel(2)
        .font([UIFont boldSystemFontOfSize:15])
        .masonry(^ (MASConstraintMaker *make) {
            make.left.mas_equalTo(30);
            make.top.mas_equalTo(self.imageView.mas_bottom).mas_offset(25);
            make.right.mas_lessThanOrEqualTo(self.contentView);
        })
        .view;
        self.titleLabel.dk_textColorPicker = DKColorPickerWithKey(BLACK);
        
        self.userLabel = self.contentView.addLabel(2)
        .font([UIFont systemFontOfSize:15]).textColor([UIColor colorPink])
        .masonry(^ (MASConstraintMaker *make) {
            make.left.mas_equalTo(self.titleLabel.mas_left).mas_offset(0);
            make.top.mas_equalTo(self.titleLabel.mas_bottom).mas_offset(8);
            make.right.mas_lessThanOrEqualTo(self.contentView);
        })
        .view;
        
        @weakify(self);
        self.button = self.contentView.addButton(1)
        .titleColor([UIColor colorPink]).titleFont([UIFont systemFontOfSize:16])
        .eventBlock(UIControlEventTouchUpInside, ^(UIButton *sender) {
            if (self.eventAction) {
                self.eventAction(0, nil);
            }
        })
        .masonry(^ (MASConstraintMaker *make) {
            make.right.mas_equalTo(-15);
            make.bottom.mas_equalTo(-3);
        })
        .view;
        
        self.playButton = self.contentView.addButton(2)
        .titleColor([UIColor colorPink]).titleFont([UIFont systemFontOfSize:16])
        .eventBlock(UIControlEventTouchUpInside, ^(UIButton *sender) {
            if (self.eventAction) {
                self.eventAction(1, nil);
            }
        })
        .masonry(^ (MASConstraintMaker *make) {
            make.left.mas_equalTo(SCREEN_WIDTH/2-20);            make.top.mas_equalTo(self.imageView.mas_bottom).mas_offset(170);
        })
        .view;

        self.prevButton = self.contentView.addButton(3)
        .titleColor([UIColor colorPink]).titleFont([UIFont systemFontOfSize:16])
        .eventBlock(UIControlEventTouchUpInside, ^(UIButton *sender) {
            if (self.eventAction) {
                self.eventAction(2, nil);
            }
        })
        .masonry(^ (MASConstraintMaker *make) {
            make.right.mas_equalTo(self.playButton.mas_left).mas_offset(-60);
            make.top.mas_equalTo(self.imageView.mas_bottom).mas_offset(170);
        })
        .view;

        self.nextButton = self.contentView.addButton(4)
        .titleColor([UIColor colorPink]).titleFont([UIFont systemFontOfSize:16])
        .eventBlock(UIControlEventTouchUpInside, ^(UIButton *sender) {
            if (self.eventAction) {
                self.eventAction(3, nil);
            }
        })
        .masonry(^ (MASConstraintMaker *make) {
            make.left.mas_equalTo(self.playButton.mas_right).mas_offset(60);
            make.top.mas_equalTo(self.imageView.mas_bottom).mas_offset(170);
        })
        .view;
        
        self.processView = [[UIProgressView alloc] initWithFrame:CGRectMake(50, self.imageView.frame.origin.y + 450, SCREEN_WIDTH - 100, 20)];

        [self.processView setProgressViewStyle:UIProgressViewStyleDefault]; //设置进度条类型
        
        [self.processView setProgressTintColor:[UIColor colorPink]];
        
        
        [self addSubview:_processView];
        
        self.volume = [[UISlider alloc] initWithFrame:CGRectMake(50, self.imageView.frame.origin.y + 600, SCREEN_WIDTH - 100, 20)];
        
        [self.volume setMinimumValue:0.0];
        [self.volume setMaximumValue:1.0];
        [self.volume setValue:[[ZTPlayerManager sharedInstance].player getVolume]];
        
        [self.volume setMinimumTrackTintColor:[UIColor grayColor]];
        [self.volume setMinimumValueImage:[UIImage imageNamed:@"volDown"]];
        [self.volume setMaximumValueImage:[UIImage imageNamed:@"volUp"]];
        
        [self.volume addTarget:self action:@selector(updateValue:) forControlEvents:UIControlEventValueChanged];
        
        [self addSubview:_volume];
        
    }
    return self;
}

-(void) updateValue:(UISlider *) sender{
    [[ZTPlayerManager sharedInstance].player setVolume:sender.value];
}

@end
