//
//  SelectedWidthView.h
//  画图板
//
//  Created by 609972942 on 15/12/15.
//  Copyright (c) 2015年 ios. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef void(^SelectedWidthBlock)(CGFloat width);

@interface SelectedWidthView : UIView

- (instancetype)initWithFrame:(CGRect)frame andSelectedWidthBlock:(SelectedWidthBlock)selectedWidthBlock;

@end
