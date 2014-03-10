//
//  FetalMovementManager.h
//  FetalMovement
//
//  Created by poppy on 14-3-1.
//  Copyright (c) 2014年 wang peng. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "ADSingleton.h"//单例宏模板
#import "FetalMovementModel.h"
@interface ADFetalMovementManager : NSObject

//Singleton define
DEFINE_SINGLETON_FOR_CLASS(ADFetalMovementManager)

/**
 *根据日期获取每小时的胎动次数统计，用于曲线展示
 @return [NSString,NSString...],表示数值
 */
- (NSArray *)getHourlyStatDataByDate:(double) timestamp;

/**
 *根据日期获取当天胎动总次数
 */
- (int)getTotalCountByDate:(double) timestamp;

/**
 *根据日期获取当天预测全天胎动总次数
 */
- (int)getPredictDailyCountByDate:(double) timestamp;

/**
 *根据日期获取当天预测小时胎动次数
 */
- (int)getPredictHourlyCountByDate:(double) timestamp;

/**
 *根据日期获取当天典型的三次小时胎动记录
 *@return [{'startTimeStamp':(NSString *), 'endTimeStamp':(NSString *), 'count':(NSString *)}]
 */
- (NSArray *)getTypicalRecordByDate:(double) timestamp;

/**
 *记录胎动
 *@param data 时间戳的数组 [(NSString *), (NSString *), ... , (NSString *)]
 *@throw NSException 保存出现问题抛出异常，上层Controller处理异常
 */
- (void)appendData:(NSArray *) datas;


/**
 *  按格式排列 24小时
 *
 *  @return @["00:00,01:00......."]
 */
- (NSArray *)getTwentyfourHours;
@end
