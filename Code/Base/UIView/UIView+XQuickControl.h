//
//  UIView+XQuickControl.h
//  FreeLimit
//
//  Created by TBXark on 15-4-8.
//  Copyright (c) 2015年 TBXark. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "XQuickButton.h"


@interface UIView (XQuickControl)

//Add system button

- (UIButton *)addSystemButtonWithFrame:(CGRect)frame
                                tittle:(NSString *)tittle
                                action:(buttonAction)action;

//Add back image button
- (UIButton *)addImageButtonWithFrame:(CGRect)frame
                               tittle:(NSString *)tittle
                                backgroundImage:(NSString *)image
                                action:(buttonAction)action;

- (UIButton *)addNoBackImageButtonWithFrame:(CGRect)frame
                                     tittle:(NSString *)tittle
                            backgroundImage:(NSString *)image
                                     action:(buttonAction)action;


//Add imageView
- (UIImageView *)addImageViewWithFrame:(CGRect)frame;

//Add imageView
- (UIImageView *)addImageViewWithFrame:(CGRect)frame
                                image:(NSString *)image;

//Add lable
- (UILabel *)addLableWithFrame:(CGRect)frame
                         text:(NSString *)text;

- (UILabel *)addLableWithFrame:(CGRect)frame
                      attrText:(NSAttributedString *)text;

@end




