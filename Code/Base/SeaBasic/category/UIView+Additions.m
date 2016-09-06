//
//  UIView+Additions.m
//  ydtctz
//
//  Created by Develop on 1/9/12.
//  Copyright (c) 2012 . All rights reserved.
//

#import "UIView+Additions.h"

@implementation UIView (Additions)

////////////////////////////////////////////////////////////////////////////////////////////
- (CGFloat)left {
    return self.frame.origin.x;
}


////////////////////////////////////////////////////////////////////////////////////////////
- (void)setLeft:(CGFloat)x {
    CGRect frame = self.frame;
    frame.origin.x = x;
    self.frame = frame;
}

////////////////////////////////////////////////////////////////////////////////////////////
- (void)plusLeft:(CGFloat)x {
    CGRect frame = self.frame;
    frame.origin.x += x;
    self.frame = frame;
}


////////////////////////////////////////////////////////////////////////////////////////////
- (CGFloat)top {
    return self.frame.origin.y;
}


///////////////////////////////////////////////////////////////////////////////////////////////////
- (void)setTop:(CGFloat)y {
    CGRect frame = self.frame;
    frame.origin.y = y;
    self.frame = frame;
}

////////////////////////////////////////////////////////////////////////////////////////////
- (void)plusTop:(CGFloat)y {
    CGRect frame = self.frame;
    frame.origin.y += y;
    self.frame = frame;
}

///////////////////////////////////////////////////////////////////////////////////////////////////
- (CGFloat)right {
    return self.frame.origin.x + self.frame.size.width;
}


///////////////////////////////////////////////////////////////////////////////////////////////////
- (void)setRight:(CGFloat)right {
    CGRect frame = self.frame;
    frame.origin.x = right - frame.size.width;
    self.frame = frame;
}


///////////////////////////////////////////////////////////////////////////////////////////////////
- (CGFloat)bottom {
    return self.frame.origin.y + self.frame.size.height;
}


///////////////////////////////////////////////////////////////////////////////////////////////////
- (void)setBottom:(CGFloat)bottom {
    CGRect frame = self.frame;
    frame.origin.y = bottom - frame.size.height;
    self.frame = frame;
}


///////////////////////////////////////////////////////////////////////////////////////////////////
- (CGFloat)centerX {
    return self.center.x;
}


///////////////////////////////////////////////////////////////////////////////////////////////////
- (void)setCenterX:(CGFloat)centerX {
    self.center = CGPointMake(centerX, self.center.y);
}


///////////////////////////////////////////////////////////////////////////////////////////////////
- (CGFloat)centerY {
    return self.center.y;
}


///////////////////////////////////////////////////////////////////////////////////////////////////
- (void)setCenterY:(CGFloat)centerY {
    self.center = CGPointMake(self.center.x, centerY);
}


///////////////////////////////////////////////////////////////////////////////////////////////////
- (CGFloat)width {
    return self.frame.size.width;
}


///////////////////////////////////////////////////////////////////////////////////////////////////
- (void)setWidth:(CGFloat)width {
    CGRect frame = self.frame;
    frame.size.width = width;
    self.frame = frame;
}

///////////////////////////////////////////////////////////////////////////////////////////////////
- (void)plusWidth:(CGFloat)width {
    CGRect frame = self.frame;
    frame.size.width += width;
    self.frame = frame;
}


////////////////////////////////////////////////////////////////////////////////////////////
- (CGFloat)height {
    return self.frame.size.height;
}


////////////////////////////////////////////////////////////////////////////////////////////
- (void)setHeight:(CGFloat)height {
    CGRect frame = self.frame;
    frame.size.height = height;
    self.frame = frame;
}

////////////////////////////////////////////////////////////////////////////////////////////
- (void)plusHeight:(CGFloat)height {
    CGRect frame = self.frame;
    frame.size.height += height;
    self.frame = frame;
}

////////////////////////////////////////////////////////////////////////////////////////////
- (CGFloat)ttScreenX {
    CGFloat x = 0;
    for (UIView* view = self; view; view = view.superview) {
        x += view.left;
    }
    return x;
}


///////////////////////////////////////////////////////////////////////////////////////////////////
- (CGFloat)ttScreenY {
    CGFloat y = 0;
    for (UIView* view = self; view; view = view.superview) {
        y += view.top;
    }
    return y;
}


