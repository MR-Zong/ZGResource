//
//  GoodCube.m
//  瀑布流控制器
//
//  Created by 丁诚昊(831) on 15-5-27.
//  Copyright (c) 2015年 丁诚昊(831). All rights reserved.
//

#import "GoodCube.h"
#import "MomoGoods.h"
#import "UIWaterFallView.h"
#import "UIImageView+WebCache.h"

@interface GoodCube ()
@property (nonatomic,weak) UIImageView *imgView; //价格layer
@property (nonatomic,weak) UILabel* priceTitleView; //价格lable
@end

@implementation GoodCube

- (void)setModel:(MomoGoods *)model{
    _model = model;
    
    self.priceTitleView.text = model.price;
    [self.imgView sd_setImageWithURL:[NSURL URLWithString:model.img] placeholderImage:[UIImage imageNamed:@"placeholder"]];
}

- (void) layoutSubviews{
    [super layoutSubviews];
    self.imgView.frame = self.bounds;
    
    CGFloat priceH = 30.0f;
    CGFloat priceY = self.bounds.size.height - priceH;
    CGFloat priceX = 0;
    CGFloat priceW = self.bounds.size.width;
    self.priceTitleView.frame = CGRectMake(priceX, priceY, priceW, priceH);
}

- (instancetype)initWithFrame:(CGRect)frame{
    if (self = [super initWithFrame:frame]) {
        UIImageView* imgView = [[UIImageView alloc] init];
        self.imgView = imgView;
        [self addSubview:imgView];
        
        UILabel* lable = [[UILabel alloc] init];
        lable.backgroundColor = [UIColor colorWithRed:0 green:0 blue:0 alpha:.3f];
        lable.textAlignment = NSTextAlignmentNatural;
        lable.textColor = [UIColor whiteColor];
        self.priceTitleView = lable;
        [self addSubview:lable];
    }
    return self;
}

+ (GoodCube*) cubeWithWaterfallView:(UIWaterFallView*)waterfallView{
    static NSString* identifier = @"cubes";
    GoodCube *cube = [waterfallView dequeueReusableCubeWithIdentifier:identifier];
    if (!cube) {
        cube = [[GoodCube alloc] initWithReusableIdentifier:identifier];
    }
    return cube;
}
@end
