//
//  XQuickButton.m
//  FreeLimit
//
//  Created by TBXark on 15-4-8.
//  Copyright (c) 2015年 TBXark. All rights reserved.
//

#import "XQuickButton.h"


@implementation XQuickButton
{
    BOOL _isSet;
}

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    {
        [self setBlockToAction];
    }
    return self;
}

- (void)setAction:(buttonAction)action
{
    _action = action;
    [self setBlockToAction];
}

- (void)buttonClick:(id)sender
{
    if (_action) {
        _action(self);
    }
}

- (void)setBlockToAction
{
    if (_isSet) {
        return;
    }
     [self addTarget:self action:@selector(buttonClick:) forControlEvents:UIControlEventTouchUpInside];
    _isSet = YES;
}

@end



@implementation XQuickBarButton

- (instancetype)initWithStyle:(UIBarButtonItemStyle)style
                       tittle:(NSString *)tittle
                       action:(buttonAction)action
{
    self = [super initWithTitle:tittle style:style target:self action:@selector(buttonClick:)];
    _blockAction = action;
    return self;
}

- (instancetype)initWithBarButtonSystemItem:(UIBarButtonSystemItem)systemItem
                                     action:(void(^)(id button))action
{
    self = [super initWithBarButtonSystemItem:systemItem target:self action:@selector(buttonClick:)];
    _blockAction = action;
    return self;
}

- (instancetype)initWithImage:(UIImage *)image style:(UIBarButtonItemStyle)style action:(void (^)(id))action
{
    self = [super initWithImage:image style:style target:self action:@selector(buttonClick:)];
    _blockAction = action;
    return self;
}


- (void)buttonClick:(id)sender
{
    if (_blockAction) {
        _blockAction(self);
    }
}

@end
