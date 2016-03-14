//
//  DrawView.h
//  画图板
//
//  Created by 609972942 on 15/12/15.
//  Copyright (c) 2015年 ios. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface DrawView : UIView

@property (nonatomic,strong) UIImage *drawImage;

//  绘制当前的属性
@property (nonatomic,strong) UIColor *drawColor;
@property (nonatomic,assign) CGFloat drawWidth;


//  撤销
- (void)undo;

//  清屏
- (void)clearScreen;


@end
