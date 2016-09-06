//
//  UIView+Screen.m
//  WeiXueProject
//
//  Created by TBXark on 15/5/8.
//  Copyright (c) 2015年 TBXark. All rights reserved.
//

#import "UIView+Screen.h"

static CGFloat kUIScreenHeight = -1;
static CGFloat kUIScreenWidth = -1;
static CGFloat kUIScreenRealHeight = -1;
static CGFloat kTableViewHeight = -1;
static CGFloat kTableViewWithTabHeight = -1;
@implementation UIView (Screen)

+ (CGFloat)screenWidth
{
    if (kUIScreenHeight < 0) {
        kUIScreenHeight = [UIScreen mainScreen].bounds.size.width;
    }
    return kUIScreenHeight;
}
+ (CGFloat)screenHeight
{
    if (kUIScreenWidth < 0) {
        kUIScreenWidth = [UIScreen mainScreen].bounds.size.height;
    }
    return kUIScreenWidth;
}
+ (CGFloat)realHeight{
    if (kUIScreenRealHeight < 0) {
        kUIScreenRealHeight = [UIScreen mainScreen].bounds.size.height - kStatusBarHeight - kNavigationBarHeight - kTabBarHeight;
    }
    return kUIScreenRealHeight;
}
+ (CGFloat)tableHeight{
    if (kTableViewHeight < 0) {
        kTableViewHeight = [UIScreen mainScreen].bounds.size.height - kStatusBarHeight - kNavigationBarHeight;
    }
    return kTableViewHeight;
}
+ (CGFloat)tbaleWithTabHeight{
    if (kTableViewWithTabHeight < 0) {
        kTableViewWithTabHeight = [UIScreen mainScreen].bounds.size.height - kStatusBarHeight - kNavigationBarHeight - kTabBarHeight;
    }
    return kTableViewWithTabHeight;
}
- (void)changeXforView:(CGFloat)x
{
    CGRect frame = self.frame;
    frame.origin.x = x;
    self.frame = frame;
}
- (void)changeYforView:(CGFloat)y
{
    CGRect frame = self.frame;
    frame.origin.y = y;
    self.frame = frame;
}
- (void)changeWidthForView:(CGFloat)width
{
    CGRect frame = self.frame;
    frame.size.width = width;
    self.frame = frame;
}
- (void)changeHeightForView:(CGFloat)height
{
    CGRect frame = self.frame;
    frame.size.height = height;
    self.frame = frame;
}
- (void)addYforView:(CGFloat)y{
    CGRect frame = self.frame;
    frame.origin.y += y;
    self.frame = frame;
}
- (void)addXforView:(CGFloat)x{
    CGRect frame = self.frame;
    frame.origin.x += x;
    self.frame = frame;
}
@end
