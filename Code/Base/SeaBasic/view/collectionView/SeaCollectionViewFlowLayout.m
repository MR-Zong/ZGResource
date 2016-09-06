//
//  SeaCollectionViewFlowLayout.m
//  Sea
//
//  Created by 罗海雄 on 15/9/15.
//  Copyright (c) 2015年 Sea. All rights reserved.
//

#import "SeaCollectionViewFlowLayout.h"
#import "UIImage+Utilities.h"

#define LX_FRAMES_PER_SECOND 60.0

#ifndef CGGEOMETRY_LXSUPPORT_H_
CG_INLINE CGPoint
LXS_CGPointAdd(CGPoint thePoint1, CGPoint thePoint2) {
    return CGPointMake(thePoint1.x + thePoint2.x, thePoint1.y + thePoint2.y);
}
#endif

typedef NS_ENUM(NSInteger, LXReorderableCollectionViewFlowLayoutScrollingDirection) {
    LXReorderableCollectionViewFlowLayoutScrollingDirectionUp = 1,
    LXReorderableCollectionViewFlowLayoutScrollingDirectionDown,
    LXReorderableCollectionViewFlowLayoutScrollingDirectionLeft,
    LXReorderableCollectionViewFlowLayoutScrollingDirectionRight
};

static NSString * const kLXReorderableCollectionViewFlowLayoutScrollingDirectionKey = @"LXScrollingDirection";

@interface SeaCollectionViewFlowLayout ()<UIGestureRecognizerDelegate>

/**要移动的item
 */
@property(nonatomic,strong) NSIndexPath *selectedItem;

/**起始位置
 */
@property(nonatomic,strong) NSIndexPath *fromItem;

/**目标位置
 */
@property(nonatomic,strong) NSIndexPath *toItem;

/**模拟一个移动的视图，通过把选中的item生成图片
 */
@property(nonatomic,strong) UIImageView *simulationView;

@property (assign, nonatomic) UIEdgeInsets triggerScrollingEdgeInsets;
@property (assign, nonatomic) CGFloat scrollingSpeed;
@property (strong, nonatomic) NSTimer *scrollingTimer;


@property (assign, nonatomic) BOOL alwaysScroll;

@property (assign, nonatomic) CGPoint currentViewCenter;
@property (assign, nonatomic) CGPoint panTranslationInCollectionView;

@end

@implementation SeaCollectionViewFlowLayout

/**UICollectionView 布局之前会调用此方法，可在此地添加需要的手势
 */
- (void)prepareLayout
{
    if(!self.longGestureRecognizer)
    {
        _longGestureRecognizer = [[UILongPressGestureRecognizer alloc] initWithTarget:self action:@selector(handleLongPress:)];
        _longGestureRecognizer.delegate = self;
        
        
        _panGestureRecognizer = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(handlePan:)];
        _panGestureRecognizer.delegate = self;

        
        //让collectionView的手势相对于长按手势失败
        for(UIGestureRecognizer *gesture in self.collectionView.gestureRecognizers)
        {
            [gesture requireGestureRecognizerToFail:_longGestureRecognizer];
        }
        
        [self.collectionView addGestureRecognizer:_longGestureRecognizer];
        [self.collectionView addGestureRecognizer:_panGestureRecognizer];
        
        self.triggerScrollingEdgeInsets = UIEdgeInsetsMake(50.0f, 50.0f, 50.0f, 50.0f);
        self.scrollingSpeed = 300.0f;
        [self.scrollingTimer invalidate];
        self.scrollingTimer = nil;
        self.alwaysScroll = YES;
    }
}

//获取代理，直接使用 self.collectionView.delegate 会报错
- (id<SeaCollectionViewFlowLayoutDelegate>)sea_delegate
{
    return (id<SeaCollectionViewFlowLayoutDelegate>) self.collectionView.delegate;
}

//设置当前选中itemlayout属性
- (void)setupCurLayoutAttributes:(UICollectionViewLayoutAttributes*) attributes
{
    if(attributes.representedElementCategory != UICollectionElementCategoryCell)
        return;
    
    if(self.toItem != nil && attributes.indexPath.section == self.toItem.section && attributes.indexPath.row == self.toItem.row)
    {
        attributes.hidden = YES;
    }
    else
    {
        attributes.hidden = NO;
    }
}