///////////////////////////////////////////////////////////////////////////////////////////////////
- (CGFloat)screenViewX {
    CGFloat x = 0;
    for (UIView* view = self; view; view = view.superview) {
        x += view.left;
        
        if ([view isKindOfClass:[UIScrollView class]]) {
            UIScrollView* scrollView = (UIScrollView*)view;
            x -= scrollView.contentOffset.x;
        }
    }
    
    return x;
}


///////////////////////////////////////////////////////////////////////////////////////////////////
- (CGFloat)screenViewY {
    CGFloat y = 0;
    for (UIView* view = self; view; view = view.superview) {
        y += view.top;
        
        if ([view isKindOfClass:[UIScrollView class]]) {
            UIScrollView* scrollView = (UIScrollView*)view;
            y -= scrollView.contentOffset.y;
        }
    }
    return y;
}


/////////////////////////////////////////////////////////////////////////////////////////////////
- (CGRect)screenFrame {
    return CGRectMake(self.screenViewX, self.screenViewY, self.width, self.height);
}


/////////////////////////////////////////////////////////////////////////////////////////////////
- (CGPoint)origin {
    return self.frame.origin;
}


/////////////////////////////////////////////////////////////////////////////////////////////////
- (void)setOrigin:(CGPoint)origin {
    CGRect frame = self.frame;
    frame.origin = origin;
    self.frame = frame;
}


///////////////////////////////////////////////////////////////////////////////////////////////////
- (CGSize)size {
    return self.frame.size;
}


///////////////////////////////////////////////////////////////////////////////////////////////////
- (void)setSize:(CGSize)size {
    CGRect frame = self.frame;
    frame.size = size;
    self.frame = frame;
}

-(BOOL) containsSubView:(UIView *)subView {
    for (UIView *view in [self subviews]) {
        if ([view isEqual:subView]) {
            return YES;
        }
    }
    return NO;
}

-(BOOL) containsSubViewOfClassType:(Class)class {
    for (UIView *view in [self subviews]) {
        if ([view isMemberOfClass:class]) {
            return YES;
        }
    }
    return NO;
}

+(UIView*)viewWithFrame:(CGRect)frame {
    return [[UIView alloc] initWithFrame:frame];
}

- (CGAffineTransform)transformForOrientation:(UIInterfaceOrientation)orientation {
	if (orientation == UIInterfaceOrientationLandscapeLeft) {
		return CGAffineTransformMakeRotation(-M_PI / 2);
	} else if (orientation == UIInterfaceOrientationLandscapeRight) {
		return CGAffineTransformMakeRotation(M_PI / 2);
	} else if (orientation == UIInterfaceOrientationPortraitUpsideDown) {
		return CGAffineTransformMakeRotation(-M_PI);
	} else{
		return CGAffineTransformIdentity;
	}
}

- (UIInterfaceOrientation)currentOrientation {
    return [UIApplication sharedApplication].statusBarOrientation;
}

-(UIInterfaceOrientation)resetOrientation {
    UIInterfaceOrientation orientation = [[UIApplication sharedApplication] statusBarOrientation];
    CGAffineTransform transform = CGAffineTransformIdentity;
    switch (orientation) {
        case UIInterfaceOrientationLandscapeLeft:
            transform = CGAffineTransformRotate(transform, -M_PI/2);
            break;
        case UIInterfaceOrientationLandscapeRight:
            transform = CGAffineTransformRotate(transform, M_PI/2);
            break;
        case UIInterfaceOrientationPortraitUpsideDown:
            transform = CGAffineTransformRotate(transform, M_PI);
            break;
        default:
            break;
    }
    
    [self setTransform:transform];
    return orientation;
}

- (void)removeAllSubviews {
    [self.subviews makeObjectsPerformSelector:@selector(removeFromSuperview)];
}

// 移除除了给定的view外的所有子view
- (void)removeAllSubviewsExcept:(UIView*)view {
    for (UIView *v in self.subviews) {
        if(![v isEqual:view]) [v removeFromSuperview];
    }
}

// 移除除了给定的view外的所有子view
- (void)removeAllSubviewsExceptViews:(NSArray*)views {
    for (UIView *v in self.subviews) {
        if(![views containsObject:v])
            [v removeFromSuperview];
    }
}


-(void)setScaleX:(float)scaleX andY:(float)scaleY{
    [self setTransform:CGAffineTransformMakeScale(scaleX,scaleY)];
}

@end

@implementation UIImage(Additions)

-(CGFloat)height{
    return self.size.height;
}

-(CGFloat)width{
    return self.size.width;
}

