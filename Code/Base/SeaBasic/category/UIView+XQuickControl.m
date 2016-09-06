//
//  UIView+XQuickControl.m
//  FreeLimit
//
//  Created by TBXark on 15-4-8.
//  Copyright (c) 2015年 TBXark. All rights reserved.
//

#import "UIView+XQuickControl.h"

@implementation UIView (XQuickControl)


//Add system button

- (UIButton *)addSystemButtonWithFrame:(CGRect)frame
                                tittle:(NSString *)tittle
                                action:(buttonAction)action
{
    XQuickButton *button = [[XQuickButton alloc] initWithFrame:frame];
    [button setTitle:tittle forState:UIControlStateNormal];
    button.action = action;
    button.titleLabel.font = [UIFont fontWithName:MainFontName size:14.0];
    [self addSubview:button];
    return button;
}

//Add back image button
- (UIButton *)addImageButtonWithFrame:(CGRect)frame
                               tittle:(NSString *)tittle
                      backgroundImage:(NSString *)image
                               action:(buttonAction)action
{
    UIButton *button = [self addSystemButtonWithFrame:frame tittle:tittle action:action];
    [button setBackgroundImage:[UIImage imageNamed:image] forState:UIControlStateNormal];
    return button;
}
//Add image button
- (UIButton *)addNoBackImageButtonWithFrame:(CGRect)frame
                                     tittle:(NSString *)tittle
                            backgroundImage:(NSString *)image
                                     action:(buttonAction)action
{
    UIImageView *imageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:image]];
    imageView.tintColor = WMTintColor;
    UIButton *button = [self addSystemButtonWithFrame:frame tittle:tittle action:action];
    [button setImage:imageView.image forState:UIControlStateNormal];
    return button;
}
//Add imageView
- (UIImageView *)addImageViewWithFrame:(CGRect)frame
{
    UIImageView *imgv = [[UIImageView alloc] initWithFrame:frame];
    imgv.userInteractionEnabled = YES;
    [self addSubview:imgv];
    return imgv;
}
- (UIImageView *)addImageViewWithFrame:(CGRect)frame
                                image:(NSString *)image
{
    UIImageView *imgv = [[UIImageView alloc] initWithImage:[UIImage imageNamed:image]];
    imgv.frame = frame;
    imgv.userInteractionEnabled = YES;
    [self addSubview:imgv];
    return imgv;
}

//Add lable
- (UILabel *)addLableWithFrame:(CGRect)frame
                         text:(NSString *)text
{
    UILabel *lable = [[UILabel alloc] initWithFrame:frame];
    lable.text = text;
    lable.textColor = [UIColor colorWithRed:240/255.0 green:68/255.0 blue:71/255.0 alpha:1];
    lable.font = [UIFont fontWithName:MainFontName size:18];
    [self addSubview:lable];
    return lable;
}

- (UILabel *)addLableWithFrame:(CGRect)frame attrText:(NSAttributedString *)text{
    UILabel *lable = [[UILabel alloc] initWithFrame:frame];
    lable.attributedText = text;
    [self addSubview:lable];
    return lable;
}



@end






