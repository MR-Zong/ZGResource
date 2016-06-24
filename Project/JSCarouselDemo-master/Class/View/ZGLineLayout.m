//
//  ZGLineLayout.m
//  JSCarouselDemo
//
//  Created by Zong on 16/6/23.
//  Copyright © 2016年 乔同新. All rights reserved.
//

#import "ZGLineLayout.h"

@implementation ZGLineLayout

- (void)prepareLayout
{
    [super prepareLayout];
//    CGFloat width = self.collectionView.frame.size.height * 0.7;

    self.itemSize = CGSizeMake(190, 252);
    self.scrollDirection = UICollectionViewScrollDirectionHorizontal;
//    self.minimumLineSpacing = 20;
    self.minimumLineSpacing = 0;
    
    // 设置内边距
    CGFloat inset = (self.collectionView.bounds.size.width - 190 ) /2.0;//(self.collectionView.frame.size.width - width) * 0.5;
    self.sectionInset = UIEdgeInsetsMake(0, inset, 0, inset);
}

- (NSArray<UICollectionViewLayoutAttributes *> *)layoutAttributesForElementsInRect:(CGRect)rect
{
    NSArray *array = [super layoutAttributesForElementsInRect:rect];
    
    // 计算 CollectionView 的中点
    CGFloat centerX = self.collectionView.contentOffset.x + self.collectionView.frame.size.width * 0.5;
    
    for (UICollectionViewLayoutAttributes *attrs in array)
    {
        // 计算 cell 中点的 x 值 与 centerX 的差值
        CGFloat delta = ABS(centerX - attrs.center.x);
        CGFloat scale = 1 - delta / (self.collectionView.frame.size.width * 1.5);
        attrs.transform = CGAffineTransformMakeScale(scale, scale);
    }
    return array;
}


/**
 ///  targetContentOffset ：通过修改后，collectionView最终的contentOffset(取决定情况)
 ///
 ///  proposedContentOffset ：默认情况下，collectionView最终的contentOffset
 ///  @param velocity              速率
 */
- (CGPoint)targetContentOffsetForProposedContentOffset:(CGPoint)proposedContentOffset withScrollingVelocity:(CGPoint)velocity
{
    // NSLog(@"%@",NSStringFromCGPoint(proposedContentOffset));
    CGSize size = self.collectionView.frame.size;
    
    // 计算可见区域的面积
    CGRect rect = CGRectMake(proposedContentOffset.x, proposedContentOffset.y, size.width, size.height);
    NSArray *array = [super layoutAttributesForElementsInRect:rect];
    // 计算 CollectionView 中点值
    CGFloat centerX = proposedContentOffset.x + self.collectionView.frame.size.width * 0.5;
    // 标记 cell 的中点与 UICollectionView 中点最小的间距
    CGFloat minDetal = MAXFLOAT;
    for (UICollectionViewLayoutAttributes *attrs in array)
    {
        if (ABS(minDetal) > ABS(centerX - attrs.center.x))
        {
            minDetal = attrs.center.x - centerX;
        }
    }
    return CGPointMake(proposedContentOffset.x + minDetal, proposedContentOffset.y);
}


//  当uicollectionView的bounds发生改变时，是否要刷新布局
- (BOOL)shouldInvalidateLayoutForBoundsChange:(CGRect)newBounds
{
    return YES;
}

@end
