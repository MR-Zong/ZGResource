//
//  SeaAlertView.m
//  Sea
//
//  Created by 罗海雄 on 15/8/5.
//  Copyright (c) 2015年 Sea. All rights reserved.
//

#import "SeaAlertView.h"
#import "SeaBasic.h"

#define SeaAlertViewButtonStartTag 1200

@interface SeaAlertView ()

//内容
@property(nonatomic,strong) UIView *contentView;

//内容目标frame
@property(nonatomic,assign) CGRect targetFrame;

//黑色背景
@property(nonatomic,strong) UIView *backgroundView;

//标题
@property(nonatomic,strong) UILabel *titleLabel;

@end

@implementation SeaAlertView



/**构造方法
 *@param title 标题
 *@param otherButtonTitles 按钮标题，数组元素是 NSString
 */
- (id)initWithTitle:(NSString*) title otherButtonTitles:(NSArray*) otherButtonTitles
{
    self = [super initWithFrame:CGRectMake(0, 0, _width_, _height_)];
    if(self)
    {
        _titleColor = [UIColor blackColor];
        _destructiveButtonIndex = NSNotFound;
        
        _backgroundView = [[UIView alloc] initWithFrame:self.bounds];
        _backgroundView.backgroundColor = [UIColor colorWithWhite:0 alpha:0.5];
        _backgroundView.alpha = 0;
        [self addSubview:_backgroundView];
        
        CGFloat textMargin = 10.0;
        CGFloat contentWidth = 230.0;
        CGFloat topMargin = 20.0;
        
        UIFont *font = [UIFont fontWithName:MainFontName size:15.0];
        CGSize size = [title stringSizeWithFont:font contraintWith:contentWidth - textMargin * 2];
        
        
        _titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(textMargin, topMargin, contentWidth - textMargin * 2, size.height)];
        _titleLabel.numberOfLines = 0;
        _titleLabel.textAlignment = NSTextAlignmentCenter;
        _titleLabel.backgroundColor = [UIColor clearColor];
        _titleLabel.text = title;
        
        if(size.height > 20.0)
        {
            topMargin = 10.0;
            _titleLabel.top = topMargin;
            _titleLabel.textAlignment = NSTextAlignmentLeft;
        }
        _titleLabel.textColor = _titleColor;
        _titleLabel.font = font;
        
        _contentView = [[UIView alloc] initWithFrame:CGRectMake(_width_ / 2.0, _height_ / 2.0, 1.0, 1.0)];
        _contentView.backgroundColor = [UIColor whiteColor];
        _contentView.layer.cornerRadius = 5.0;
        _contentView.layer.masksToBounds = YES;
        _contentView.clipsToBounds = YES;
        [self addSubview:_contentView];
        
        CGFloat buttonHeight = 40.0;
        CGFloat lineWidth = _separatorLineWidth_;
        
        [_contentView addSubview:_titleLabel];
        
        UIView *line = [[UIView alloc] initWithFrame:CGRectMake(textMargin, _titleLabel.bottom + topMargin - _separatorLineWidth_, contentWidth - textMargin * 2, _separatorLineWidth_)];
        line.backgroundColor = _separatorLineColor_;
        [_contentView addSubview:line];
        
        if(otherButtonTitles.count > 2)
        {
            CGFloat buttonWidth = contentWidth;
            for(int i = 0;i < otherButtonTitles.count;i ++)
            {
                UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
                btn.tag = SeaAlertViewButtonStartTag + i;
                btn.frame = CGRectMake(0 , _titleLabel.bottom + (buttonHeight + lineWidth) * i, buttonWidth, buttonHeight);
                [btn addTarget:self action:@selector(buttonDidClick:) forControlEvents:UIControlEventTouchUpInside];
                [btn setTitle:[otherButtonTitles objectAtIndex:i] forState:UIControlStateNormal];
                [btn setTitleColor:_titleLabel.textColor forState:UIControlStateNormal];
                btn.titleLabel.font = _titleLabel.font;
                [_contentView addSubview:btn];
                
                if(i != otherButtonTitles.count - 1)
                {
                    line = [[UIView alloc] initWithFrame:CGRectMake(textMargin, btn.bottom, contentWidth - textMargin * 2, lineWidth)];
                    line.backgroundColor = _separatorLineColor_;
                    
                    [_contentView addSubview:line];
                }
            }
            
            buttonHeight *= otherButtonTitles.count;
        }
        else
        {
            CGFloat buttonWidth = (contentWidth - lineWidth * (otherButtonTitles.count - 1)) / otherButtonTitles.count;
            for(int i = 0;i < otherButtonTitles.count;i ++)
            {
                UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
                btn.tag = SeaAlertViewButtonStartTag + i;
                btn.frame = CGRectMake((buttonWidth + lineWidth) * i, _titleLabel.bottom + topMargin, buttonWidth, buttonHeight);
                [btn addTarget:self action:@selector(buttonDidClick:) forControlEvents:UIControlEventTouchUpInside];
                [btn setTitle:[otherButtonTitles objectAtIndex:i] forState:UIControlStateNormal];
                [btn setTitleColor:_titleLabel.textColor forState:UIControlStateNormal];
                btn.titleLabel.font = _titleLabel.font;
                [_contentView addSubview:btn];
                
                if(i != otherButtonTitles.count - 1)
                {
                    line = [[UIView alloc] initWithFrame:CGRectMake(btn.right, btn.top + 10.0, lineWidth, buttonHeight - 10.0 * 2)];
                    line.backgroundColor = _separatorLineColor_;
                    
                    [_contentView addSubview:line];
                }
            }
        }
        
        CGFloat margin = (_width_ - contentWidth) / 2.0;
        CGFloat height = topMargin + _titleLabel.height + topMargin + buttonHeight;
        self.targetFrame = CGRectMake(margin, (_height_ - height) / 2.0, contentWidth, height);
    }
    
    return self;
}

