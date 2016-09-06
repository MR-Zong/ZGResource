//
//  SeaFullImagePreviewView.m

//

#import "SeaFullImagePreviewView.h"
#import "SeaScrollView.h"
#import "SeaFullImagePreviewCell.h"
#import "SeaBasic.h"

@interface SeaFullImagePreviewView ()<SeaScrollViewDelegate>

//滚动视图
@property(nonatomic,strong) SeaScrollView *scrollView;

//是否正在动画
@property(nonatomic,assign) BOOL isAnimating;

@end

@implementation SeaFullImagePreviewView

/**构造方法
 *@param source 图片路径集合 ，数组元素是 NSString
 *@param index 当前显示的图片下标
 *@return 一个初始化的 SeaFullImagePreviewView 对象
 */
- (id)initWithSource:(NSArray*) source visibleIndex:(NSInteger) index
{
    self = [super initWithFrame:CGRectMake(0, 0, _width_, _height_)];
    if(self)
    {
        self.backgroundColor = [UIColor blackColor];
        self.source = source;
        
        SeaScrollView *scrollView = [[SeaScrollView alloc] initWithFrame:self.bounds];
        scrollView.showPageControl = YES;
        scrollView.pageControl.currentPageIndicatorTintColor = _appMainColor_;
        scrollView.delegate = self;
        [self addSubview:scrollView];
        self.scrollView = scrollView;

        
        [scrollView reloadData];
        [scrollView scrollToIndex:index animated:NO];
    }
    
    return self;
}

//初始化
- (void)initialization
{
    
}

- (void)dealloc
{
    
}

#pragma mark- property

- (NSInteger)visibleIndex
{
    return self.scrollView.visibleIndex;
}

#pragma mark- public method

/**显示全屏预览
 *@param show 是否显示
 *@param rect 起始位置大小，可以通过 - (CGRect)convertRect:(CGRect)rect toWindow:(UIWindow *)window 方法来获取
 *@param flag 是否动画
 */
- (void)setShowFullScreen:(BOOL) show fromRect:(CGRect) rect flag:(BOOL) flag
{
    SeaFullImagePreviewCell *cell = [_scrollView.visibleCells anyObject];
    
    CGFloat animatedDuration = 0.5;
    if(show)
    {
        self.previousFrame = rect;
        
        if([self.delegate respondsToSelector:@selector(fullImagePreviewviewWillEnterFullScreen:)])
        {
            [self.delegate fullImagePreviewviewWillEnterFullScreen:self];
        }
        
        cell.imageView.frame = rect;
        [[UIApplication sharedApplication].keyWindow addSubview:self];
       
        CGRect frame;
        frame.origin.x = MAX(0, (cell.width - cell.imageView.image.size.width) / 2.0);
        frame.origin.y = MAX(0, (cell.height - cell.imageView.image.size.height) / 2.0);
        frame.size = cell.imageView.image.size;
        
        if(flag)
        {
            self.isAnimating = YES;
            [UIView animateWithDuration:animatedDuration animations:^(void){
                
                cell.imageView.frame = frame;
            }completion:^(BOOL finish){
                self.isAnimating = NO;
                if([self.delegate respondsToSelector:@selector(fullImagePreviewviewDidEnterFullScreen:)])
                {
                    [self.delegate fullImagePreviewviewDidEnterFullScreen:self];
                }
            }];
        }
        else
        {
            cell.imageView.frame = frame;
            if([self.delegate respondsToSelector:@selector(fullImagePreviewviewDidEnterFullScreen:)])
            {
                [self.delegate fullImagePreviewviewDidEnterFullScreen:self];
            }
        }
    }
    else
    {
        self.backgroundColor = [UIColor clearColor];
        self.scrollView.pageControl.hidden = YES;
        if(cell.imageView.image && flag)
        {
            if([self.delegate respondsToSelector:@selector(fullImagePreviewviewWillExistFullScreen:)])
            {
                [self.delegate fullImagePreviewviewWillExistFullScreen:self];
            }
            if(CGRectEqualToRect(self.previousFrame, CGRectZero))
            {
                self.isAnimating = YES;
                [UIView animateWithDuration:animatedDuration animations:^(void){
                    
                    cell.zoomScale = 1.5;
                    self.alpha = 0;
                }completion:^(BOOL finish){
                    
                    self.isAnimating = NO;
                    [self removeFromSuperview];
                    if([self.delegate respondsToSelector:@selector(fullImagePreviewviewDidExistFullScreen:)])
                    {
                        [self.delegate fullImagePreviewviewDidExistFullScreen:self];
                    }
                }];
            }
            else
            {
                self.isAnimating = YES;
                [UIView animateWithDuration:animatedDuration animations:^(void){
                    
                    cell.imageView.frame = self.previousFrame;
                }completion:^(BOOL finish){
                    
                    self.isAnimating = NO;
                    [self removeFromSuperview];
                    if([self.delegate respondsToSelector:@selector(fullImagePreviewviewDidExistFullScreen:)])
                    {
                        [self.delegate fullImagePreviewviewDidExistFullScreen:self];
                    }
                }];
            }
        }
        else
        {
            [self removeFromSuperview];
            if([self.delegate respondsToSelector:@selector(fullImagePreviewviewDidExistFullScreen:)])
            {
                [self.delegate fullImagePreviewviewDidExistFullScreen:self];
            }
        }
    }
}

