//
//  UIWaterFallView.m
//  瀑布流控制器
//
//  Created by 丁诚昊(831) on 15-5-25.
//  Copyright (c) 2015年 丁诚昊(831). All rights reserved.
//

#import "UIWaterFallView.h"

//瀑布流默认的宽度是均分的 不需要事先指定
#define DefaultCubeValuesHeight kscreemHeight*0.3f //如果没有实现代理 就事先指定块高
#define NUMBEROFCOLUMES 3

//屏幕宽高比
#define scale (kscreemWidth/kscreemHeight)

@interface UIWaterFallView ()
@property (nonatomic,strong) NSMutableArray* CubesFrame; //CGRect
@property (nonatomic,strong) NSMutableDictionary* showingCubesInRect; //WaterFallCube
@property (nonatomic,strong) NSMutableSet* reusableCachePool;//anyobject
@end

@implementation UIWaterFallView

#pragma mark -- leftCycle & overWrite
/**模仿uitableview的缓存回收机制*/
- (void)layoutSubviews{
    
//    NSLog(@"layoutSubviews");
#pragma mark --DEBUG-- 代理中的数量已经刷新到100个了 但是layoutSubview会向CubesFrame数组索要数据 而此时Cubes中只有50个 所以一定会有数组越界异常...2015年5月27日星期三到第二天凌晨2点一直忙活了3个小时 原来还是Model层的数据结构知识不够 需要加强生命周期方法的学习:何时调用
    NSUInteger totalCount = self.CubesFrame.count;
    for (NSUInteger i = 0; i < totalCount ; i++) { // 每次都遍历totalCount不太好
        
        CGRect rect = [self.CubesFrame[i] CGRectValue];
        
        UIWaterFallCube *cubeInView = [self.showingCubesInRect objectForKey:@(i)];
        if ([self isRectInCurrentView:rect]) {
            if (!cubeInView) { // 已经有view 说明已经在界面上，所以什么都不用做了
                cubeInView = [self.dataSource waterFall:self CubeAtIndex:i];
                cubeInView.frame = rect;
                [self addSubview:cubeInView];
                [self.showingCubesInRect setObject:cubeInView forKey:@(i)];
            }
        }else{
            if(cubeInView){ // 之前还在屏幕上，但现在已经离开屏幕了
                [cubeInView removeFromSuperview];
                [self.showingCubesInRect removeObjectForKey:@(i)];
                [self.reusableCachePool addObject:cubeInView];//存放进缓存池
            }
        }
    }
}

- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event{
    UITouch *touch = [touches anyObject];
    CGPoint point = [touch locationInView:self];//self 就是 waterfallView
    
    __block NSNumber *selectedIndex;
    [self.showingCubesInRect enumerateKeysAndObjectsUsingBlock:^(id key, UIWaterFallCube* cube, BOOL *stop) {
        if (CGRectContainsPoint(cube.frame, point)) {
            selectedIndex = key;
            _AnimatingCube = cube;
            *stop = YES;
        }else{
            selectedIndex = [[NSNumber alloc] initWithInt:-1];
            _AnimatingCube = nil;
        }
    }];
    
    //进入点击事件
    if ([self.delegate respondsToSelector:@selector(waterFall:DidSelectCuesAtIndex:)]) {
        [self.delegate waterFall:self DidSelectCuesAtIndex:[selectedIndex unsignedIntegerValue]];
        [self wumaotexiao];//加载一个五毛特效
    }
}

//五毛特效 或增加一个block动画操作快到WFView绑定块属性
- (void)wumaotexiao{
    UIColor *bgColor = self.backgroundColor;
    UIWaterFallCube* cube = (UIWaterFallCube*)self.AnimatingCube;
    CATransition* animation;
    
    if(cube){
        //1.动画 ：------------块旋------------
        animation = [CATransition animation];
        animation.duration = 1.75f;
        animation.subtype = @"fromLeft";
        animation.type = @"cube";//全局动画
        
        [cube.layer addAnimation:animation forKey:nil];
    }else{
        //2.动画 ：-------------水滴效果-------------
        animation = [CATransition animation];
        animation.duration = 1.25f;
        animation.type = @"rippleEffect";
        
        [UIView animateWithDuration:1.25f animations:^{
            self.layer.backgroundColor = [UIColor colorWithRed:255 green:255 blue:255 alpha:.04].CGColor;
            [self.layer addAnimation:animation forKey:nil];
        } completion:^(BOOL finished) {
            self.layer.backgroundColor = bgColor.CGColor;
            self.userInteractionEnabled = YES;
        }];
    }
}

- (void)willMoveToSuperview:(UIView *)newSuperview{
    [self reloadData];
}

#pragma mark -- private methods & callBack
- (id)dequeueReusableCubeWithIdentifier:(NSString *)identifier{
    __block UIWaterFallCube* anyObject = nil;
    [self.reusableCachePool enumerateObjectsUsingBlock:^(UIWaterFallCube* cube, BOOL *stop) {
        if ([cube.identifier isEqualToString:identifier]) {
            *stop = YES;
            anyObject = cube;
        }
    }];
    
    if (anyObject != nil) {
        [self.reusableCachePool removeObject:anyObject];
    }
    return anyObject;
}

