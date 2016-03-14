//
//  GoodCube.h
//  瀑布流控制器
//
//  Created by 丁诚昊(831) on 15-5-27.
//  Copyright (c) 2015年 丁诚昊(831). All rights reserved.
//

#import "UIWaterFallCube.h"

@class MomoGoods,UIWaterFallView;

@interface GoodCube : UIWaterFallCube
@property (nonatomic,strong) MomoGoods* model; //momo对象

+ (GoodCube*) cubeWithWaterfallView:(UIWaterFallView*)waterfallView;
@end
