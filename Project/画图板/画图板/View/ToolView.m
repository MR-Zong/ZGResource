//
//  ToolView.m
//  画图板
//
//  Created by 609972942 on 15/12/15.
//  Copyright (c) 2015年 ios. All rights reserved.
//

#import "ToolView.h"
#import "ToolItem.h"

#define kMargin 10

typedef enum {
    kColor,
    kWidth,
    kErraser,
    kUndo,
    kClear,
    kPhoto,
    kSave
} itemType;


@interface ToolView ()
{
    SelectedColorBlock _selectedColorBlock;
    SelectedWidthBlock _selectedWidthBlock;
    OtherBlock _erraser;
    OtherBlock _undo;
    OtherBlock _clear;
    OtherBlock _photo;
    OtherBlock _save;
}
@property (nonatomic,strong) ToolItem *recoredItem;

@property (nonatomic,strong) SelectedColorView *colorView;
@property (nonatomic,strong) SelectedWidthView *widthView;


@end

@implementation ToolView

- (instancetype)initWithFrame:(CGRect)frame andSelectedColorBlock:(SelectedColorBlock)selectedColorBlock andSelectedWidthBlock:(SelectedWidthBlock)selectedWidthBlock andErraserBlock:(OtherBlock)erraser andUndo:(OtherBlock)undo andClear:(OtherBlock)clear andPhoto:(OtherBlock)photo andSave:(OtherBlock)save{
    self = [super initWithFrame:frame];
    if (self) {
        
        _selectedColorBlock = selectedColorBlock;
        _selectedWidthBlock = selectedWidthBlock;
        _save =  save;
        _undo =  undo;
        _clear = clear;
        _erraser = erraser;
        _photo = photo;
        
        [self setBackgroundColor:[UIColor colorWithPatternImage:[UIImage imageNamed:@"tool_back"]]];
        
        NSArray *itemsTitleArray = @[@"颜色",@"线宽",@"橡皮",@"撤销",@"清屏",@"相机",@"保存"];
        
        [self creatToolItem:itemsTitleArray];
    }
    return self;
}

#pragma mark 初始化toolView中的item
- (void)creatToolItem:(NSArray *)itemArray{
    
    NSInteger count = itemArray.count;
    
    CGFloat width = (self.bounds.size.width - (count + 1) * kMargin) / count;
    CGFloat height = self.bounds.size.height - kMargin;
    
    for (NSInteger i =0; i < count; i ++) {
        
        ToolItem *item = [[ToolItem alloc]initWithFrame:CGRectMake(i * (width + kMargin) + kMargin, kMargin / 2, width, height)];
        [item setTitle:itemArray[i] forState:UIControlStateNormal];
        [item setTag:i];
        [item addTarget:self action:@selector(itemCilck:) forControlEvents:UIControlEventTouchUpInside];
        
        [self addSubview:item];
        
    }
    
}

#pragma mark item的监听事件
- (void)itemCilck:(ToolItem *)item{
//  先设置上一个isTap为NO
    [self.recoredItem setIsTap:NO];
    
//  在设置这个isTap为YES
    [item setIsTap:YES];
    
//  将这一次给上一个
    self.recoredItem = item;
    
    switch (item.tag) {
        case kColor:
            
//          强行隐藏其他试图
            [self forceHideView:self.colorView];
            
            
//          显示或则隐藏试图
            [self comeOrHideSelectedColorView];
            
            break;
            
        case kWidth:
            
//          强行隐藏其他试图
            [self forceHideView:self.widthView];
            
            
//          显示或则隐藏试图
            [self comeOrHideSelectedWidthView];
            
            break;
        case kErraser:
            
            _erraser();
//          强行隐藏其他试图
            [self forceHideView:nil];
            
            break;
        case kUndo
            :
            
            _undo();
            
            [self forceHideView:nil];
            
            break;
        case kClear:
            
            _clear();
            
            [self forceHideView:nil];
            
            break;
        case kPhoto:
            
            _photo();
            
            [self forceHideView:nil];
            
            break;
        case kSave:
            
            _save();
            
            [self forceHideView:nil];
            
            break;
            
        default:
            break;
    }
}

#pragma mark 显示或者隐藏宽度试图
- (void)comeOrHideSelectedWidthView{
//  初始化widthView
    if (self.widthView == nil) {
        self.widthView = [[SelectedWidthView alloc]initWithFrame:CGRectMake(0, - 44, self.bounds.size.width, 44) andSelectedWidthBlock:^(CGFloat width) {
            
            _selectedWidthBlock(width);
            
            [self comeOrHideWithView:self.widthView];
        }];
        
        [self addSubview:self.widthView];
        
    }
    
//  调用显示或者隐藏
    [self comeOrHideWithView:self.widthView];
}

#pragma mark 显示或者隐藏颜色试图
- (void)comeOrHideSelectedColorView{
//  初始化colorView
    if (self.colorView == nil) {
        self.colorView = [[SelectedColorView alloc]initWithFrame:CGRectMake(0, - 44, self.bounds.size.width, 44) andSelectedColorBlock:^(UIColor *color) {
            
            _selectedColorBlock(color);
            [self comeOrHideWithView:self.colorView];
            
        }];
        
        [self addSubview:self.colorView];
        
    }
    
//  调用显示或者隐藏
    [self comeOrHideWithView:self.colorView];
}


#pragma mark 显示或者隐藏的代码抽出
- (void)comeOrHideWithView:(UIView *)otherView{
    
    CGFloat y =otherView.frame.origin.y;
//  显示或则隐藏的frame
    CGRect comeFrame = CGRectMake(0, 44, self.bounds.size.width, 44);
    CGRect hideFrame = CGRectMake(0, - 64, self.bounds.size.width, 44);
    
    [UIView animateWithDuration:0.6f animations:^{
        
//      收起或则推出
        if (y < 0) {
            
            [otherView setFrame:comeFrame];
            [self setFrame:CGRectMake(0, 20, self.bounds.size.width, 44 * 2)];
            
        }else{
            
            [otherView setFrame:hideFrame];
            [self setFrame:CGRectMake(0, 20, self.bounds.size.width, 44)];
        }
    }];
}


#pragma mark 强行隐藏试图
- (void)forceHideView:(UIView *)myView{
//  取出将要强行隐藏的试图
    UIView *forceView;
    if (self.colorView.frame.origin.y > 0) {
        forceView = self.colorView;
    }else if(self.widthView.frame.origin.y > 0){
        
        forceView = self.widthView;
    }else{
        
        return;
    }
    
//  如果试图和将要隐藏的试图是一个试图就return
    if (myView == forceView) {
        return;
    }
    
//  调用隐藏
    [self comeOrHideWithView:forceView];
    
}





@end
