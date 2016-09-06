//
//  SeaLabel.m

//

#import "SeaLabel.h"
#import <CoreText/CoreText.h>
#import "SeaBasic.h"

//系统默认的蓝色
#define _UIKitTintColor_ [UIColor colorWithRed:0 green:0.4784314 blue:1.0 alpha:1.0]

/**链接识别 正则表达式
 */
static NSString *const urlRegex = @"((http[s]{0,1}|ftp)://[a-zA-Z0-9\\.\\-]+\\.([a-zA-Z]{2,4})(:\\d+)?(/[a-zA-Z0-9\\.\\-~!@#$%^&*+?:_/=<>]*)?)|(www.[a-zA-Z0-9\\.\\-]+\\.([a-zA-Z]{2,4})(:\\d+)?(/[a-zA-Z0-9\\.\\-~!@#$%^&*+?:_/=<>]*)?)";

//static NSString *const urlRegex = @"\\b(https?)://(?:(\\S+?)(?::(\\S+?))?@)?([a-zA-Z0-9\\-.]+)(?::(\\d+))?((?:/[a-zA-Z0-9\\-._?,'+\\&%$=~*!():@\\\\]*)+)?";

@interface SeaLabel ()
{
    /**文本帧合成器
     */
    CTFramesetterRef _framesetter;
    
    /**文本帧
     */
    CTFrameRef _ctFrame;
}

/**文本帧合成器
 */
@property(nonatomic,readonly) CTFramesetterRef framesetter;

/**文本帧
 */
@property(nonatomic,readonly) CTFrameRef ctFrame;

/**链接，数组元素是 NSTextCheckingResult
 */
@property(nonatomic,strong) NSArray *urlArray;

/**url正则表达式执行器
 */
@property(nonatomic,strong) NSRegularExpression *expression;

/**单击手势
 */
@property(nonatomic,strong) UITapGestureRecognizer *tapGestureRecognizer;

@end

@implementation SeaLabel

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if(self)
    {
        self.backgroundColor = [UIColor clearColor];
        _textColor = [UIColor blackColor];
        _font = [UIFont fontWithName:MainFontName size:17.0];
        self.identifyURL = YES;
        _minLineHeight = 24.0;
        _wordSpace = 1.0;
        self.expression = [NSRegularExpression regularExpressionWithPattern:urlRegex options:NSRegularExpressionCaseInsensitive error:nil];
        
        self.URLAttributes = [NSDictionary dictionaryWithObjectsAndKeys:(id)[[UIColor blueColor] CGColor], (NSString*)kCTForegroundColorAttributeName, [NSNumber numberWithBool:YES], (NSString *)kCTUnderlineStyleAttributeName, nil];
        self.highlightColor = _UIKitTintColor_;
    }
    
    return self;
}

#pragma mark- dealloc

- (void)dealloc
{
    self.delegate = nil;

    
    if(_framesetter != NULL)
    {
        CFRelease(_framesetter);
    }
    
    if(_ctFrame != NULL)
    {
        CFRelease(_ctFrame);
    }
}

#pragma mark- property

- (CTFramesetterRef)framesetter
{
    @synchronized(self){
        if(_framesetter != NULL)
        {
            CFRelease(_framesetter);
        }
        _framesetter = CTFramesetterCreateWithAttributedString((CFAttributedStringRef) self.attributedText);
    }
    
    return _framesetter;
}

- (void)setText:(NSString *)text
{
    self.attributedText = [self defaultAttributedTextFromString:text];
}

- (NSString*)text
{
   return self.attributedText.string;
}

- (void)setAttributedText:(NSAttributedString *)attributedText
{
    if(_attributedText != attributedText)
    {
        _attributedText = [attributedText copy];
        [self setNeedsDisplay];
    }
}

- (void)setTextColor:(UIColor *)textColor
{
    if(![_textColor isEqualToColor:textColor])
    {
        _textColor = textColor;
        [self setNeedsDisplay];
    }
}

- (void)setFont:(UIFont *)font
{
    if(_font != font)
    {
        _font = font;
        [self setNeedsDisplay];
    }
}

- (void)setTextAlignment:(NSTextAlignment)textAlignment
{
    if(_textAlignment != textAlignment)
    {
        _textAlignment = textAlignment;
        [self setNeedsDisplay];
    }
}

- (void)setIdentifyURL:(BOOL)identifyURL
{
    if(_identifyURL != identifyURL)
    {
        _identifyURL = identifyURL;
        if(!self.tapGestureRecognizer)
        {
            UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(handleTap:)];
            tap.delegate = self;
            [self addGestureRecognizer:tap];
            self.tapGestureRecognizer = tap;
        }
        self.tapGestureRecognizer.enabled = _identifyURL;
    }
}

