//
//  SSTextView.m
//  SSToolkit
//
//  Created by Sam Soffes on 8/18/10.
//  Copyright 2010-2011 Sam Soffes. All rights reserved.
//

#import "SeaTextView.h"
#import "SeaBasic.h"

#define _controlHeight_ 30

@interface SeaTextView ()

//滚动次数
@property(nonatomic,assign) NSInteger scrollCount;

- (void)_initialize;
- (void)_updateShouldDrawPlaceholder;
- (void)_textChanged:(NSNotification *)notification;


@end


@implementation SeaTextView
{
	BOOL _shouldDrawPlaceholder;
}


#pragma mark - Accessors

@synthesize placeholder = _placeholder;
@synthesize placeholderTextColor = _placeholderTextColor;

- (void)setText:(NSString *)text
{
    [super setText:text];

    int length = (int)(self.maxCount - text.length);
    
    _numLabel.text = [NSString stringWithFormat:@"%d",length >= 0 ? length : 0];
	[self _updateShouldDrawPlaceholder];
    [self setNeedsLayout];
}


- (void)setPlaceholder:(NSString *)placeholder
{
	if ([placeholder isEqual:_placeholder])
    {
		return;
	}
	
	_placeholder = [placeholder copy];
    
    if(_shouldDrawPlaceholder)
    {
        _shouldDrawPlaceholder = NO;
    }
    
	[self _updateShouldDrawPlaceholder];
}


#pragma mark - NSObject

- (void)dealloc
{
	[[NSNotificationCenter defaultCenter] removeObserver:self name:UITextViewTextDidChangeNotification object:self];
}


#pragma mark - UIView

- (id)initWithCoder:(NSCoder *)aDecoder
{
	if ((self = [super initWithCoder:aDecoder]))
    {
        self.limitable = NO;
		[self _initialize];
	}
	return self;
}


- (id)initWithFrame:(CGRect)frame
{
	if ((self = [super initWithFrame:frame]))
    {
		[self _initialize];
        self.limitable = NO;
	}
	return self;
}

#pragma mark- property

- (void)setFrame:(CGRect)frame
{
    [super setFrame:frame];
    _numLabel.frame = CGRectMake(self.width - _numLabel.width - 6.0, self.height - _numLabel.height, _numLabel.width, _numLabel.height);
}

- (void)setLimitable:(BOOL)limitable
{
    if(_limitable != limitable)
    {
        _limitable = limitable;
        if(!_numLabel)
        {
            CGFloat width = 40.0;
            CGFloat height = 25.0;
            _numLabel = [[UILabel alloc] initWithFrame:CGRectMake(self.width - width, self.height - height, width, height)];
            _numLabel.text = [NSString stringWithFormat:@"%d/%d",(int)(self.maxCount - self.text.length), (int)self.maxCount];
            _numLabel.backgroundColor = [UIColor clearColor];
            [_numLabel setTextAlignment:NSTextAlignmentCenter];
            _numLabel.textColor = [UIColor grayColor];
            _numLabel.font = [UIFont fontWithName:MainNumberFontName size:12.0];
            _numLabel.adjustsFontSizeToFitWidth = YES;
            [self addSubview:_numLabel];

        }
        _numLabel.hidden = !_limitable;
    }
}

- (void)setMaxCount:(NSInteger)maxCount
{
    if(_maxCount != maxCount)
    {
        _maxCount = maxCount;
        _numLabel.text = [NSString stringWithFormat:@"%d",(int)(_maxCount - self.text.length)];
    }
}


#pragma mark- draw

- (void)drawRect:(CGRect)rect
{
    [super drawRect:rect];
    
    if (_shouldDrawPlaceholder)
    {
        [_placeholder drawInRect:CGRectMake(_placeholderOffset.x, _placeholderOffset.y, self.frame.size.width - _placeholderOffset.x * 2, self.frame.size.height - _placeholderOffset.y * 2) withAttributes:[NSDictionary dictionaryWithObjectsAndKeys:self.placeholderFont, NSFontAttributeName, self.placeholderTextColor, NSForegroundColorAttributeName, nil]];
    }
    
}



- (void)layoutSubviews
{
    [super layoutSubviews];

    _numLabel.frame = CGRectMake(_numLabel.left, self.bounds.origin.y + self.bounds.size.height - _numLabel.height, _numLabel.width, _numLabel.height);
}

#pragma mark - Private

- (void)_initialize
{
	[[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(_textChanged:) name:UITextViewTextDidChangeNotification object:self];
	
    self.placeholderFont = [UIFont fontWithName:MainFontName size:15.0];
	self.placeholderTextColor = [UIColor colorWithWhite:0.702f alpha:0.7];
	_shouldDrawPlaceholder = NO;
    self.placeholderOffset = CGPointMake(8.0f, 8.0f);
}


- (void)_updateShouldDrawPlaceholder
{
    BOOL prev = _shouldDrawPlaceholder;
	_shouldDrawPlaceholder = self.placeholder && self.placeholderTextColor && self.text.length == 0;
    
	if (prev != _shouldDrawPlaceholder) {
		[self setNeedsDisplay];
	}
}


- (void)_textChanged:(NSNotification *)notification
{
	[self _updateShouldDrawPlaceholder];
}

#pragma mark- 文本限制

/**内容改变
 */
- (void)textDidChange
{
    int length = (int)(self.maxCount - self.text.length);
    self.numLabel.text = [NSString stringWithFormat:@"%d",length < 0 ? 0 : length];
    
    if (self.markedTextRange == nil && self.text.length > self.maxCount)
    {
        NSString *str = [self.text substringWithRange:NSMakeRange(0, self.maxCount)];
        self.text = str;
    }
}

/**是否替换内容
 *@param range 替换的范围
 *@param text 新的内容
 *@return 是否替换
 */
- (BOOL)shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text
{
    UITextRange *textRange = [self markedTextRange];
    
    NSString *markText = [self textInRange:textRange];
    
    NSString *new = [self.text stringByReplacingCharactersInRange:range withString:text];
    
    NSInteger length = new.length - (textRange.empty ? 0 : markText.length + 1);
    
    NSInteger res = self.maxCount - length;
    
    self.numLabel.text = [NSString stringWithFormat:@"%d",(int)(res < 0 ? 0 : res)];
    
    if(res > 0)
    {
        return YES;
    }
    else
    {
        NSInteger len = self.maxCount - self.text.length;
        if(len < 0)
            len = 0;
        if(len > text.length)
            len = text.length;
        
        NSString *str = [self.text stringByReplacingCharactersInRange:range withString:[text substringWithRange:NSMakeRange(0, len)]];
        NSRange selectedRange = self.selectedRange;
        self.text = str;
        self.selectedRange = selectedRange;
        
        return NO;
    }
}

@end
