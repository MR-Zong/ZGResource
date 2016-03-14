//
//  MomoGoods.m
//  瀑布流控制器
//
//  Created by 丁诚昊(831) on 15-5-26.
//  Copyright (c) 2015年 丁诚昊(831). All rights reserved.
//

#import "MomoGoods.h"

@implementation MomoGoods
- (instancetype)initWithDictionary:(NSDictionary *)dict{
    if (self = [super init]) {
        [self setValuesForKeysWithDictionary:dict];
    }
    return self;
}

+ (instancetype)momoGoodsWithDictionary:(NSDictionary *)dict{
    return [[self alloc] initWithDictionary:dict];
}
@end
