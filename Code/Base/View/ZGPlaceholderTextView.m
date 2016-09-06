//
//  ZGPlacehodleTextView.m
//  TestBS
//
//  Created by 徐宗根 on 15/9/10.
//  Copyright (c) 2015年 XuZonggen. All rights reserved.
//

#import "ZGPlaceholderTextView.h"

@interface ZGPlaceholderTextView ()
@end

@implementation ZGPlaceholderTextView

- (instancetype)initWithFrame:(CGRect)frame

{
    if (self = [super initWithFrame:frame]) {
        
        // 默认有很多好处，因为它省去了你要去判断对应属性是否为Nil的情况
        // 有默认的话，对应属性就一定不会为Nil
        // 用户没设置对应属性的话，就用我们默认的，这也很符合规律
        // 默认placeholder颜色
        self.placeholderColor = [UIColor grayColor];
        
        self.placeholderFont = [UIFont systemFontOfSize:13];
        
        // 注册通知
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(textViewTextDidChange:) name:UITextViewTextDidChangeNotification object:self];
    }
    
    return  self;
}


- (void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (void)drawRect:(CGRect)rect
{
    // 什么时候是需要调用super方法呢
    //[super drawRect:rect];
    
    // textView有输入文字的时候，就不要画placeholder了
    if (self.hasText) return;
    
    
    NSMutableDictionary *drawDict = [NSMutableDictionary dictionary];
    drawDict[NSFontAttributeName] = self.placeholderFont;
    drawDict[NSForegroundColorAttributeName] = self.placeholderColor;
    
    CGRect tmpRect = rect;
    tmpRect.origin.x = 5;
    tmpRect.origin.y = 8;
    tmpRect.size.width -= 2 * tmpRect.origin.x;

    [self.placeholder drawInRect:tmpRect withAttributes:drawDict];
}


// 非常重要，这是个可以处理placeholder被拖拽的时候，placeholder被重绘
// 实现可拖拽.
// 因为textView 被拖拽的时候，肯定要重新布局子控件的
- (void)layoutSubviews
{
    [super layoutSubviews];
    
    [self setNeedsDisplay];
}


#pragma mark - Setter
- (void)setPlaceholder:(NSString *)placeholder
{
    _placeholder = placeholder;
    
    [self setNeedsDisplay];
}

- (void)setPlaceholderColor:(UIColor *)placeholderColor
{
    _placeholderColor = placeholderColor;
    [self setNeedsDisplay];
}

- (void)setPlaceholderFont:(UIFont *)placeholderFont
{
    _placeholderFont = placeholderFont;
    
    [self setNeedsDisplay];
}


- (void)setText:(NSString *)text
{
    [super setText:text];
    
    [self setNeedsDisplay];
}

- (void)setAttributedText:(NSAttributedString *)attributedText
{
    [super setAttributedText:attributedText];
    
    [self setNeedsDisplay];
}



#pragma mark - UITextViewTextDidChangeNotification
- (void)textViewTextDidChange:(NSNotification *)notification
{
    [self setNeedsDisplay];
}





@end
