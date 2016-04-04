//
//  WaterFallCube.h
//  瀑布流控制器
//
//  Created by 丁诚昊(831) on 15-5-25.
//  Copyright (c) 2015年 丁诚昊(831). All rights reserved.
//

#import <UIKit/UIKit.h>
#import <Foundation/Foundation.h>

#import "UIWaterFallDataSource.h"

@interface UIWaterFallCube : UIView
@property (nonatomic, readonly, copy) NSString* identifier;
-(instancetype) initWithReusableIdentifier:(NSString*)identifer;
@end