// Tint: Color
-(UIImage*)rt_tintedImageWithColor:(UIColor*)color {
    return [self rt_tintedImageWithColor:color level:1.0f];
}

// Tint: Color + level
-(UIImage*)rt_tintedImageWithColor:(UIColor*)color level:(CGFloat)level {
    CGRect rect = CGRectMake(0.0f, 0.0f, self.size.width, self.size.height);
    return [self rt_tintedImageWithColor:color rect:rect level:level];
}

// Tint: Color + Rect
-(UIImage*)rt_tintedImageWithColor:(UIColor*)color rect:(CGRect)rect {
    return [self rt_tintedImageWithColor:color rect:rect level:1.0f];
}

// Tint: Color + Rect + level
-(UIImage*)rt_tintedImageWithColor:(UIColor*)color rect:(CGRect)rect level:(CGFloat)level {
    CGRect imageRect = CGRectMake(0.0f, 0.0f, self.size.width, self.size.height);
    
    UIGraphicsBeginImageContextWithOptions(imageRect.size, NO, self.scale);
    CGContextRef ctx = UIGraphicsGetCurrentContext();
    
    [self drawInRect:imageRect];
    
    CGContextSetFillColorWithColor(ctx, [color CGColor]);
    CGContextSetAlpha(ctx, level);
    CGContextSetBlendMode(ctx, kCGBlendModeSourceAtop);
    CGContextFillRect(ctx, rect);
    
    CGImageRef imageRef = CGBitmapContextCreateImage(ctx);
    UIImage *darkImage = [UIImage imageWithCGImage:imageRef
                                             scale:self.scale
                                       orientation:self.imageOrientation];
    CGImageRelease(imageRef);
    
    UIGraphicsEndImageContext();
    
    return darkImage;
}

// Tint: Color + Insets
-(UIImage*)rt_tintedImageWithColor:(UIColor*)color insets:(UIEdgeInsets)insets {
    return [self rt_tintedImageWithColor:color insets:insets level:1.0f];
}

// Tint: Color + Insets + level
-(UIImage*)rt_tintedImageWithColor:(UIColor*)color insets:(UIEdgeInsets)insets level:(CGFloat)level {
    CGRect rect = CGRectMake(0.0f, 0.0f, self.size.width, self.size.height);
    return [self rt_tintedImageWithColor:color rect:UIEdgeInsetsInsetRect(rect, insets) level:level];
}

// Light: Level
-(UIImage*)rt_lightenWithLevel:(CGFloat)level {
    return [self rt_tintedImageWithColor:[UIColor whiteColor] level:level];
}

// Light: Level + Insets
-(UIImage*)rt_lightenWithLevel:(CGFloat)level insets:(UIEdgeInsets)insets {
    return [self rt_tintedImageWithColor:[UIColor whiteColor] insets:insets level:level];
}

// Light: Level + Rect
-(UIImage*)rt_lightenRect:(CGRect)rect withLevel:(CGFloat)level {
    return [self rt_tintedImageWithColor:[UIColor whiteColor] rect:rect level:level];
}

// Dark: Level
-(UIImage*)rt_darkenWithLevel:(CGFloat)level {
    return [self rt_tintedImageWithColor:[UIColor blackColor] level:level];
}

// Dark: Level + Insets
-(UIImage*)rt_darkenWithLevel:(CGFloat)level insets:(UIEdgeInsets)insets {
    return [self rt_tintedImageWithColor:[UIColor blackColor] insets:insets level:level];
}

// Dark: Level + Rect
-(UIImage*)rt_darkenRect:(CGRect)rect withLevel:(CGFloat)level {
    return [self rt_tintedImageWithColor:[UIColor blackColor] rect:rect level:level];
}

-(UIImage *)stretchableImageWithEdgeInset:(UIEdgeInsets) inset{
    if([[UIDevice currentDevice].systemVersion floatValue]>=6.0)
        return [self resizableImageWithCapInsets:inset
                             resizingMode:UIImageResizingModeStretch];
    else
        return [self resizableImageWithCapInsets:inset];
}

@end

@implementation UIScrollView(Additions)

-(void)setContentHeight:(CGFloat)height{
    CGSize size = self.contentSize;
    size.height = height;
    [self setContentSize:size];
}

-(void)setContentWidth:(CGFloat)width {
    CGSize size = self.contentSize;
    size.width = width;
    [self setContentSize:size];
}

-(float)contentWidth{
    return self.contentSize.width;
}

