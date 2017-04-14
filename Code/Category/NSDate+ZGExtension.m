//
//  NSDate+ZGExtension.m
//  TestBS百思不得姐
//
//  Created by 徐宗根 on 15/9/17.
//  Copyright (c) 2015年 XuZonggen. All rights reserved.
//

#import "NSDate+ZGExtension.h"

@implementation NSDate (ZGExtension)


- (NSInteger)year
{
    NSCalendar *calendar = [NSCalendar currentCalendar];
    
    return [calendar component:NSCalendarUnitYear fromDate:self];
}

- (NSInteger)month
{
    NSCalendar *calendar = [NSCalendar currentCalendar];
    
    return [calendar component:NSCalendarUnitMonth fromDate:self];
}


- (NSInteger)day
{
    NSCalendar *calendar = [NSCalendar currentCalendar];
    
    return [calendar component:NSCalendarUnitDay fromDate:self];
}


- (NSInteger)hour
{
    NSCalendar *calendar = [NSCalendar currentCalendar];
    
    return [calendar component:NSCalendarUnitHour fromDate:self];
}


- (NSInteger)minute
{
    NSCalendar *calendar = [NSCalendar currentCalendar];
    
    return [calendar component:NSCalendarUnitMinute fromDate:self];
}


- (NSInteger)second
{
    NSCalendar *calendar = [NSCalendar currentCalendar];
    
    return [calendar component:NSCalendarUnitSecond fromDate:self];
}

- (NSDateComponents *)yearMonthDay
{
    NSCalendar *calendar = [NSCalendar currentCalendar];
    
    NSCalendarUnit compUint = NSCalendarUnitYear | NSCalendarUnitMonth | NSCalendarUnitDay;
    
    return [calendar components:compUint fromDate:self];
    
}



- (NSDateComponents *)hourMinuteSecond
{
    NSCalendar *calendar = [NSCalendar currentCalendar];
    
    NSCalendarUnit compUint = NSCalendarUnitHour | NSCalendarUnitMinute | NSCalendarUnitSecond;
    
    return [calendar components:compUint fromDate:self];
    
}


- (NSDateComponents *)all
{
    NSCalendar *calendar = [NSCalendar currentCalendar];
    
    NSCalendarUnit compUint = NSCalendarUnitYear | NSCalendarUnitMonth | NSCalendarUnitDay |NSCalendarUnitHour | NSCalendarUnitMinute | NSCalendarUnitSecond;
    
    return [calendar components:compUint fromDate:self];

    
}


- (BOOL)isThisYear
{
    NSCalendar *curCalendar = [NSCalendar currentCalendar];
    
    NSInteger curYear = [curCalendar component:NSCalendarUnitYear fromDate:[NSDate date]];
    NSInteger selfYear = [curCalendar component:NSCalendarUnitYear fromDate:self];

    return curYear == selfYear;
}

- (BOOL)isYesterday
{
    NSDateFormatter *fmt = [[NSDateFormatter alloc] init];
    fmt.dateFormat = @"yyyy-MM-dd";
    
    NSString *curStr = [fmt stringFromDate:[NSDate date]];
    NSDate *curDate = [fmt dateFromString:curStr];
    
    NSString *selfStr = [fmt stringFromDate:self];
    NSDate *selfDate = [fmt dateFromString:selfStr];
    
    
    NSCalendar *calendar = [NSCalendar currentCalendar];
    
    NSDateComponents *comps = [calendar components:NSCalendarUnitYear | NSCalendarUnitMonth | NSCalendarUnitDay fromDate:selfDate toDate:curDate options:0];
    
    
    return  comps.year == 0 &&
            comps.month == 0 &&
            comps.day == 1;
}

- (BOOL)isToday
{
    
    NSDate *curDate = [NSDate date];
    
    NSDateComponents *curComps = [curDate yearMonthDay];
    NSDateComponents *selfComps = [self yearMonthDay];
    
    return curComps.year == selfComps.year &&
            curComps.month == selfComps.month &&
            curComps.day == selfComps.day ;
}

- (BOOL)isInOneHour
{
    
    
    NSCalendar *calendar = [NSCalendar currentCalendar];
    
    NSDate *curDate = [NSDate date];
    
    NSCalendarUnit compUint = NSCalendarUnitYear | NSCalendarUnitMonth | NSCalendarUnitDay |NSCalendarUnitHour | NSCalendarUnitMinute | NSCalendarUnitSecond;
    
    NSDateComponents *comps = [calendar components:compUint fromDate:self toDate:curDate options:0];
    
   
    return  comps.year == 0 &&
            comps.month == 0 &&
            comps.day == 0 &&
            comps.hour ==0;
}

- (BOOL)isINOneMinute
{
    NSCalendar *calendar = [NSCalendar currentCalendar];
    
    NSDate *curDate = [NSDate date];
    
    NSCalendarUnit compUint = NSCalendarUnitYear | NSCalendarUnitMonth | NSCalendarUnitDay |NSCalendarUnitHour | NSCalendarUnitMinute | NSCalendarUnitSecond;
    
    NSDateComponents *comps = [calendar components:compUint fromDate:self toDate:curDate options:0];
    
    
    return  comps.year == 0 &&
    comps.month == 0 &&
    comps.day == 0 &&
    comps.hour ==0 &&
    comps.minute == 0;
}


#pragma mark - 
- (BOOL)isTomorrow
{
    NSDateFormatter *fmt = [[NSDateFormatter alloc] init];
    fmt.dateFormat = @"yyyy-MM-dd";
    
    NSString *curStr = [fmt stringFromDate:[NSDate date]];
    NSDate *curDate = [fmt dateFromString:curStr];
    
    NSString *selfStr = [fmt stringFromDate:self];
    NSDate *selfDate = [fmt dateFromString:selfStr];
    
    
    NSCalendar *calendar = [NSCalendar currentCalendar];
    
    NSDateComponents *comps = [calendar components:NSCalendarUnitYear | NSCalendarUnitMonth | NSCalendarUnitDay fromDate:curDate toDate:selfDate options:0];
    
    
    return  comps.year == 0 &&
    comps.month == 0 &&
    comps.day == 1;
}

-(NSString *)compareDate:(NSDate *)date{
    
    NSTimeInterval secondsPerDay = 24 * 60 * 60;
    NSDate *today = [[NSDate alloc] init];
    NSDate *tomorrow, *yesterday;
    
    tomorrow = [today dateByAddingTimeInterval: secondsPerDay];
    yesterday = [today dateByAddingTimeInterval: -secondsPerDay];
    
    // 10 first characters of description is the calendar date:
    NSString * todayString = [[today description] substringToIndex:10];
    NSString * yesterdayString = [[yesterday description] substringToIndex:10];
    NSString * tomorrowString = [[tomorrow description] substringToIndex:10];
    
    NSString * dateString = [[date description] substringToIndex:10];
    
    if ([dateString isEqualToString:todayString])
    {
        return @"今天";
    } else if ([dateString isEqualToString:yesterdayString])
    {
        return @"昨天";
    }else if ([dateString isEqualToString:tomorrowString])
    {
        return @"明天";
    }
    else
    {
        return dateString;
    }
}
@end
