//
//  NSDate+ZGExtension.h
//  TestBS百思不得姐
//
//  Created by 徐宗根 on 15/9/17.
//  Copyright (c) 2015年 XuZonggen. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSDate (ZGExtension)


- (NSInteger)year;
- (NSInteger)month;
- (NSInteger)day;
- (NSInteger)hour;
- (NSInteger)minute;
- (NSInteger)second;



- (NSDateComponents *)yearMonthDay;
- (NSDateComponents *)hourMinuteSecond;
- (NSDateComponents *)all;

- (BOOL)isThisYear;
- (BOOL)isYesterday;
- (BOOL)isToday;
- (BOOL)isInOneHour;
- (BOOL)isINOneMinute;

- (BOOL)isTomorrow;



@end
