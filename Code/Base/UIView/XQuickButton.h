//
//  XQuickButton.h
//  FreeLimit
//
//  Created by TBXark on 15-4-8.
//  Copyright (c) 2015年 TBXark. All rights reserved.
//

#import <UIKit/UIKit.h>
typedef void(^buttonAction)(id button);

@interface XQuickButton : UIButton

@property (nonatomic,copy) buttonAction action;

@end

@interface XQuickBarButton : UIBarButtonItem

@property (nonatomic,copy) buttonAction blockAction;

- (instancetype)initWithStyle:(UIBarButtonItemStyle)style
                       tittle:(NSString *)tittle
                       action:(void(^)(id button))action;

- (instancetype)initWithBarButtonSystemItem:(UIBarButtonSystemItem)systemItem
                                     action:(void(^)(id button))action;

- (instancetype)initWithImage:(UIImage *)image
                        style:(UIBarButtonItemStyle)style
                       action:(void(^)(id button))action;
@end
