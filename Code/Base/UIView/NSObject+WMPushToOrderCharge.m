//
//  NSObject+WMPushToOrderCharge.m
//  WestMailDutyFee
//
//  Created by qsit on 15/9/3.
//  Copyright (c) 2015年 qianseit. All rights reserved.
//


#import "NSObject+WMPushToOrderCharge.h"

#import "WMOrderManagerController.h"
#import "WMHomeViewController.h"
#import "WMTabBarController.h"
#import "WMConfirmOrderViewController.h"
#import "WMValetOrderViewController.h"

@implementation NSObject (WMPushToOrderCharge)
- (void)pushToPurchaseOrderWithSegmentIndex:(NSInteger)segmentIndex statusBarIndex:(NSInteger)statusIndex{
    
    WMTabBarController *root = [AppDelegate tabBarController];
    
    SeaNavigationController *nav = (SeaNavigationController*)[root selectedViewController];
    
    NSMutableArray *viewControllers = [NSMutableArray arrayWithArray:[nav viewControllers]];
    
    NSInteger index = 0;
    
    for(UIViewController *vc in viewControllers)
    {
        if([vc isKindOfClass:[WMConfirmOrderViewController class]])
        {
            break;
        }
        index ++;
    }
    
    WMOrderManagerController *order = [[WMOrderManagerController alloc] init];
    
    order.segementIndex = segmentIndex;
    
    order.seaMenuBarIndex = statusIndex;
    
    [viewControllers replaceObjectAtIndex:index withObject:order];
    
    NSMutableArray *arr = [[NSMutableArray alloc] init];
    
    [arr addObject:[viewControllers firstObject]];
    
    NSNumber *hasUnSelectGoods = [[NSUserDefaults standardUserDefaults] objectForKey:@"stockHasUnSelectGoods"];
    
    if (hasUnSelectGoods.boolValue) {
        
        [arr addObject:[viewControllers objectAtIndex:4]];
        
        [[NSUserDefaults standardUserDefaults] setObject:[NSNumber numberWithBool:NO] forKey:@"stockHasUnSelectGoods"];
    }
    
    [arr addObject:[viewControllers lastObject]];
    
    [nav setViewControllers:arr animated:YES];
}

- (void)pushToSalesOrderWithSegmentIndex:(NSInteger)segmentIndex sliderMenuIndex:(NSInteger)sliderIndex statusBarIndex:(NSInteger)statusIndex{
    
    WMTabBarController *root = [AppDelegate tabBarController];
    
    SeaNavigationController *nav = (SeaNavigationController*)[root selectedViewController];
    
    NSMutableArray *viewControllers = [NSMutableArray arrayWithArray:[nav viewControllers]];
    
    NSInteger index = 0;
    
    for(UIViewController *vc in viewControllers)
    {
        if([vc isKindOfClass:[WMConfirmOrderViewController class]] || [vc isKindOfClass:[WMOrderManagerController class]])
        {
            break;
        }
        index ++;
    }
    
    WMOrderManagerController *order = [[WMOrderManagerController alloc] init];
    
    order.segementIndex = segmentIndex;
    
    order.seaMenuBarIndex = statusIndex;
    
    order.sliderIndex = sliderIndex;
    
    [viewControllers replaceObjectAtIndex:index withObject:order];
    
    NSNumber *hasUnSelectGoods = [[NSUserDefaults standardUserDefaults] objectForKey:@"saleHasUnSelectGoods"];
    
    if (hasUnSelectGoods.boolValue) {
        
        [[NSUserDefaults standardUserDefaults] setObject:[NSNumber numberWithBool:NO] forKey:@"saleHasUnSelectGoods"];
    }
    else{
        
        WMValetOrderViewController *valetOrderController = [viewControllers firstObject];
        
        valetOrderController.shopCarView.quantityLabel.text = @"0";
        
        valetOrderController.shopCarView.quantityHidden = YES;
        
        [viewControllers removeObjectAtIndex:1];
    }
    
    [nav setViewControllers:viewControllers animated:YES];
}






@end
