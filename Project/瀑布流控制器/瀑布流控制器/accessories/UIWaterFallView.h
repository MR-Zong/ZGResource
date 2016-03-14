//
//  WaterFallDelegate.h
//  瀑布流控制器
//
//  Created by 丁诚昊(831) on 15-5-25.
//  Copyright (c) 2015年 丁诚昊(831). All rights reserved.
//  接口文件：定义数据源和生命周期代理协议
//  UIWaterFallViewDelegate <-- 所有瀑布流控制器都必须实现这个协议

#import "UIWaterFallCube.h"
#import "UIWaterFallDataSource.h"

@interface UIWaterFallView : UIScrollView
@property (nonatomic,weak) id<UIWaterFallDataSource> dataSource;
@property (nonatomic,weak) id<UIWaterFallDelegate> delegate;
@property (atomic,weak,readonly) UIView* AnimatingCube;

- (void) reloadData;
- (id) dequeueReusableCubeWithIdentifier:(NSString*)identifier;
-(CGFloat) getWidthViaCols;
@end


