//
//  SeaBadNetworkRemindView.m

//

#import "SeaBadNetworkRemindView.h"
#import "SeaBasic.h"

@interface SeaBadNetworkRemindView ()

/**重新加载数据按钮
 */
@property(nonatomic,strong) UIButton *reloadButton;

/**提示信息
 */
@property(nonatomic,strong) UILabel *messageLabel;

@end

@implementation SeaBadNetworkRemindView

/**构造方法
 *@param frame 大小位置
 *@param message 提示信息
 *@return 一个初始化的 SeaBadNetworkRemindView
 */
- (id)initWithFrame:(CGRect)frame message:(NSString*) message
{
    self = [super initWithFrame:frame];
    if(self)
    {
        if(message == nil)
            message = [NSString stringWithFormat:@"%@加载数据失败", _alertMsgWhenBadNetwork_];
        
        self.backgroundColor = [UIColor whiteColor];
        CGFloat buttonWidth = 100.0;
        CGFloat buttonHeight = 35.0;
        CGFloat margin = 15.0;
        
        UIFont *font = [UIFont fontWithName:MainFontName size:15.0];
        CGSize size = [message stringSizeWithFont:font contraintWith:frame.size.width];
        size.height += 1.0;
        
        CGFloat y = (frame.size.height - buttonHeight - size.height - margin) / 2.0;
        UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(0, y, frame.size.width, size.height)];
        label.backgroundColor = [UIColor clearColor];
        label.font = font;
        label.textAlignment = NSTextAlignmentCenter;
        label.textColor = [UIColor grayColor];
        label.text = message;
        label.numberOfLines = 0;
        [self addSubview:label];
        self.messageLabel = label;
    
        
        UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
        button.layer.cornerRadius = 3.0;
        button.layer.masksToBounds = YES;
        button.layer.borderColor = [UIColor grayColor].CGColor;
        button.layer.borderWidth = 1.0;
        [button setTitleColor:[UIColor grayColor] forState:UIControlStateNormal];
        [button setTitle:@"重新加载" forState:UIControlStateNormal];
        button.titleLabel.font = [UIFont fontWithName:MainFontName size:15.0];
        [button setFrame:CGRectMake((frame.size.width - buttonWidth) / 2.0, label.bottom + margin, buttonWidth, buttonHeight)];
        [button addTarget:self action:@selector(reload:) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:button];
        self.reloadButton = button;
    }
    return self;
}

- (void)setFrame:(CGRect)frame
{
    [super setFrame:frame];
    
    CGFloat margin = 15.0;
    CGFloat y = (frame.size.height - self.reloadButton.height - self.messageLabel.height - margin) / 2.0;
    self.messageLabel.frame = CGRectMake(0, y, frame.size.width, self.messageLabel.height);
    self.reloadButton.frame = CGRectMake((frame.size.width - self.reloadButton.width) / 2.0, self.messageLabel.bottom + margin, self.reloadButton.width, self.reloadButton.height);
}

- (void)dealloc
{
    
}

//重新加载数据
- (void)reload:(UIButton*) button
{
    if([self.delegate respondsToSelector:@selector(badNetworkRemindViewDidReloadData:)])
    {
        [self.delegate badNetworkRemindViewDidReloadData:self];
    }
}

@end
