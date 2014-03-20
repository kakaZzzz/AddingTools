//
//  NSDate+DateHelper.h
//  FetalMovement
//
//  Created by wangpeng on 14-3-3.
//  Copyright (c) 2014年 wang peng. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSDate (DateHelper)
//获取当前日期
+ (NSDate *)localdate;
//根据0时区的日期转化成当前日期(参数date是0时区日期)
+ (NSDate *)localdateByDate:(NSDate *)dateGMT;
//获取今天是星期几
-(NSInteger)dayOfWeek;
//获取每月有多少天
- (NSInteger)monthOfDay;
//根据年份和月份 得出本月份的天数
+ (NSInteger)dayOfMonthWithYear:(int)y Month:(int)m;
//本周开始时间
-(NSDate*)beginningOfWeek;
//本周结束时间
-(NSDate*)endOfWeek;
//日期添加几天
-(NSDate*)addDay:(NSInteger)day;

//日期格式化
-(NSString*)stringWithFormat:(NSString*)format;
//字符串转换成时间(直接转换成当前日期时间)
+(NSDate*)localDateFromString:(NSString *)string withFormat:(NSString*)format;
//时间转换成字符串（会在原日期基础上加8个小时）
+(NSString*)stringFromDate:(NSDate*)dateGMT withFormat:(NSString*)string;
+ (BOOL)isAscendingWithOnedate:(NSDate *)onedate anotherdate:(NSDate *)anotherdate;


//从一个日期中分割出年、月、日、小时、分钟
+(NSNumber*)getYear:(NSDate*)date;
+(NSNumber*)getMonth:(NSDate*)date;
+(NSNumber*)getDay:(NSDate*)date;
+(NSNumber*)getHour:(NSDate*)date;
+(NSNumber*)getMinutes:(NSDate*)date;
@end