//判断一个矩阵是否在屏幕上
- (BOOL) isRectInCurrentView:(CGRect)rect{
    return (CGRectGetMaxY(rect) > self.contentOffset.y && CGRectGetMinY(rect) < self.contentOffset.y + self.bounds.size.height);
}

-(CGFloat) getWidthViaCols{
    static CGFloat width;
    
    if (width == 0) {
        NSUInteger cols = [self numberOfColumes];
        CGFloat marginLeft = [self marginValue:MarginTypeLeft];
        CGFloat marginRight = [self marginValue:MarginTypeRight];
        CGFloat marginCol = [self marginValue:MarginTypeColume];
        width = (self.bounds.size.width - marginLeft - marginRight - marginCol*(cols - 1)) / cols;
    }else
        return width;
    
    return width;
}

/**.MJ的实现的是用一个C语言数组(宽度[cols])存放cols个Y值 每次循环拿到数组里最小的Y值进行运算 然后更新数组Y值*/
- (void)reloadData{
    //0.清除之前的旧数据
    [self.CubesFrame removeAllObjects];
    [[self.showingCubesInRect allValues] makeObjectsPerformSelector:@selector(removeFromSuperview)];
    [self.showingCubesInRect removeAllObjects];
    [self.reusableCachePool removeAllObjects];
    
    //1.刷新数据容量
    NSUInteger const totalAmount = [self.dataSource numberOfCubesInWaterPool:self];
    //2.定义间距
    NSUInteger cols = [self numberOfColumes];
    NSLog(@"此时的列数：%lu",(unsigned long)cols);
    
    CGFloat marginTop = [self marginValue:MarginTypeTop];
    CGFloat marginBottom = [self marginValue:MarginTypeBottom];
    CGFloat marginLeft = [self marginValue:MarginTypeLeft];
    CGFloat marginRow = [self marginValue:MarginTypeRow];
    CGFloat marginCol = [self marginValue:MarginTypeColume];
    
    //3.x,y也是需要计算的 width是固定的 height是根据代理返回的,如果没有高度就使用Cube自定义高度
    CGFloat width,height,x,y;
    width = [self getWidthViaCols];
    CGFloat buf[cols];
    for (int i = 0;  i < cols;  i++) buf[i] = 0.0f;/**init buf[cols]*/
    
    for (NSInteger i = 0;  i < totalAmount ; i++) {
        height = [self heightAtIndex:i]; //也可以在外部定义 delegate代理已经向上抛出了指针
        int index = 0;//[0~cols] 保存C中的最小Y值
        if (i < cols) {
            x = marginLeft + (width + marginCol ) * (i % cols);
            y = marginTop;
            buf[i] = height + marginTop + marginRow;
        }else{
            for (int j = 1; j < cols; j++)  //遍历找出最小的值
                if(buf[index] > buf[j])
                    index = j;
            
            x = marginLeft + (width + marginCol) * index;
            y = buf[index];
            buf[index] += height + marginRow;//更新缓存数组
        }
        CGRect cubeFrames = CGRectMake(x, y, width, height);
        [self.CubesFrame addObject:[NSValue valueWithCGRect:cubeFrames]];
    }
    
    int index = 0;
    for (int i = 1; i < cols; i++) //再次遍历找出最大的值 设置遮盖值的+margin为最大的滚动试图的content
        if (buf[index] < buf[i])
            index = i;
    
    self.contentSize = CGSizeMake(0, buf[index] + marginBottom);
    return;
}

#pragma mark -- getter & setter
-(NSMutableDictionary*) showingCubesInRect{
    if (!_showingCubesInRect) {
        self.showingCubesInRect = [NSMutableDictionary dictionaryWithCapacity:self.CubesFrame.count];
    }
    return _showingCubesInRect;
}

-(NSMutableSet*) reusableCachePool{
    if (!_reusableCachePool) {
        self.reusableCachePool = [NSMutableSet set];
    }
    return _reusableCachePool;
}

-(NSUInteger) numberOfColumes{
    if([self.dataSource respondsToSelector:@selector(numberOfColumesInCubes:)])
        return [self.dataSource numberOfColumesInCubes:self];
    else
        return NUMBEROFCOLUMES;
}

-(CGFloat) heightAtIndex:(NSUInteger)index{
    if([self.dataSource respondsToSelector:@selector(numberOfColumesInCubes:)])
        return [self.delegate waterFall:self HeightForCubeAtIndex:index];
    else{
        NSLog(@"fucked:返回DefaultCubeValuesHeight");
        return DefaultCubeValuesHeight;
    }
}

-(CGFloat) marginValue:(MarginType)type{
    if([self.delegate respondsToSelector:@selector(waterFall:marginValueForMarginType:)]){
        return [self.delegate waterFall:self marginValueForMarginType:type];
    }else
        return MarginTypeDefault;
}

- (NSMutableArray*) CubesFrame{
    if (!_CubesFrame) {
        self.CubesFrame = [NSMutableArray array];
    }
    return _CubesFrame;
}
@end
