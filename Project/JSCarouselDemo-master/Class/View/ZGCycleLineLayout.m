//
//  ZGCycleLineLayout.m
//  JSCarouselDemo
//
//  Created by Zong on 16/6/23.
//  Copyright © 2016年 乔同新. All rights reserved.
//

#import "ZGCycleLineLayout.h"

@implementation ZGCycleLineLayout

- (void)prepareLayout
{
    [super prepareLayout];
    
}


- (UICollectionViewLayoutAttributes *)layoutAttributesForItemAtIndexPath:(NSIndexPath *)indexPath
{
    return nil;
}

- (NSArray<UICollectionViewLayoutAttributes *> *)layoutAttributesForElementsInRect:(CGRect)rect
{
    return nil;
}

- (CGPoint)targetContentOffsetForProposedContentOffset:(CGPoint)proposedContentOffset withScrollingVelocity:(CGPoint)velocity
{
    return CGPointZero;
}

@end
