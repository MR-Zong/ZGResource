//
//  ToolView.h
//  画图板
//
//  Created by 609972942 on 15/12/15.
//  Copyright (c) 2015年 ios. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SelectedColorView.h"
#import "SelectedWidthView.h"

typedef void(^OtherBlock)();

@interface ToolView : UIView


- (instancetype)initWithFrame:(CGRect)frame andSelectedColorBlock:(SelectedColorBlock)selectedColorBlock andSelectedWidthBlock:(SelectedWidthBlock)selectedWidthBlock andErraserBlock:(OtherBlock)erraser andUndo:(OtherBlock)undo andClear:(OtherBlock)clear andPhoto:(OtherBlock)photo andSave:(OtherBlock)save;


@end
