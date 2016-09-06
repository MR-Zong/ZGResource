//
//  UIView+Screen.h
//  WeiXueProject
//
//  Created by TBXark on 15/5/8.
//  Copyright (c) 2015年 TBXark. All rights reserved.
//

#import <UIKit/UIKit.h>

#define kNavigationBarHeight 44
#define kStatusBarHeight     20
#define kTabBarHeight        49

#define kUIScreenWidthValue      [UIView screenWidth]
#define kUIScreenHeightValue     [UIView screenHeight]
#define kRealHeightValue         [UIView realHeight]
#define kTableHeightValue        [UIView tableHeight]
#define kTableHeightWithTab      [UIView tbaleWithTabHeight]
@interface UIView (Screen)

+ (CGFloat)screenWidth;
+ (CGFloat)screenHeight;
+ (CGFloat)realHeight;
+ (CGFloat)tableHeight;
+ (CGFloat)tbaleWithTabHeight;
- (void)changeXforView:(CGFloat)x;
- (void)changeYforView:(CGFloat)y;
- (void)addXforView:(CGFloat)x;
- (void)addYforView:(CGFloat)y;
- (void)changeWidthForView:(CGFloat)width;
- (void)changeHeightForView:(CGFloat)height;


@end