#pragma mark- super method

- (UICollectionViewLayoutAttributes*)layoutAttributesForItemAtIndexPath:(NSIndexPath *)indexPath
{
    UICollectionViewLayoutAttributes *attributes = [super layoutAttributesForItemAtIndexPath:indexPath];
    [self setupCurLayoutAttributes:attributes];
    
    return attributes;
}

- (NSArray*)layoutAttributesForElementsInRect:(CGRect)rect
{
    NSArray *attributes = [super layoutAttributesForElementsInRect:rect];
    
    for(UICollectionViewLayoutAttributes *attribute in attributes)
    {
        [self setupCurLayoutAttributes:attribute];
    }
    
    return attributes;
}

#pragma mark- handle gesture

//长按手势，获取要移动的item
- (void)handleLongPress:(UILongPressGestureRecognizer*) longPress
{
    if(longPress.state == UIGestureRecognizerStateBegan)
    {
        _editing = YES;
        
        CGPoint point = [longPress locationInView:self.collectionView];
        
        NSIndexPath *indexPath = [self.collectionView indexPathForItemAtPoint:point];
        
        if([[self sea_delegate] respondsToSelector:@selector(collectionView:layout:willBeginMoveItemAtIndexPath:)])
        {
            [[self sea_delegate] collectionView:self.collectionView layout:self willBeginMoveItemAtIndexPath:indexPath];
        }
        
        UICollectionViewCell *cell = [self.collectionView cellForItemAtIndexPath:indexPath];
        
        //创建模拟视图
        UIImage *image = [UIImage imageFromView:cell];
        
        UIImageView *imageView = [[UIImageView alloc] initWithFrame:cell.frame];
        
        imageView.image = image;
        
        self.simulationView = imageView;
        
        [self.collectionView addSubview:self.simulationView];
        
        self.selectedItem = indexPath;
        self.fromItem = indexPath;
        self.toItem = indexPath;
        
        [UIView animateWithDuration:0.25 animations:^(void)
        {
            self.simulationView.transform = CGAffineTransformMakeScale(1.2, 1.2);
        }
        completion:^(BOOL finish)
        {
            if([[self sea_delegate] respondsToSelector:@selector(collectionView:layout:didBeginMoveItemAtIndexPath:)])
            {
                [[self sea_delegate] collectionView:self.collectionView layout:self didBeginMoveItemAtIndexPath:indexPath];
            }
        }];
        
        //刷新collectionView 的布局
        [self invalidateLayout];
    }
    else if (longPress.state == UIGestureRecognizerStateEnded)
    {
        
        if([[self sea_delegate] respondsToSelector:@selector(collectionView:layoutWillEndEdit:fromIndexPath:toIndexPath:)])
        {
            [[self sea_delegate] collectionView:self.collectionView layoutWillEndEdit:self fromIndexPath:self.selectedItem toIndexPath:self.toItem];
        }
        
        UICollectionViewLayoutAttributes *attributes = [self layoutAttributesForItemAtIndexPath:self.toItem];
        
        [UIView animateWithDuration:0.25 animations:^(void)
         {
             self.simulationView.transform = CGAffineTransformMakeScale(1.0, 1.0);
             
             //transform 和 frame 冲突
             self.simulationView.center = attributes.center;
         }
         completion:^(BOOL finish)
         {
             _editing = NO;
             
             NSIndexPath *selectedItem = self.selectedItem;
             NSIndexPath *toItem = self.toItem;
             
             self.selectedItem = nil;
             self.fromItem = nil;
             self.toItem = nil;
             [self invalidateLayout];
             [self.simulationView removeFromSuperview];
             self.simulationView = nil;
             
             if([[self sea_delegate] respondsToSelector:@selector(collectionView:layoutDidEndEdit:fromIndexPath:toIndexPath:)])
             {
                 [[self sea_delegate] collectionView:self.collectionView layoutDidEndEdit:self fromIndexPath:selectedItem toIndexPath:toItem];
             }

         }];
    }
}

