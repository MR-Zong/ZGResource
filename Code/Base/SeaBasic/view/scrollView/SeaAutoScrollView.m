//
//  SeaAutoScrollView.m

//

#import "SeaAutoScrollView.h"
#import "SeaBasic.h"

@interface SeaAutoScrollView()

/**自动滚动计时器
 */
@property(nonatomic,retain) NSTimer *timer;

@end

@implementation SeaAutoScrollView

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if(self)
    {
        self.animatedTimeInterval = 5.0;
        self.enableScrollCircularly = YES;
    }
    return self;
}

- (void)dealloc
{
    [self stopAnimate];
}

#pragma mark- public method

/**开始动画
 */
- (void)startAnimate
{
    if(self.numberOfCells <= 1)
    {
        self.enableScrollCircularly = NO;
        return;
    }
    self.enableScrollCircularly = YES;
    
        
    if(!self.timer)
    {
        self.timer = [[NSTimer alloc] initWithFireDate:[NSDate dateWithTimeIntervalSinceNow:_animatedTimeInterval] interval:_animatedTimeInterval target:self selector:@selector(scrollAnimated:) userInfo:nil repeats:YES];
        [[NSRunLoop mainRunLoop] addTimer:self.timer forMode:NSRunLoopCommonModes];
    }
}

/**结束动画
 */
- (void)stopAnimate
{
    if(self.timer && [self.timer isValid])
    {
        [self.timer invalidate];
        self.timer = nil;
    }
}

#pragma mark- private method

//计时器滚动
- (void)scrollAnimated:(id) sender
{
    if(self.numberOfCells == 0)
        return;
    [self pageChangedWithAnimated:YES];
}

//滚动动画
- (void)pageChangedWithAnimated:(BOOL) flag
{
    if(self.numberOfCells > 0)
    {
        int page = floor(self.scrollView.contentOffset.x / self.scrollView.width); // 获取当前的page
        [self scrollToIndex:page + 1 animated:flag];
    }
}

- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView
{
    [self stopAnimate];
}

- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate
{
    [super scrollViewDidEndDragging:scrollView willDecelerate:decelerate];
    if(!decelerate)
    {
        [self startAnimate];
    }
}

- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView
{
    [super scrollViewDidEndDecelerating:scrollView];
    if(!scrollView.dragging)
    {
        [self startAnimate];
    }
}

@end
