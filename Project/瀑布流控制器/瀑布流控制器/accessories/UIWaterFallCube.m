//
//  WaterFallCube.m
//  瀑布流控制器
//
//  Created by 丁诚昊(831) on 15-5-25.
//  Copyright (c) 2015年 丁诚昊(831). All rights reserved.
//

#import "UIWaterFallCube.h"

@implementation UIWaterFallCube

- (instancetype)initWithReusableIdentifier:(NSString *)identifer{
    if (self = [super init]) {
        _identifier = identifer;
        self.backgroundColor = RandomColor;
    }
    return self;
}

@end
