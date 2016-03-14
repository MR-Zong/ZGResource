//
//  UIView+ZHY.m
//  画板
//
//  Created by 609972942 on 15/10/14.
//  Copyright (c) 2015年 ios初学. All rights reserved.
//

#import "UIView+ZHY.h"

@implementation UIView (ZHY)

#pragma mark View到Image的转化
- (UIImage *)getImageFromView:(UIView *)theView{
    
//  (CGSize size: 保存尺寸, BOOL opaque: 透明度, CGFloat scale:拉伸大小1或者theView.layer.contentsScale代表不拉伸)
    UIGraphicsBeginImageContextWithOptions(theView.bounds.size, YES, theView.layer.contentsScale);
    
//  渲染自身
    [theView.layer renderInContext:UIGraphicsGetCurrentContext()];
    
//  为image设置一个上下文并且当成当前的上下文
    UIImage *image=UIGraphicsGetImageFromCurrentImageContext();
    
//  上下文栈弹出创建的context
    UIGraphicsEndImageContext();
    
//  返回image
    return image;
    
}

@end
