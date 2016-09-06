//
//  UIView+XQuickStyle.h
//  FreeLimit
//
//  Created by TBXark on 15-4-10.
//  Copyright (c) 2015年 TBXark. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIView (XQuickStyle)

//Make CornerRadius
- (void)makeCornerRadius;
- (void)makeCornerRadiusWithValue:(CGFloat)value;
- (void)makeBorderWidth:(CGFloat)width Color:(UIColor *)color;
- (void)makeBorderWidth:(CGFloat)width Color:(UIColor *)color CornerRadius:(CGFloat)cornerRadius;

@end

@interface UILabel (XQuickStyle)

- (void)addStrikethroughStyleWithColor:(UIColor *)color Width:(CGFloat)width;

@end
