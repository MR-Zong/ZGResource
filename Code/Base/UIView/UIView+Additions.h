//
//  UIView+Additions.h
//  ydtctz
//
//  Created by 小宝 on 1/9/12.
//  Copyright (c) 2012 Bosermobile. All rights reserved.
//

#import <UIKit/UIKit.h>

#define TT_TRANSITION_DURATION 0.3

@interface UIView (Additions)

/**
 * Shortcut for center.x
 *
 * Sets center.x = centerX
 */
@property (nonatomic) CGFloat centerX;

/**
 * Shortcut for center.y
 *
 * Sets center.y = centerY
 */
@property (nonatomic) CGFloat centerY;

/**
 * Return the x coordinate on the screen.
 */
@property (nonatomic, readonly) CGFloat ttScreenX;

/**
 * Return the y coordinate on the screen.
 */
@property (nonatomic, readonly) CGFloat ttScreenY;

/**
 * Return the x coordinate on the screen, taking into account scroll views.
 */
@property (nonatomic, readonly) CGFloat screenViewX;

/**
 * Return the y coordinate on the screen, taking into account scroll views.
 */
@property (nonatomic, readonly) CGFloat screenViewY;

/**
 * Return the view frame on the screen, taking into account scroll views.
 */
@property (nonatomic, readonly) CGRect screenFrame;

/**
 * Shortcut for frame.origin
 */
@property (nonatomic) CGPoint origin;

/**
 * Shortcut for frame.size
 */
@property (nonatomic) CGSize size;

/* 在原来的宽、高上加上一定的尺寸 */
-(void)plusWidth:(CGFloat)width;
- (void)plusHeight:(CGFloat)height;
/* 在原来的左、上边距加上一定的尺寸 */
- (void)plusLeft:(CGFloat)x;
- (void)plusTop:(CGFloat)y;

/* 是否含有子View */
-(BOOL) containsSubView:(UIView *)subView;
//-(BOOL) containsSubViewOfClassType:(Class)class;

+(UIView*)viewWithFrame:(CGRect)frame;

/* 调整UIView旋转方向 */
-(CGAffineTransform)transformForOrientation:(UIInterfaceOrientation)orientation;
-(UIInterfaceOrientation)currentOrientation;
-(UIInterfaceOrientation)resetOrientation;

- (void)removeAllSubviews;
- (void)removeAllSubviewsExcept:(UIView*)view;
// 移除除了给定的view外的所有子view
- (void)removeAllSubviewsExceptViews:(NSArray*)views;

/* 设置缩放 */
-(void)setScaleX:(float)scaleX andY:(float)scaleY;

@end

@interface UIImage (Additions)

@property (nonatomic,readonly) CGFloat width;
@property (nonatomic,readonly) CGFloat height;

-(UIImage*)rt_tintedImageWithColor:(UIColor*)color;
-(UIImage*)rt_tintedImageWithColor:(UIColor*)color level:(CGFloat)level;
-(UIImage*)rt_tintedImageWithColor:(UIColor*)color rect:(CGRect)rect;
-(UIImage*)rt_tintedImageWithColor:(UIColor*)color rect:(CGRect)rect level:(CGFloat)level;
-(UIImage*)rt_tintedImageWithColor:(UIColor*)color insets:(UIEdgeInsets)insets;
-(UIImage*)rt_tintedImageWithColor:(UIColor*)color insets:(UIEdgeInsets)insets level:(CGFloat)level;

-(UIImage*)rt_lightenWithLevel:(CGFloat)level;
-(UIImage*)rt_lightenWithLevel:(CGFloat)level insets:(UIEdgeInsets)insets;
-(UIImage*)rt_lightenRect:(CGRect)rect withLevel:(CGFloat)level;

-(UIImage*)rt_darkenWithLevel:(CGFloat)level;
-(UIImage*)rt_darkenWithLevel:(CGFloat)level insets:(UIEdgeInsets)insets;
-(UIImage*)rt_darkenRect:(CGRect)rect withLevel:(CGFloat)level;

// ios6.0以拉伸方式放大
-(UIImage *)stretchableImageWithEdgeInset:(UIEdgeInsets)inset;

@end

@interface UIScrollView(Additions)

-(void)setContentHeight:(CGFloat)height;
-(void)setContentWidth:(CGFloat)width;
-(float)contentHeight;
-(float)contentWidth;

@end

@interface UINavigationController (Additions)
-(void)setBackgroudImage:(UIImage*)image;
-(void)setTintColor:(UIColor*)tintColor;
-(void)removeViewController:(UIViewController*)controller;
@end

@interface UIButton (Additions)
-(void)setWhiteStyle;
-(void)setPinkStyleWithSmallCorner;
-(void)setPinkStyle;
-(void)setLoginStyle;

@end