//
//  DataList.h
//  画图板
//
//  Created by 609972942 on 15/12/15.
//  Copyright (c) 2015年 ios. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@interface DataList : NSObject

//  image属性
@property (nonatomic,strong) UIImage *listImage;

//  绘图属性和方法
@property (nonatomic,strong) UIBezierPath * bezierPath;

@property (nonatomic,strong) UIColor *color;
@property (nonatomic,assign) CGFloat width;

+ (id)dataListWithColor:(UIColor *)color andWidth:(CGFloat)width andPath:(CGMutablePathRef)path;

@end