/**重新加载数据
 */
- (void)reloadData
{
    [self.scrollView reloadData];
}

/**获取可见的cell
 */
- (SeaFullImagePreviewCell*)visibleCell
{
    SeaFullImagePreviewCell *cell = [_scrollView.visibleCells anyObject];
    return cell;
}

#pragma mark- scrollView delegate

- (NSInteger)numberOfCellsInScrollView:(SeaScrollView *)scrollView
{
    return self.source.count;
}

- (id)scrollView:(SeaScrollView *)scrollView cellForIndex:(NSInteger)index
{
    SeaFullImagePreviewCell *cell = [scrollView dequeueRecycledCell];
    if(cell == nil)
    {
        cell = [[SeaFullImagePreviewCell alloc] initWithFrame:self.bounds];
        cell.imageView.sea_actStyle = UIActivityIndicatorViewStyleWhiteLarge;
        cell.imageView.sea_placeHolderColor = [UIColor clearColor];
//        UITapGestureRecognizer *doubleTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(handleDoubleTap:)];
//        doubleTap.numberOfTapsRequired = 2;
//        [cell addGestureRecognizer:doubleTap];
//        [doubleTap release];
        
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(handleTap:)];
        [cell addGestureRecognizer:tap];
       // [tap requireGestureRecognizerToFail:doubleTap];
    }
    
    cell.zoomScale = 1.0;
    cell.contentSize = cell.bounds.size;

    [cell.imageView sea_setImageWithURL:[self.source objectAtIndex:index] completion:^(UIImage *image, BOOL fromNetwork){
     
        [cell layoutImageAfterLoad];
    }];
    
    return cell;
}

#pragma mark- private method

//单击
- (void)handleTap:(UITapGestureRecognizer*) tap
{
    if(self.isAnimating)
        return;
    SeaFullImagePreviewCell *cell = (SeaFullImagePreviewCell*)tap.view;
    if(cell.zoomScale == 1.0)
    {
        [self setShowFullScreen:NO fromRect:CGRectZero flag:YES];
    }
    else
    {
        [cell setZoomScale:1.0 animated:YES];
    }
}

//双击
- (void)handleDoubleTap:(UITapGestureRecognizer*) tap
{
    if(self.isAnimating)
        return;
    SeaFullImagePreviewCell *cell = (SeaFullImagePreviewCell*)tap.view;
    if(cell.zoomScale == 1.0)
    {
        [cell setZoomScale:cell.maximumZoomScale animated:YES];
    }
    else
    {
        [cell setZoomScale:1.0 animated:YES];
    }
}

@end
