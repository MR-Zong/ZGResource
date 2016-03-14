//
//  ToolItem.m
//  画图板
//
//  Created by 609972942 on 15/12/15.
//  Copyright (c) 2015年 ios. All rights reserved.
//

#import "ToolItem.h"

@interface ToolItem ()

@end

@implementation ToolItem

- (instancetype)initWithFrame:(CGRect)frame{
    
    self = [super initWithFrame:frame];
    if (self) {
        
        [self.titleLabel setFont:[UIFont systemFontOfSize:14]];
        
    }
    return self;
}

- (void)drawRect:(CGRect)rect{
    [super drawRect:rect];
    
    if (self.isTap) {
        
        [[UIColor redColor] set];
        
        CGRect frame= CGRectMake(3, self.bounds.size.height - 3, self.bounds.size.width - 6, 2);
        
        UIRectFill(frame);
    }
}

#pragma mark isTap的setter方法
- (void)setIsTap:(BOOL)isTap{
    _isTap = isTap;
    
//  重新绘制
    [self setNeedsDisplay];
}


@end
