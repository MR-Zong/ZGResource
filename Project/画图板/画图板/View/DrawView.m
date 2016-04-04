//
//  DrawView.m
//  画图板
//
//  Created by 609972942 on 15/12/15.
//  Copyright (c) 2015年 ios. All rights reserved.
//

#import "DrawView.h"
#import "DataList.h"

@interface DrawView ()

@property (nonatomic,assign) CGMutablePathRef path;

@property (nonatomic,strong) NSMutableArray *dataArray;

//  管理路径属性
@property (nonatomic,assign) BOOL isRelease;

@end

@implementation DrawView

- (instancetype)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    if (self) {
        
        [self setBackgroundColor:[UIColor whiteColor]];
//      初始化list数组
        self.dataArray = [NSMutableArray array];
        
//      初始化属性
        self.drawColor = [UIColor redColor];
        self.drawWidth = 1.0f;
        
    }
    return self;
}

#pragma mark 绘图方法
- (void)drawRect:(CGRect)rect{
    [super drawRect:rect];
    
//------------之前所有的路径绘制------------
    for (DataList *list in self.dataArray) {
        
        if(list.listImage == nil){
            //  初始化上下文
            CGContextRef context = UIGraphicsGetCurrentContext();
            //  关联路径和上下文
            CGContextAddPath(context, list.bezierPath.CGPath);
            
            //  设置属性
            [list.color set];
            CGContextSetLineWidth(context, list.width);
            CGContextSetLineCap(context, kCGLineCapRound);
            CGContextSetLineJoin(context, kCGLineJoinRound);
            
            //  开始绘制
            CGContextDrawPath(context, kCGPathStroke);
            
        }else{
            
            [list.listImage drawInRect:self.bounds];
            
        }
    }
    
    
    
//---------------当前路径绘制--------------
    
    if (!self.isRelease) { // 路径开关(路径没有释放进行绘制)
    
    //  初始化上下文
        CGContextRef context = UIGraphicsGetCurrentContext();
    //  关联路径和上下文
        CGContextAddPath(context, self.path);
        
    //  设置属性
        [self.drawColor set];
        CGContextSetLineWidth(context, self.drawWidth);
        CGContextSetLineCap(context, kCGLineCapRound);
        CGContextSetLineJoin(context, kCGLineJoinRound);
        
    //  开始绘制
        CGContextDrawPath(context, kCGPathStroke);
        
    }
}


#pragma mark touch开始
- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event{
//  管理路径:路径没有释放
    [self setIsRelease:NO];
    
    self.path = CGPathCreateMutable();
    
//  取出touch
    UITouch *touch =[touches anyObject];
//  获得当前点击的点
    CGPoint startPoint =[touch locationInView:self];
//  获得起始点
    CGPathMoveToPoint(self.path, NULL, startPoint.x, startPoint.y);
//  重新绘制
    [self setNeedsDisplay];
}

#pragma mark touch移动
- (void)touchesMoved:(NSSet *)touches withEvent:(UIEvent *)event{
//  取出touch
    UITouch *touch =[touches anyObject];
//  获得当前点击的点
    CGPoint currentPoint =[touch locationInView:self];
    
//  绘制到的路径
    CGPathAddLineToPoint(self.path, NULL, currentPoint.x, currentPoint.y);
    
//  重新绘制
    [self setNeedsDisplay];
}


#pragma mark touch结束
- (void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event{
//  初始化模型
    DataList *list = [DataList dataListWithColor:self.drawColor andWidth:self.drawWidth andPath:self.path];
    
//  添加路径到dataSet
    [self.dataArray addObject:list];
    
//  释放路径
    CGPathRelease(self.path);
    
//  管理路径:路径释放
    [self setIsRelease:YES];
    
}


#pragma mark 撤销
- (void)undo{
//  删除最后一项
    [self.dataArray removeLastObject];
    
//  刷新
    [self setNeedsDisplay];
}

#pragma mark 清屏
- (void)clearScreen{
//  删除所有项
    [self.dataArray removeAllObjects];
    
//  刷新
    [self setNeedsDisplay];
}

#pragma mark drawImage的setter方法
- (void)setDrawImage:(UIImage *)drawImage{
    if (self.dataArray == nil) {
        self.dataArray = [NSMutableArray array];
    }
    
//  将drawImage存入list中
    DataList *list = [[DataList alloc]init];
    [list setListImage:drawImage];
//  将list存入dataArray
    [self.dataArray addObject:list];
    
    [self setNeedsDisplay];
}

@end