-(float)contentHeight{
    return self.contentSize.height;
}

@end

@implementation UINavigationController (Additions)

-(void)removeViewController:(UIViewController*)controller{
    NSMutableArray *array = [self.viewControllers mutableCopy];
    [array removeObject:controller];
    [self setViewControllers:array];
}

-(void)setTintColor:(UIColor*)tintColor{
    [self.navigationBar setTintColor:tintColor];
}

-(void)setBackgroudImage:(UIImage *)image{
//    if(!image)
//        image = [[UIImage imageNamed:@"title_bar"] resizableImageWithCapInsets:UIEdgeInsetsMake(0, 160, 44, 160)];
    [self.navigationBar setBackgroundImage:image forBarMetrics:UIBarMetricsDefault];
}

@end

@implementation UIButton (Additions)

-(void)setWhiteStyle {
    UIEdgeInsets inset = UIEdgeInsetsMake(10,10,10,10);
    UIImage *button_norm = [[UIImage imageNamed:@"button_white_norm"]
                            resizableImageWithCapInsets:inset];
//    [self.titleLabel setFont:[UIFont systemFontOfSize:TextSizeMedium]];
//    [self setTitleColor:parseColor(WESTORE_PRIMARY_TEXTCOLOR)
//               forState:UIControlStateNormal];
    [self setBackgroundImage:button_norm
                    forState:UIControlStateNormal];
}

-(void)setPinkStyle {
    UIEdgeInsets inset = UIEdgeInsetsMake(10,10,10,10);
    
    [self setBackgroundImage:[[UIImage imageNamed:@"navigation_bar"] resizableImageWithCapInsets:inset resizingMode:UIImageResizingModeStretch]
                    forState:UIControlStateNormal];
    [self setBackgroundImage:[[UIImage imageNamed:@"navigation_bar"] resizableImageWithCapInsets:inset resizingMode:UIImageResizingModeStretch]
                    forState:UIControlStateHighlighted];
//    [self.titleLabel setFont:[UIFont boldSystemFontOfSize:TextSizeLarge]];
//    [self setTitleColor:WhiteColor forState:UIControlStateNormal];
    [self.layer setCornerRadius:6];
    [self.layer setMasksToBounds:YES];
}
-(void)setLoginStyle
{
    UIEdgeInsets inset = UIEdgeInsetsMake(10,10,10,10);
    
    [self setBackgroundImage:[[UIImage imageNamed:@"navigation_bar"] resizableImageWithCapInsets:inset resizingMode:UIImageResizingModeStretch]
                    forState:UIControlStateNormal];
    [self setBackgroundImage:[[UIImage imageNamed:@"navigation_bar"] resizableImageWithCapInsets:inset resizingMode:UIImageResizingModeStretch]
                    forState:UIControlStateHighlighted];
//    [self.titleLabel setFont:[UIFont boldSystemFontOfSize:TextSizeLarge]];
//    [self setTitleColor:WhiteColor forState:UIControlStateNormal];
    [self.layer setCornerRadius:6];
    [self.layer setMasksToBounds:YES];
}
-(void)setPinkStyleWithSmallCorner {
//    UIEdgeInsets inset = UIEdgeInsetsMake(10,10,10,10);
//    UIImage *button_norm = [[UIImage imageNamed:@"button_pink_small_radius_norm"]
//                            resizableImageWithCapInsets:inset];
//    [self.titleLabel setFont:[UIFont boldSystemFontOfSize:TextSizeMedium]];
//    [self setTitleColor:WhiteColor forState:UIControlStateNormal];
//    [self setBackgroundImage:button_norm forState:UIControlStateNormal];
    
    
    UIEdgeInsets inset = UIEdgeInsetsMake(10,10,10,10);
    
    [self setBackgroundImage:[[UIImage imageNamed:@"navigation_bar"] resizableImageWithCapInsets:inset resizingMode:UIImageResizingModeStretch]
                    forState:UIControlStateNormal];
    [self setBackgroundImage:[[UIImage imageNamed:@"navigation_bar"] resizableImageWithCapInsets:inset resizingMode:UIImageResizingModeStretch]
                    forState:UIControlStateHighlighted];
//    [self.titleLabel setFont:[UIFont boldSystemFontOfSize:TextSizeLarge]];
//    [self setTitleColor:WhiteColor forState:UIControlStateNormal];
    [self.layer setCornerRadius:6];
    [self.layer setMasksToBounds:YES];
}

@end
