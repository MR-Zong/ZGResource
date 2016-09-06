//
//  UIView+XQuickStyle.m
//  FreeLimit
//
//  Created by TBXark on 15-4-10.
//  Copyright (c) 2015年 TBXark. All rights reserved.
//

#import "UIView+XQuickStyle.h"

@implementation UIView (XQuickStyle)


//Make CornerRadius
- (void)makeCornerRadius
{
    [self makeCornerRadiusWithValue:10];
}

- (void)makeCornerRadiusWithValue:(CGFloat)value
{
    self.layer.cornerRadius = value;
    self.clipsToBounds = YES;
}

- (void)makeBorderWidth:(CGFloat)width Color:(UIColor *)color CornerRadius:(CGFloat)cornerRadius
{
    self.layer.borderWidth = width;
    self.layer.borderColor = color.CGColor;
    self.layer.cornerRadius = cornerRadius;
    self.clipsToBounds = YES;
}
- (void)makeBorderWidth:(CGFloat)width Color:(UIColor *)color{
    
    self.layer.borderWidth = width;
    self.layer.borderColor = color.CGColor;
    self.clipsToBounds = YES;
}

@end



@implementation UILabel (XQuickStyle)

- (void)addStrikethroughStyleWithColor:(UIColor *)color Width:(CGFloat)width
{
    NSString *lableText = self.text;
    NSMutableAttributedString *newText = [[NSMutableAttributedString alloc] initWithString:lableText attributes:@{NSStrikethroughStyleAttributeName:[NSNumber numberWithFloat:width],NSStrikethroughColorAttributeName:color}];
    self.attributedText = newText;
}



@end
