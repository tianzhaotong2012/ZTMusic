//
//  UIBarButtonItem+Back.m
//  TLChat
//
//  Created by 李伯坤 on 2017/9/13.
//  Copyright © 2017年 李伯坤. All rights reserved.
//

#import "UIBarButtonItem+Back.h"

@implementation UIBarButtonItem (Back)

- (id)initWithBackTitle:(NSString *)title target:(id)target action:(SEL)action
{
    UIButton *view = [[UIButton alloc] init];
    [view addTarget:target action:action forControlEvents:UIControlEventTouchUpInside];
    
    UIImage *image = [UIImage imageNamed:@"nav_back"] ;
    UIImageView *imageView = [[UIImageView alloc] init];
    imageView.dk_imagePicker = DKImagePickerWithImages([image imageWithColor:HexColor(0x0078ff)], [image imageWithColor:HexColor(0xeeeeee)]);
    [view addSubview:imageView];
    
    UILabel *label = [[UILabel alloc] init];
    [label setText:title];
    [label setFont:[UIFont boldSystemFontOfSize:16]];
    label.dk_textColorPicker = DKColorPickerWithKey(TINT);
    [view addSubview:label];
    
    if (self = [self initWithCustomView:view]) {
        [imageView setFrame:CGRectMake(0, 6, 13, 24)];
        CGSize size = [label sizeThatFits:CGSizeMake(MAXFLOAT, MAXFLOAT)];
        [label setFrame:CGRectMake(17, 0, size.width, 34)];
        [view setFrame:CGRectMake(0, 0, label.frame.origin.x + label.frame.size.width, 34)];
    }
    return self;
}

@end