//平移手势，移动item
- (void)handlePan:(UIPanGestureRecognizer*) pan
{
    if(pan.state == UIGestureRecognizerStateBegan || pan.state == UIGestureRecognizerStateChanged)
    {
        CGPoint point = [pan locationInView:self.collectionView];
        
        self.panTranslationInCollectionView = point;
        
        self.simulationView.center = point;
        
        NSIndexPath *indexPath = [self.collectionView indexPathForItemAtPoint:point];
        
        //这个位置没有item
        if(indexPath != nil)
        {
            //判断是否可移动到这个位置
            BOOL can = YES;
            if([[self sea_delegate] respondsToSelector:@selector(collectionView:layout:canMoveItemAtIndexPath:toIndexPath:)])
            {
                can = [[self sea_delegate] collectionView:self.collectionView layout:self canMoveItemAtIndexPath:self.selectedItem toIndexPath:indexPath];
            }
            
            if(can)
            {
                self.fromItem = self.toItem;
                
                self.toItem = indexPath;
                
                if([[self sea_delegate] respondsToSelector:@selector(collectionView:layout:didMoveItemAtIndexPath:toIndexPath:)])
                {
                    [[self sea_delegate] collectionView:self.collectionView layout:self didMoveItemAtIndexPath:self.fromItem toIndexPath:self.toItem];
                }
                else
                {
                    //抛出警告，最好实现 collectionView:layout:didMoveItemAtIndexPath:toIndexPath:
                    NSLog(@"warning: 最好实现 collectionView:layout:didMoveItemAtIndexPath:toIndexPath:，否则collectionView 中的内容会发生错乱");
                }
   
                [self.collectionView moveItemAtIndexPath:self.fromItem toIndexPath:self.toItem];
            }
        }
        
        switch (self.scrollDirection)
        {
            case UICollectionViewScrollDirectionVertical:
            {
                if (point.y < (CGRectGetMinY(self.collectionView.bounds) + self.triggerScrollingEdgeInsets.top)) {
                    BOOL isScrollingTimerSetUpNeeded = YES;
                    if (self.scrollingTimer) {
                        if (self.scrollingTimer.isValid) {
                            isScrollingTimerSetUpNeeded = ([self.scrollingTimer.userInfo[kLXReorderableCollectionViewFlowLayoutScrollingDirectionKey] integerValue] != LXReorderableCollectionViewFlowLayoutScrollingDirectionUp);
                        }
                    }
                    if (isScrollingTimerSetUpNeeded)
                    {
                        if (self.scrollingTimer) {
                            [self.scrollingTimer invalidate];
                            self.scrollingTimer = nil;
                        }
                        self.scrollingTimer = [NSTimer scheduledTimerWithTimeInterval:1.0 / LX_FRAMES_PER_SECOND
                                                                               target:self
                                                                             selector:@selector(handleScroll:)
                                                                             userInfo:@{ kLXReorderableCollectionViewFlowLayoutScrollingDirectionKey : @( LXReorderableCollectionViewFlowLayoutScrollingDirectionUp ) }
                                                                              repeats:YES];
                    }
                } else if (point.y > (CGRectGetMaxY(self.collectionView.bounds) - self.triggerScrollingEdgeInsets.bottom)) {
                    BOOL isScrollingTimerSetUpNeeded = YES;
                    if (self.scrollingTimer) {
                        if (self.scrollingTimer.isValid) {
                            isScrollingTimerSetUpNeeded = ([self.scrollingTimer.userInfo[kLXReorderableCollectionViewFlowLayoutScrollingDirectionKey] integerValue] != LXReorderableCollectionViewFlowLayoutScrollingDirectionDown);
                        }
                    }
                    if (isScrollingTimerSetUpNeeded) {
                        if (self.scrollingTimer) {
                            [self.scrollingTimer invalidate];
                            self.scrollingTimer = nil;
                        }
                        self.scrollingTimer = [NSTimer scheduledTimerWithTimeInterval:1.0 / LX_FRAMES_PER_SECOND
                                                                               target:self
                                                                             selector:@selector(handleScroll:)
                                                                             userInfo:@{ kLXReorderableCollectionViewFlowLayoutScrollingDirectionKey : @( LXReorderableCollectionViewFlowLayoutScrollingDirectionDown ) }
                                                                              repeats:YES];
                    }
                } else {
                    if (self.scrollingTimer) {
                        [self.scrollingTimer invalidate];
                        self.scrollingTimer = nil;
                    }
                }
            } break;
            case UICollectionViewScrollDirectionHorizontal: {
                if (point.x < (CGRectGetMinX(self.collectionView.bounds) + self.triggerScrollingEdgeInsets.left)) {
                    BOOL isScrollingTimerSetUpNeeded = YES;
                    if (self.scrollingTimer) {
                        if (self.scrollingTimer.isValid) {
                            isScrollingTimerSetUpNeeded = ([self.scrollingTimer.userInfo[kLXReorderableCollectionViewFlowLayoutScrollingDirectionKey] integerValue] != LXReorderableCollectionViewFlowLayoutScrollingDirectionLeft);
                        }
                    }
                    if (isScrollingTimerSetUpNeeded) {
                        if (self.scrollingTimer) {
                            [self.scrollingTimer invalidate];
                            self.scrollingTimer = nil;
                        }
                        self.scrollingTimer = [NSTimer scheduledTimerWithTimeInterval:1.0 / LX_FRAMES_PER_SECOND
                                                                               target:self
                                                                             selector:@selector(handleScroll:)
                                                                             userInfo:@{ kLXReorderableCollectionViewFlowLayoutScrollingDirectionKey : @( LXReorderableCollectionViewFlowLayoutScrollingDirectionLeft ) }
                                                                              repeats:YES];
                    }
                } else if (point.x > (CGRectGetMaxX(self.collectionView.bounds) - self.triggerScrollingEdgeInsets.right)) {
                    BOOL isScrollingTimerSetUpNeeded = YES;
                    if (self.scrollingTimer) {
                        if (self.scrollingTimer.isValid) {
                            isScrollingTimerSetUpNeeded = ([self.scrollingTimer.userInfo[kLXReorderableCollectionViewFlowLayoutScrollingDirectionKey] integerValue] != LXReorderableCollectionViewFlowLayoutScrollingDirectionRight);
                        }
                    }
                    if (isScrollingTimerSetUpNeeded) {
                        if (self.scrollingTimer) {
                            [self.scrollingTimer invalidate];
                            self.scrollingTimer = nil;
                        }
                        self.scrollingTimer = [NSTimer scheduledTimerWithTimeInterval:1.0 / LX_FRAMES_PER_SECOND
                                                                               target:self
                                                                             selector:@selector(handleScroll:)
                                                                             userInfo:@{ kLXReorderableCollectionViewFlowLayoutScrollingDirectionKey : @( LXReorderableCollectionViewFlowLayoutScrollingDirectionRight ) }
                                                                              repeats:YES];
                    }
                } else {
                    if (self.scrollingTimer) {
                        [self.scrollingTimer invalidate];
                        self.scrollingTimer = nil;
                    }
                }
            } break;
        }
    }
    else if (pan.state == UIGestureRecognizerStateEnded)
    {
        if (self.scrollingTimer) {
            [self.scrollingTimer invalidate];
            self.scrollingTimer = nil;
        }
    }
}

