//
//  UIView+Utilities.m

//

#import "UIView+Utilities.h"
#import <objc/runtime.h>

/** 虚线边框图层
 */
static char dashBorderLayerKey;

@implementation UIView (Utilities)

- (CGFloat)top
{
    return self.frame.origin.y;
}

- (void)setTop:(CGFloat)y
{
    CGRect frame = self.frame;
    frame.origin.y = y;
    self.frame = frame;
}

- (CGFloat)right
{
    return self.frame.origin.x + self.frame.size.width;
}

- (void)setRight:(CGFloat)right
{
    CGRect frame = self.frame;
    frame.origin.x = right - self.frame.size.width;
    self.frame = frame;
}

- (CGFloat)bottom
{
    return self.frame.origin.y + self.frame.size.height;
}

- (void)setBottom:(CGFloat)bottom
{
    CGRect frame = self.frame;
    frame.origin.y = bottom - self.frame.size.height;
    self.frame = frame;
}

- (CGFloat)left
{
    return self.frame.origin.x;
}

- (void)setLeft:(CGFloat)x
{
    CGRect frame = self.frame;
    frame.origin.x = x;
    self.frame = frame;
}

- (CGFloat)width
{
    return self.frame.size.width;
}

- (void)setWidth:(CGFloat)width
{
    CGRect frame = self.frame;
    frame.size.width = width;
    self.frame = frame;
}

- (CGFloat)height
{
    return self.frame.size.height;
}

- (void)setHeight:(CGFloat)height
{
    CGRect frame = self.frame;
    frame.size.height = height;
    self.frame = frame;
}

- (CGFloat)centerX
{
    return self.center.x;
}

- (void)setCenterX:(CGFloat)centerX
{
    self.center = CGPointMake(centerX, self.center.y);
}

- (CGFloat)centerY
{
    return self.center.y;
}

- (void)setCenterY:(CGFloat)centerY
{
    self.center = CGPointMake(self.center.x, centerY);
}

- (void)makeBorderWidth:(CGFloat)width Color:(UIColor *)color CornerRadius:(CGFloat)cornerRadius
{
    self.layer.borderWidth = width;
    self.layer.borderColor = color.CGColor;
    self.layer.cornerRadius = cornerRadius;
    self.clipsToBounds = YES;
}

- (void)setDashBorderLayer:(CAShapeLayer *)dashBorderLayer
{
    if(dashBorderLayer != self.dashBorderLayer)
    {
        objc_setAssociatedObject(self, &dashBorderLayerKey, dashBorderLayer, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
    }
}

- (CAShapeLayer*)dashBorderLayer
{
   return objc_getAssociatedObject(self, &dashBorderLayerKey);
}

/*添加虚线边框 圆角会根据 视图的圆角来确定
 *@param width 线条宽度
 *@param lineColor 线条颜色
 *@param dashesLength 虚线间隔宽度
 *@param dashesInterval 虚线每段宽度
 */
- (void)addDashBorderWidth:(CGFloat) width lineColor:(UIColor*) lineColor dashesLength:(CGFloat) dashesLength dashesInterval:(CGFloat) dashesInterval
{
    CAShapeLayer *borderLayer = self.dashBorderLayer;
    if(!borderLayer)
    {
        borderLayer = [CAShapeLayer layer];
        self.dashBorderLayer = borderLayer;
    }
    
    borderLayer.bounds = self.bounds;
    borderLayer.position = CGPointMake(CGRectGetMidX(self.bounds), CGRectGetMidY(self.bounds));
    
    borderLayer.path = [UIBezierPath bezierPathWithRoundedRect:borderLayer.bounds cornerRadius:self.layer.cornerRadius].CGPath;
    borderLayer.lineWidth = width;
    //虚线边框
    borderLayer.lineDashPattern = @[@(dashesLength), @(dashesInterval)];

    borderLayer.fillColor = [UIColor clearColor].CGColor;
    borderLayer.strokeColor = lineColor.CGColor;
    [self.layer insertSublayer:borderLayer atIndex:0];
}

@end