#pragma mark- property 

/**标题颜色
 */
- (void)setTitleColor:(UIColor *)titleColor
{
    if(![_titleColor isEqualToColor:titleColor])
    {
        if(titleColor == nil)
            titleColor = [UIColor blackColor];
        _titleColor = titleColor;
        _titleLabel.textColor = titleColor;
    }
}

/**红色按钮下标 default is 'NSNotFound' ，表示没有红色按钮
 */
- (void)setDestructiveButtonIndex:(NSInteger)destructiveButtonIndex
{
    if(_destructiveButtonIndex != destructiveButtonIndex)
    {
        [self setButtonTitleColor:_titleColor forIndex:_destructiveButtonIndex];
        _destructiveButtonIndex = destructiveButtonIndex;
        [self setButtonTitleColor:[UIColor redColor] forIndex:_destructiveButtonIndex];
    }
}

#pragma mark- public method



/**设置按钮颜色
 */
- (void)setButtonTitleColor:(UIColor*) color forIndex:(NSInteger) index
{
    UIButton *btn = [self buttonForIndex:index];
    [btn setTitleColor:color forState:UIControlStateNormal];
}

/**按钮字体大小
 */
-(void)setButtontitleFont:(UIFont*)font forIndex:(NSInteger)index
{
    UIButton *btn = [self buttonForIndex:index];
    btn.titleLabel.font = font;
}

/**获取点击按钮的标题
 */
- (NSString*)buttonTitleForIndex:(NSInteger) index
{
    UIButton *btn = [self buttonForIndex:index];
    return [btn titleForState:UIControlStateNormal];
}

/**显示
 */
- (void)show
{
    self.contentView.alpha = 0;
    self.contentView.frame = self.targetFrame;
    [[UIApplication sharedApplication].keyWindow addSubview:self];
    
    
    [UIView animateWithDuration:0.25 animations:^(void){
        
        self.backgroundView.alpha = 1.0;
        self.contentView.alpha = 1.0;
        CABasicAnimation *animation = [CABasicAnimation animationWithKeyPath:@"transform.scale"];
        animation.fromValue = [NSNumber numberWithFloat:1.5];
        animation.toValue = [NSNumber numberWithFloat:1.0];
        animation.duration = 0.25;
        [self.contentView.layer addAnimation:animation forKey:@"scale"];
    }];
}

/**消失
 */
- (void)dismiss
{
    [self removeFromSuperview];
}

#pragma mark- private method

/**获取某个按钮
 */
- (UIButton*)buttonForIndex:(NSInteger) index
{
    return (UIButton*)[self.contentView viewWithTag:SeaAlertViewButtonStartTag + index];
}

- (void)buttonDidClick:(UIButton*) btn
{
   if([self.delegate respondsToSelector:@selector(alertView:didClickAtIndex:)])
   {
       [self.delegate alertView:self didClickAtIndex:btn.tag - SeaAlertViewButtonStartTag];
   }
    
   [self dismiss];
}

@end
