//
//  fsdfds.h
//  瀑布流控制器
//
//  Created by 丁诚昊(831) on 15-5-25.
//  Copyright (c) 2015年 丁诚昊(831). All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

#define kscreemWidth [UIScreen mainScreen].bounds.size.width
#define kscreemHeight [UIScreen mainScreen].bounds.size.height
//随机色
#define RandomColor [UIColor colorWithRed:arc4random_uniform(256)/255.0 green:arc4random_uniform(256)/255.0 blue:arc4random_uniform(256)/255.0 alpha:1.0]

typedef enum {
    MarginTypeTop,
    MarginTypeBottom,
    MarginTypeLeft,
    MarginTypeRight,
    MarginTypeRow,
    MarginTypeColume,
    MarginTypeDefault = 10
}MarginType;

@class UIWaterFallView,UIWaterFallCube;
@protocol UIWaterFallDataSource <NSObject>
#pragma mark -- 数据源代理协议 尽可能使用循环利用机制(使用数组实现)
@required
//numbers of Cubes
-(NSUInteger) numberOfCubesInWaterPool:(UIWaterFallView*) waterFallView;
//cubes...
-(UIWaterFallCube*) waterFall:(UIWaterFallView*)waterfallView CubeAtIndex:(NSUInteger)index;
@optional
//default is 3 if not specofied.
-(NSUInteger) numberOfColumesInCubes:(UIWaterFallView*) waterFallView;
//cube view from my UIView
@end

@protocol UIWaterFallDelegate <UIScrollViewDelegate>
#pragma mark -- cubes行为和参数代理 默认继承
-(CGFloat) waterFall:(UIWaterFallView*) waterfallView HeightForCubeAtIndex:(NSUInteger)index;
-(void) waterFall:(UIWaterFallView*)waterfallView DidSelectCuesAtIndex:(NSUInteger)index;
-(CGFloat) waterFall:(UIWaterFallView *)waterfallView marginValueForMarginType:(MarginType)type;
@optional
@end
