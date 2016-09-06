//
//  WaterFallViewController.m
//  瀑布流控制器
//
//  Created by 丁诚昊(831) on 15-5-25.
//  Copyright (c) 2015年 丁诚昊(831). All rights reserved.
//

#import "RootViewController.h"
#import "UIWaterFallView.h"
#import "UIWaterFallCube.h"
#import "GoodCube.h"
#import "MomoGoods.h"
#import "MJRefresh.h"

@interface RootViewController () <UIWaterFallDelegate,UIWaterFallDataSource>
@property (nonatomic,weak) UIWaterFallView* _waterfallView;
@property (nonatomic,strong) NSMutableArray* modelsArray; //模型数组
@end

@implementation RootViewController

- (NSMutableArray *)modelsArray{
    if (!_modelsArray) {
        self.modelsArray = [NSMutableArray array];
    }
    return _modelsArray;
}

- (void)didRotateFromInterfaceOrientation:(UIInterfaceOrientation)fromInterfaceOrientation{
    [self._waterfallView reloadData];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    //加载基础数据
    NSString* path = [[NSBundle mainBundle] pathForResource:@"2" ofType:@"plist"];
    NSArray* fileContents = [NSArray arrayWithContentsOfFile:path];
    for (int i = 0; i < fileContents.count; i++) {
        MomoGoods * model = [MomoGoods momoGoodsWithDictionary:fileContents[i]];
        [self.modelsArray addObject:model];
    }
    
    UIWaterFallView *waterView = [[UIWaterFallView alloc] init];
    waterView.frame = self.view.bounds;
    waterView.delegate = self;
    waterView.dataSource = self;
    waterView.autoresizingMask = UIViewAutoresizingFlexibleHeight | UIViewAutoresizingFlexibleWidth;
    
    [self.view addSubview:waterView];
    self.view.backgroundColor = [UIColor whiteColor];
    self._waterfallView = waterView;
    
    //增加上下拉刷新MJRefresh类
    [__waterfallView addHeaderWithTarget:self action:@selector(loadmoreNew)];
    [__waterfallView addFooterWithCallback:^{
        NSLog(@"___________________加载上拉刷新Old___________________");
        
        static dispatch_once_t onceToken;
        dispatch_once(&onceToken, ^{
            NSString *path = [[NSBundle mainBundle] pathForResource:@"3.plist" ofType:nil];
            NSArray *temp = [NSArray arrayWithContentsOfFile:path];
            NSMutableArray *nnew = [NSMutableArray arrayWithCapacity:temp.count];
            for (int i = 0; i < temp.count; i++) {
                MomoGoods *model = [MomoGoods momoGoodsWithDictionary:temp[i]];
                [nnew addObject:model];
            }
            [self.modelsArray addObjectsFromArray:nnew];
        });
        
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(2.0f * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
//            NSLog(@"waterfallView.bounds %@",NSStringFromCGRect(__waterfallView.bounds));
            [__waterfallView reloadData];
//            NSLog(@"waterfallView.bounds %@",NSStringFromCGRect(__waterfallView.bounds));
            [__waterfallView footerEndRefreshing];
        });
    }];
}

- (void) loadmoreNew{
    NSLog(@"___________________加载下拉刷新New___________________");
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        NSString *path = [[NSBundle mainBundle] pathForResource:@"1.plist" ofType:nil];
        NSArray *temp = [NSArray arrayWithContentsOfFile:path];
        NSMutableArray *nnew = [NSMutableArray arrayWithCapacity:temp.count];
        for (int i = 0; i < temp.count; i++) {
            MomoGoods *model = [MomoGoods momoGoodsWithDictionary:temp[i]];
            [nnew addObject:model];
        }
        [self.modelsArray insertObjects:nnew atIndexes:[NSIndexSet indexSetWithIndexesInRange:NSMakeRange(0, nnew.count)]];
    });
    
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(2.0f * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [__waterfallView reloadData];
        [__waterfallView headerEndRefreshing];
    });
}

- (NSUInteger)numberOfColumesInCubes:(UIWaterFallView *)waterFallView{
#pragma mark -- DEBUG -- 第二个横竖屏适配的bug是忘记写interfaceOrientation==UIInterfaceOrientationPortrait 粗心大意也是我的第二个很严重的毛病
    if (self.interfaceOrientation==UIInterfaceOrientationPortrait) {
        return 3; //竖屏
    }else
        return 5;
}

- (NSUInteger)numberOfCubesInWaterPool:(UIWaterFallView *)waterFallView{
    return self.modelsArray.count;
}

- (GoodCube *)waterFall:(UIWaterFallView *)waterfallView CubeAtIndex:(NSUInteger)index{
    GoodCube *cube = [GoodCube cubeWithWaterfallView:waterfallView];
    cube.model = self.modelsArray[index];
    return cube;
}

- (CGFloat)waterFall:(UIWaterFallView *)waterfallView HeightForCubeAtIndex:(NSUInteger)index{
    MomoGoods *model = self.modelsArray[index];
    CGFloat scale = model.w / model.h;
    return waterfallView.getWidthViaCols / scale;
}

-(CGFloat)waterFall:(UIWaterFallView *)waterfallView marginValueForMarginType:(MarginType)type{
    switch (type) {
        case MarginTypeTop: return 30;
        case MarginTypeBottom: return 50;
        case MarginTypeLeft:
        case MarginTypeRight: return 10;
        case MarginTypeColume: return 3;
        case MarginTypeRow: return 3.0f;
        default: return 5.0f;
    }
}

- (void)waterFall:(UIWaterFallView *)waterfallView DidSelectCuesAtIndex:(NSUInteger)index{
    
}
@end
