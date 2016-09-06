//
//  NSObject+WMPushToOrderCharge.h
//  WestMailDutyFee
//
//  Created by qsit on 15/9/3.
//  Copyright (c) 2015年 qianseit. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSObject (WMPushToOrderCharge)
/**代销订单
 */
- (void)pushToSalesOrderWithSegmentIndex:(NSInteger)segmentIndex sliderMenuIndex:(NSInteger)sliderIndex statusBarIndex:(NSInteger)statusIndex;
/**进货订单
 */
- (void)pushToPurchaseOrderWithSegmentIndex:(NSInteger)segmentIndex statusBarIndex:(NSInteger)statusIndex;
@end
