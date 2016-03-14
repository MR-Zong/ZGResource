//
//  DataList.m
//  画图板
//
//  Created by 609972942 on 15/12/15.
//  Copyright (c) 2015年 ios. All rights reserved.
//

#import "DataList.h"

@implementation DataList


+ (id)dataListWithColor:(UIColor *)color andWidth:(CGFloat)width andPath:(CGMutablePathRef)path{
    
    DataList *list = [[DataList alloc]init];
    
    [list setColor:color];
    [list setWidth:width];
    [list setBezierPath:[UIBezierPath bezierPathWithCGPath:path]];
    
    return list;
}

@end
