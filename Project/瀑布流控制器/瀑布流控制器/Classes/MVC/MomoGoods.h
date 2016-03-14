//
//  MomoGoods.h
//  瀑布流控制器
//
//  Created by 丁诚昊(831) on 15-5-26.
//  Copyright (c) 2015年 丁诚昊(831). All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@interface MomoGoods : NSObject
@property (nonatomic,copy) NSString* img; //图片url地址
@property (nonatomic,copy) NSString* price; //商品价格 字符串
@property (nonatomic,assign) CGFloat w; //宽度
@property (nonatomic,assign) CGFloat h; //图片高度

+(instancetype) momoGoodsWithDictionary:(NSDictionary*)dict;
-(instancetype) initWithDictionary:(NSDictionary*)dict;
@end
