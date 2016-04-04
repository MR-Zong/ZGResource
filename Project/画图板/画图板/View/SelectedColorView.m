//
//  SelectedColorView.m
//  画图板
//
//  Created by 609972942 on 15/12/15.
//  Copyright (c) 2015年 ios. All rights reserved.
//

#import "SelectedColorView.h"


#define kMargin 10

@interface SelectedColorView ()
{
    SelectedColorBlock _selectedColorBlock;
}
@end

@implementation SelectedColorView

- (instancetype)initWithFrame:(CGRect)frame andSelectedColorBlock:(SelectedColorBlock)selectedColorBlock{
    
    self = [super initWithFrame:frame];
    if (self) {
        
        _selectedColorBlock = selectedColorBlock;
        
        [self setBackgroundColor:[UIColor colorWithPatternImage:[UIImage imageNamed:@"tool_back"]]];
        
        NSArray *colorArray = @[[UIColor redColor],[UIColor greenColor],[UIColor blueColor],[UIColor cyanColor],[UIColor yellowColor],[UIColor magentaColor],[UIColor orangeColor],[UIColor purpleColor],[UIColor brownColor],[UIColor lightGrayColor]];;
        
        [self creatColorViewItem:colorArray];
        
    }
    return self;
}

#pragma mark 创建ColorViewItem
- (void)creatColorViewItem:(NSArray *)colorArray{
    
    NSInteger count = colorArray.count;
    
    CGFloat width = (self.bounds.size.width - (count + 1) * kMargin) / count;
    CGFloat height = self.bounds.size.height - kMargin;
    NSInteger i = 0;
    
    for (UIColor *color in colorArray) {
        
        UIButton *colorButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [colorButton setFrame:CGRectMake(i * (width + kMargin) + kMargin, kMargin / 2, width, height - kMargin)];
        [colorButton addTarget:self action:@selector(colorButtonCilck:) forControlEvents:UIControlEventTouchUpInside];
        
        [colorButton setBackgroundColor:color];
        
        [self addSubview:colorButton];
        
        i ++;
    }
    
}

#pragma mark colorItem的监听
- (void)colorButtonCilck:(UIButton *)sender{
    
    _selectedColorBlock(sender.backgroundColor);
    
}



@end