- (void)setURLAttributes:(NSDictionary *)URLAttributes
{
    if(_URLAttributes != URLAttributes)
    {
        _URLAttributes = URLAttributes;
        [self setNeedsDisplay];
    }
}

#pragma mark- public method

/**获取默认的富文本
 *@param string 要生成富文本的字符串
 *@return 根据 font textColor textAlignment 生成的富文本
 */
- (NSMutableAttributedString*)defaultAttributedTextFromString:(NSString*) string
{
    NSMutableAttributedString *attributedText = [[NSMutableAttributedString alloc] init];
    
    if(string == nil)
        return attributedText;
    
    CTFontRef font = CTFontCreateWithName((CFStringRef)self.font.fontName, self.font.pointSize, NULL);
    [attributedText addAttribute:(NSString*)kCTFontAttributeName value:(__bridge id)font  range:NSMakeRange(0, attributedText.length)];
    [attributedText addAttribute:(NSString*)kCTKernAttributeName value:[NSNumber numberWithFloat:self.wordSpace] range:NSMakeRange(0, attributedText.length)];
    [attributedText addAttribute:(NSString*)kCTForegroundColorAttributeName value:(id)self.textColor.CGColor range:NSMakeRange(0, attributedText.length)];
    CFRelease(font);
    
    if(self.identifyURL)
    {
        //获取url
        [self getURLsFromString:attributedText.string];
        //设置url样式
        for(NSTextCheckingResult *result in self.urlArray)
        {
            [attributedText addAttributes:self.URLAttributes range:result.range];
        }
    }
    
    //断落样式
    //换行模式
    CTParagraphStyleSetting lineBreadMode;
    CTLineBreakMode linkBreak = kCTLineBreakByCharWrapping;
    lineBreadMode.spec = kCTParagraphStyleSpecifierLineBreakMode;
    lineBreadMode.value = &linkBreak;
    lineBreadMode.valueSize = sizeof(CTLineBreakMode);
    
    //行距
    //    CTParagraphStyleSetting lineSpaceMode;
    //    CGFloat lineSpace = self.lineSpace;
    //    lineSpaceMode.spec = kCTParagraphStyleSpecifierLineSpacingAdjustment;
    //    lineSpaceMode.value = &lineSpace;
    //    lineSpaceMode.valueSize = sizeof(CGFloat);
    
    //对齐方式
    CTTextAlignment textAlignment;
    switch (self.textAlignment)
    {
        case NSTextAlignmentLeft:
            textAlignment = kCTTextAlignmentLeft;
            break;
        case NSTextAlignmentCenter :
            textAlignment = kCTTextAlignmentCenter;
            break;
        case NSTextAlignmentJustified :
            textAlignment = kCTTextAlignmentJustified;
            break;
        case NSTextAlignmentNatural :
            textAlignment = kCTTextAlignmentNatural;
            break;
        case NSTextAlignmentRight :
            textAlignment = kCTTextAlignmentRight;
            break;
    }
    
    CTParagraphStyleSetting alignment;
    alignment.spec = kCTParagraphStyleSpecifierAlignment;
    alignment.valueSize = sizeof(textAlignment);
    alignment.value = &textAlignment;
    
    //最小行高度
    CTParagraphStyleSetting minLineHeightMode;
    CGFloat minLineHeight = self.minLineHeight;
    minLineHeightMode.spec = kCTParagraphStyleSpecifierMinimumLineHeight;
    minLineHeightMode.value = &minLineHeight;
    minLineHeightMode.valueSize = sizeof(CGFloat);
    
    CTParagraphStyleSetting setting[] = {lineBreadMode, alignment, minLineHeightMode};
    
    CTParagraphStyleRef style = CTParagraphStyleCreate(setting, 2);
    [attributedText addAttribute:(NSString*)kCTParagraphStyleAttributeName value:(__bridge id)style range:NSMakeRange(0, attributedText.length)];
    CFRelease(style);
    
    return attributedText;
}

#pragma mark- draw 

