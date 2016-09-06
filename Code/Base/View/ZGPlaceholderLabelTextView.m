//
//  ZGPlaceholderLabelTextView.m
//  TestBS
//
//  Created by 徐宗根 on 15/9/10.
//  Copyright (c) 2015年 XuZonggen. All rights reserved.
//

#import "ZGPlaceholderLabelTextView.h"

@interface ZGPlaceholderLabelTextView ()

@property (nonatomic,weak) UILabel *placeholderLabel;

@end

@implementation ZGPlaceholderLabelTextView

- (instancetype)initWithFrame:(CGRect)frame
{
    if (self = [super initWithFrame:frame]) {
        
        // 设置默认值
        self.placeholderFont = [UIFont systemFontOfSize:13];
        self.placeholderColor = [UIColor grayColor];
        
        // placeholderLabel
        UILabel *placeholderLabel = [[UILabel alloc] init];
        
        //placeholderLabel.textAlignment = NSTextAlignmentCenter;
        placeholderLabel.textColor = self.placeholderColor;
        placeholderLabel.numberOfLines = 0;
        
        
        self.placeholderLabel = placeholderLabel;
        [self addSubview:placeholderLabel];
        
        
        // NSNotificationCenter
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(textViewTextChange:) name:UITextViewTextDidChangeNotification object:self];
    }
    
    return  self;
}

- (void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (void)textViewTextChange:(NSNotification *)noti
{
    self.placeholderLabel.hidden = self.hasText;
}


- (void)layoutSubviews
{
    [super layoutSubviews];
    
    
    
    
//    CGSize placeholderSize = [self.placeholderLabel boundingRectWithSize:CGSizeMake(self.width - 2*2, 0)];
//    
//    CGRect tmpRect = CGRectMake(2,2,placeholderSize.width,placeholderSize.height);
//    
//    ZGLOG(@"tmpRect %@",NSStringFromCGRect(tmpRect));
//    
//    self.placeholderLabel.frame = tmpRect;
    
    self.placeholderLabel.x = 5;
    self.placeholderLabel.y = 8;
    self.placeholderLabel.width = self.width - 2 * self.placeholderLabel.x;
    [self.placeholderLabel sizeToFit];

    
  
    
    
}

#pragma mark - Setter
- (void)setPlaceholder:(NSString *)placeholder
{
    _placeholder = placeholder;
    
    self.placeholderLabel.text = placeholder;
    [self.placeholderLabel sizeToFit];
    
}

- (void)setPlaceholderColor:(UIColor *)placeholderColor
{
    _placeholderColor = placeholderColor;
    
    self.placeholderLabel.textColor = placeholderColor;
    
}

- (void)setPlaceholderFont:(UIFont *)placeholderFont
{
    _placeholderFont = placeholderFont;
    
    self.placeholderLabel.font = placeholderFont;
    
    [self.placeholderLabel sizeToFit];
}



@end
