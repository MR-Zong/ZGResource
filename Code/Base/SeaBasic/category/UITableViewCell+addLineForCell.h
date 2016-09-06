//
//  UITableViewCell+addLineForCell.h
//  WuMei
//
//  Created by qsit on 15/7/23.
//  Copyright (c) 2015年 QSIT. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UITableViewCell (addLineForCell)
- (void)addLineForTop;
- (void)addLineForBottom;
- (void)addLineForTopWithFloat:(CGFloat)contentFloat;
@end
