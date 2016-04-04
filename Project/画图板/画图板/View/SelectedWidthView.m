//
//  SelectedWidthView.m
//  画图板
//
//  Created by 609972942 on 15/12/15.
//  Copyright (c) 2015年 ios. All rights reserved.
//

#import "SelectedWidthView.h"

#define kMargin 10

@interface SelectedWidthView ()
{
    
    SelectedWidthBlock _selectedWidthBlock;
}
@end

@implementation SelectedWidthView

- (instancetype)initWithFrame:(CGRect)frame andSelectedWidthBlock:(SelectedWidthBlock)selectedWidthBlock{
    
    self = [super initWithFrame:frame];
    if (self) {
        
        _selectedWidthBlock = selectedWidthBlock;
        
        [self setBackgroundColor:[UIColor colorWithPatternImage:[UIImage imageNamed:@"tool_back"]]];
        
        NSArray *widthArray = @[@1,@3,@5,@7,@9,@15,@20,@25,@30];
        
        [self creatWidthViewItem:widthArray];
        
    }
    return self;
}

#pragma mark 创建ColorViewItem
- (void)creatWidthViewItem:(NSArray *)widthArray{
    
    NSInteger count = widthArray.count;
    
    CGFloat width = (self.bounds.size.width - (count + 1) * kMargin) / count;
    CGFloat height = self.bounds.size.height - kMargin;
    
    for (NSInteger i =0; i < count; i ++) {
        
        UIButton *widthButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [widthButton.titleLabel setFont:[UIFont systemFontOfSize:14]];
        
        [widthButton setFrame:CGRectMake(i * (width + kMargin) + kMargin, kMargin / 2, width, height - kMargin)];
        [widthButton addTarget:self action:@selector(widthButtonCilck:) forControlEvents:UIControlEventTouchUpInside];
        [widthButton setTitle:[widthArray[i] stringValue] forState:UIControlStateNormal];
        
        [self addSubview:widthButton];
            }
}

#pragma mark colorItem的监听
- (void)widthButtonCilck:(UIButton *)sender{
    
    _selectedWidthBlock([sender.titleLabel.text floatValue]);
}

@end