- (void)drawRect:(CGRect)rect
{
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGContextSetTextMatrix(context, CGAffineTransformIdentity);//设置字形变换矩阵为CGAffineTransformIdentity，也就是说每一个字形都不做图形变换
    
    //翻转
    // Inverts the CTM to match iOS coordinates (otherwise text draws upside-down; Mac OS's system is different)
    //    CGContextTranslateCTM(context, 0.0f, rect.size.height);
    //    CGContextScaleCTM(context, 1.0f, -1.0f);
    
    CGAffineTransform transform = CGAffineTransformMake(1, 0, 0, -1, 0, rect.size.height);
    CGContextConcatCTM(context, transform);
    
    //开始绘制
    CGMutablePathRef path = CGPathCreateMutable();
    CGRect bounds = CGRectMake(_textInsets.left, _textInsets.top, rect.size.width - _textInsets.left - _textInsets.right, rect.size.height - _textInsets.top - _textInsets.bottom);
    CGPathAddRect(path, NULL, bounds);
    
    if(_ctFrame != NULL)
    {
        CFRelease(_ctFrame);
    }
    
    //文本框大小
    _ctFrame = CTFramesetterCreateFrame(self.framesetter, CFRangeMake(0, 0), path, NULL);
    CTFrameDraw(_ctFrame, context);
    
    if(path != NULL)
    {
        CFRelease(path);
    }
}

#pragma mark- URL

/**识别文本中的URL
 */
- (void)getURLsFromString:(NSString*) str
{
    if(str == nil || [str isEqual:[NSNull null]])
    {
        self.urlArray = [NSArray array];
        return;
    }
    
    NSArray *reuslts = [self.expression matchesInString:str options:0 range:NSMakeRange(0, str.length)];
    self.urlArray = reuslts;
}

- (BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldReceiveTouch:(UITouch *)touch
{
    return [self urlAtPoint:[touch locationInView:self]] != nil;
}

- (void)handleTap:(UITapGestureRecognizer*) tap
{
    if(tap.state != UIGestureRecognizerStateEnded)
    {
        return;
    }
    
    NSTextCheckingResult *result = [self urlAtPoint:[tap locationInView:self]];

    if(!result || !self.delegate)
        return;
    
    if([self.delegate respondsToSelector:@selector(label:didSelectURL:)])
    {
        [self.delegate label:self didSelectURL:[NSURL URLWithString:[self.text substringWithRange:result.range]]];
    }
    
}

//获取点中的url
- (NSTextCheckingResult*)urlAtPoint:(CGPoint) point
{
    NSUInteger index = [self characterIndexAtPoint:point];
    return [self urlAtCharacterIndex:index];
}

//判断是否点击到url
- (NSTextCheckingResult*)urlAtCharacterIndex:(NSInteger) index
{
    if(index == NSNotFound)
        return nil;
    for(NSTextCheckingResult *result in self.urlArray)
    {
        NSRange range = result.range;
        if(range.location <= index && index <= (range.location + range.length - 1))
        {
            return result;
        }
    }
    return nil;
}

//计算点击在字体上的位置
- (NSUInteger)characterIndexAtPoint:(CGPoint) point
{
    //判断点击处是否在文本内
    if (!CGRectContainsPoint(self.bounds, point))
    {
        return NSNotFound;
    }
    
    CGRect textRect = self.bounds;
    
    if (!CGRectContainsPoint(textRect, point))
    {
        return NSNotFound;
    }
    
    // Convert tap coordinates (start at top left) to CT coordinates (start at bottom left)
    point = CGPointMake(point.x, textRect.size.height - point.y);
    
    CFArrayRef lines = CTFrameGetLines(_ctFrame);
    NSUInteger numberOfLines = CFArrayGetCount(lines);
    if (numberOfLines == 0)
    {
        return NSNotFound;
    }
    
    CGPoint lineOrigins[numberOfLines];
    CTFrameGetLineOrigins(_ctFrame, CFRangeMake(0, 0), lineOrigins);
    
    NSUInteger lineIndex;
    for (lineIndex = 0; lineIndex < (numberOfLines - 1); lineIndex++)
    {
        CGPoint lineOrigin = lineOrigins[lineIndex];
        if (lineOrigin.y < point.y) {
            break;
        }
    }
    
    if (lineIndex >= numberOfLines)
    {
        return NSNotFound;
    }
    
    CGPoint lineOrigin = lineOrigins[lineIndex];
    CTLineRef line = CFArrayGetValueAtIndex(lines, lineIndex);
    
    // Convert CT coordinates to line-relative coordinates
    CGPoint relativePoint = CGPointMake(point.x - lineOrigin.x, point.y - lineOrigin.y);
    CFIndex idx = CTLineGetStringIndexForPosition(line, relativePoint);
    
    // We should check if we are outside the string range
    CFIndex glyphCount = CTLineGetGlyphCount(line);
    CFRange stringRange = CTLineGetStringRange(line);
    CFIndex stringRelativeStart = stringRange.location;
    if ((idx - stringRelativeStart) == glyphCount)
    {
        return NSNotFound;
    }
    
    return idx;
}


@end