- (void)handleScroll:(NSTimer *)theTimer
{
    LXReorderableCollectionViewFlowLayoutScrollingDirection theScrollingDirection = (LXReorderableCollectionViewFlowLayoutScrollingDirection)[theTimer.userInfo[kLXReorderableCollectionViewFlowLayoutScrollingDirectionKey] integerValue];
    switch (theScrollingDirection) {
        case LXReorderableCollectionViewFlowLayoutScrollingDirectionUp: {
            CGFloat theDistance = -(self.scrollingSpeed / LX_FRAMES_PER_SECOND);
            CGPoint theContentOffset = self.collectionView.contentOffset;
            CGFloat theMinY = 0.0f;
            if ((theContentOffset.y + theDistance) <= theMinY) {
                theDistance = -theContentOffset.y;
            }
            self.collectionView.contentOffset = LXS_CGPointAdd(theContentOffset, CGPointMake(0.0f, theDistance));
            self.currentViewCenter = LXS_CGPointAdd(self.currentViewCenter, CGPointMake(0.0f, theDistance));
            self.simulationView.center = LXS_CGPointAdd(self.currentViewCenter, self.panTranslationInCollectionView);
        } break;
        case LXReorderableCollectionViewFlowLayoutScrollingDirectionDown: {
            CGFloat theDistance = (self.scrollingSpeed / LX_FRAMES_PER_SECOND);
            CGPoint theContentOffset = self.collectionView.contentOffset;
            CGFloat theMaxY = MAX(self.collectionView.contentSize.height, CGRectGetHeight(self.collectionView.bounds)) - CGRectGetHeight(self.collectionView.bounds);
            if ((theContentOffset.y + theDistance) >= theMaxY) {
                theDistance = theMaxY - theContentOffset.y;
            }
            self.collectionView.contentOffset = LXS_CGPointAdd(theContentOffset, CGPointMake(0.0f, theDistance));
            self.currentViewCenter = LXS_CGPointAdd(self.currentViewCenter, CGPointMake(0.0f, theDistance));
            self.simulationView.center = LXS_CGPointAdd(self.currentViewCenter, self.panTranslationInCollectionView);
        } break;
            
        case LXReorderableCollectionViewFlowLayoutScrollingDirectionLeft: {
            CGFloat theDistance = -(self.scrollingSpeed / LX_FRAMES_PER_SECOND);
            CGPoint theContentOffset = self.collectionView.contentOffset;
            CGFloat theMinX = 0.0f;
            if ((theContentOffset.x + theDistance) <= theMinX) {
                theDistance = -theContentOffset.x;
            }
            self.collectionView.contentOffset = LXS_CGPointAdd(theContentOffset, CGPointMake(theDistance, 0.0f));
            self.currentViewCenter = LXS_CGPointAdd(self.currentViewCenter, CGPointMake(theDistance, 0.0f));
            self.simulationView.center = LXS_CGPointAdd(self.currentViewCenter, self.panTranslationInCollectionView);
        } break;
        case LXReorderableCollectionViewFlowLayoutScrollingDirectionRight: {
            CGFloat theDistance = (self.scrollingSpeed / LX_FRAMES_PER_SECOND);
            CGPoint theContentOffset = self.collectionView.contentOffset;
            CGFloat theMaxX = MAX(self.collectionView.contentSize.width, CGRectGetWidth(self.collectionView.bounds)) - CGRectGetWidth(self.collectionView.bounds);
            if ((theContentOffset.x + theDistance) >= theMaxX) {
                theDistance = theMaxX - theContentOffset.x;
            }
            self.collectionView.contentOffset = LXS_CGPointAdd(theContentOffset, CGPointMake(theDistance, 0.0f));
            self.currentViewCenter = LXS_CGPointAdd(self.currentViewCenter, CGPointMake(theDistance, 0.0f));
            self.simulationView.center = LXS_CGPointAdd(self.currentViewCenter, self.panTranslationInCollectionView);
        } break;
            
        default: {
        } break;
    }
}

