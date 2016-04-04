//
//  SelectedColorView.h
//  画图板
//
//  Created by 609972942 on 15/12/15.
//  Copyright (c) 2015年 ios. All rights reserved.
//

#import <UIKit/UIKit.h>

//  定义block
typedef void(^SelectedColorBlock)(UIColor *color);

@interface SelectedColorView : UIView

- (instancetype)initWithFrame:(CGRect)frame andSelectedColorBlock:(SelectedColorBlock)selectedColorBlock;

@end