#pragma mark- UIGestureRecognizer delegate

//判断是否可以开始手势
- (BOOL)gestureRecognizerShouldBegin:(UIGestureRecognizer *)gestureRecognizer
{
    if([gestureRecognizer isEqual:_longGestureRecognizer])
    {
        CGPoint point = [gestureRecognizer locationInView:self.collectionView];
        NSIndexPath *indexPath = [self.collectionView indexPathForItemAtPoint:point];
        
        //点击的位置不是cell
        if(indexPath == nil)
            return NO;
        
        //判断是否可以移动该item
        BOOL can = YES;
        if([[self sea_delegate] respondsToSelector:@selector(collectionView:layout:canMoveItemAtIndexPath:)])
        {
            can = [[self sea_delegate] collectionView:self.collectionView layout:self canMoveItemAtIndexPath:indexPath];
        }
        
        _editing = can;
        return can;
    }
    else if ([gestureRecognizer isEqual:_panGestureRecognizer])
    {
        return _editing;
    }
    
    return YES;
}

//让长按手势和平移手势共存，默认手势不共存
- (BOOL)gestureRecognizer:(UIGestureRecognizer *)theGestureRecognizer shouldRecognizeSimultaneouslyWithGestureRecognizer:(UIGestureRecognizer *)theOtherGestureRecognizer
{
    if([self.longGestureRecognizer isEqual:theGestureRecognizer])
    {
        return [self.panGestureRecognizer isEqual:theOtherGestureRecognizer];
    }
    else if([self.panGestureRecognizer isEqual:theGestureRecognizer])
    {
        return [self.longGestureRecognizer isEqual:theOtherGestureRecognizer];
    }
    
    return NO;
}

@end
