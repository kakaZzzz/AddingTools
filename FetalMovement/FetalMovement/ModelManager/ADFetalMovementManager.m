//
//  ADFetalMovementManager.m
//  FetalMovement
//
//  Created by poppy on 14-3-1.
//  Copyright (c) 2014年 wang peng. All rights reserved.
//

#import "ADFetalMovementManager.h"
#import "ADAppDelegate.h"
#import "FetalMovementModel.h"
#import "NSDate+DateHelper.h"
#import "ADSortModel.h"

#define ONEDAY_SECONDS 24*60*60
@interface ADFetalMovementManager ()
{
    NSArray *typitalArray;
}
@end

@implementation ADFetalMovementManager

//singleton synthesize

SYNTHESIZE_SINGLETON_FOR_CLASS(ADFetalMovementManager)


/**
 *根据日期获取每小时的胎动次数统计，用于曲线展示
 @return {'0':(NSString *), '1':(NSString *), ... , '23':(NSString *)}
 */

- (NSArray *)getHourlyStatDataByDate:(double) timestamp
{
    
    NSDate *date = [NSDate dateWithTimeIntervalSince1970:timestamp];
    NSNumber *year = [NSDate getYear:date];
    NSNumber *month = [NSDate getMonth:date];
    NSNumber *day = [NSDate getDay:date];
    
    NSMutableArray *resultArray = [NSMutableArray arrayWithCapacity:1];
    for (int i = 0; i < 24; i++) {
        //设置查询条件
        NSPredicate *predicate = [NSPredicate predicateWithFormat:@"year == %@ AND month == %@ AND day = %@ AND hour = %@",year, month, day,[NSNumber numberWithInt:i]];
        NSArray *dataArray = [self getDatasFromCoreDataWithPredicate:predicate entityName:@"FetalMovementModel" sortMainKey:nil sortViceKey:nil];
        //[resultArray addObject:[NSString stringWithFormat:@"%d",[dataArray count]]];
        [resultArray addObject:[NSString stringWithFormat:@"%d",(arc4random() % 12)]];
        
    }
    
    return resultArray;
}

/**
 *根据日期获取当天胎动总次数
 */
- (int)getTotalCountByDate:(double) timestamp
{
    NSDate *date = [NSDate dateWithTimeIntervalSince1970:timestamp];
    NSNumber *year = [NSDate getYear:date];
    NSNumber *month = [NSDate getMonth:date];
    NSNumber *day = [NSDate getDay:date];
    
    NSLog(@"哈哈哈  %@    %@   %@",year,month,day);
    //设置查询条件
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"year == %@ AND month == %@ AND day = %@",year, month, day];
    NSArray *dataArray = [self getDatasFromCoreDataWithPredicate:predicate entityName:@"FetalMovementModel" sortMainKey:nil sortViceKey:nil];
//    for (int i = 0; i < [dataArray count]; i++) {
//        NSLog(@"每条数据的内容%@",[dataArray objectAtIndex:i]);
//        
//    }
    
    NSLog(@"++++++++%d",[dataArray count]);
    return (int)[dataArray count];
    
    //return 25;
}

/**
 *根据日期获取当天预测全天胎动总次数
 */
- (int)getPredictDailyCountByDate:(double) timestamp
{
    int average = [self getPredictHourlyCountByDate:timestamp];
    
    return average * 12;
    //return 5;
}

/**
 *根据日期获取当天预测小时胎动次数
 */
- (int)getPredictHourlyCountByDate:(double) timestamp/////////////////大坑，同时访问一个contex,一个表，出错，耗时，应该是必须的吧
{
    NSArray *array = [self getTypicalRecordByDate:timestamp];
    int arrayCount = (int)[array count];
    int count = 0;
    for (int i = 0; i < arrayCount; i ++) {
        NSDictionary *dic = [array objectAtIndex:i];
        count = count + [[dic objectForKey:kFetalCount] intValue];
    }
    NSLog(@"典型记录胎动次数是%d",count);
    
    int average =  round(count/(float)arrayCount);
    NSLog(@"典型记录胎动次数是%d",average);
    return average;
    //  return 60;
}

/**
 *根据日期获取当天典型的三次小时胎动记录
 *@return [{'startTimeStamp':(NSString *), 'endTimeStamp':(NSString *), 'count':(NSString *)}]
 */
- (NSArray *)getTypicalRecordByDate:(double) timestamp
{
    //    NSDictionary *dic1 = [[NSDictionary alloc] initWithObjectsAndKeys:@"03:00",kStartTimeStamp, @"04:00",kEndTimeStamp,@"5",kFetalCount,nil];
    //    NSDictionary *dic2 = [[NSDictionary alloc] initWithObjectsAndKeys:@"06:00",kStartTimeStamp, @"07:00",kEndTimeStamp,@"8",kFetalCount, nil];
    //    NSDictionary *dic3 = [[NSDictionary alloc] initWithObjectsAndKeys:@"10:00",kStartTimeStamp, @"11:00",kEndTimeStamp,@"12",kFetalCount, nil];
    //
    //    return @[dic1,dic2,dic3];
    
    
    //先取出数据，并按小时和分钟排序 升序
    
    NSDate *localDate = [NSDate dateWithTimeIntervalSince1970:timestamp];
    NSNumber *year = [NSDate getYear:localDate];
    NSNumber *month = [NSDate getMonth:localDate];
    NSNumber *day = [NSDate getDay:localDate];
    
    
    
    
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"year == %@ AND month == %@ AND day = %@ ",year, month, day];
    //    NSDictionary *sortDictionary = [NSDictionary dictionaryWithObjectsAndKeys:@"hour",@"sortHour",@"minute",@"srotMinute", nil];
    NSArray *srcArray = [self getDatasFromCoreDataWithPredicate:predicate entityName:@"FetalMovementModel" sortMainKey:@"hour" sortViceKey:@"minute"];
    
    
    //遍历数组元素
    int count = (int)[srcArray count];
    NSMutableArray * transferArray= [NSMutableArray arrayWithCapacity:1];//存放所有一小时间隔的数据
    int i,j;
    for (i = 0; i < count; i ++) {
        
        int fetalCount = 1;
        
        FetalMovementModel *model = [srcArray objectAtIndex:i];
        
        for (j =i + 1; j < count; j ++) {
            
            FetalMovementModel *secondModel = [srcArray objectAtIndex:j];
            if ([secondModel.seconds1970 doubleValue] - [model.seconds1970 doubleValue] <= 3600) {
                fetalCount = fetalCount + 1;
                continue;
            }else{
                break;
            }
            
        }
        NSLog(@"跳出循环之后j是%d",j);
        i = j -1;
        //将时间转化成 00:00的格式
        NSDate *startDate = [NSDate dateWithTimeIntervalSince1970:[model.seconds1970 doubleValue]];
        NSLog(@"------起始时期%@",startDate);
        NSLog(@"胎动次数是%d",fetalCount);
        
        NSDate *endDate = [NSDate dateWithTimeIntervalSince1970:([model.seconds1970 doubleValue]+ 3600)];
        NSString *startTime = [startDate stringWithFormat:@"HH:mm"];
        NSLog(@"++++++起始时期%@",startTime);
        NSString *endTime = [endDate stringWithFormat:@"HH:mm"];
        
        ADSortModel *sortModel = [ADSortModel modelWithCount:fetalCount withStartTime:startTime withEndTime:endTime];
        [transferArray addObject:sortModel];
        
    }
    
    //然后再对tansferArray 数组进行排序，按照胎动次数高低排序
    
    NSSortDescriptor *countDesc = [NSSortDescriptor sortDescriptorWithKey:@"count" ascending:NO];
    NSSortDescriptor *countStartTime = [NSSortDescriptor sortDescriptorWithKey:@"startTime" ascending:YES];
    NSArray *descriptorArray = [NSArray arrayWithObjects:countDesc, countStartTime,nil];
    NSArray *sortedArray = [transferArray sortedArrayUsingDescriptors: descriptorArray];
    //sortedArray是排序之后的数组
    //然后取出最多的三个时间段
    NSMutableArray *resultArray = [NSMutableArray arrayWithCapacity:1];
    NSUInteger margin =([sortedArray count]<3)?[sortedArray count]:3;
    for (int i =0; i < margin; i++) {
        ADSortModel *model = [sortedArray objectAtIndex:i];
        NSString *countStr = [NSString stringWithFormat:@"%d",model.count];
        NSDictionary *dic = [[NSDictionary alloc]initWithObjectsAndKeys:model.startTime,kStartTimeStamp, model.endTime,kEndTimeStamp,countStr,kFetalCount,nil];
        [resultArray addObject:dic];
    }
    
    
    return resultArray;
    
}

/**
 *记录胎动
 *@param data 时间戳的数组 [(NSDate *), (NSDate *), ... , (NSDate *)]
 *@throw NSException 保存出现问题抛出异常，上层Controller处理异常
 */
- (void)appendData:(NSArray *)datas
{
    
    NSManagedObjectContext *context =[self getAppContex];
    
    int count = (int)[datas count];
    for (int i = 0; i < count; i++) {
        NSDate *date = [datas objectAtIndex:i];
        
        NSNumber *year = [NSDate getYear:date];
        NSNumber *month = [NSDate getMonth:date];
        NSNumber *day = [NSDate getDay:date];
        NSNumber *hour = [NSDate getHour:date];
        NSNumber *minute = [NSDate getMinutes:date];
        NSNumber *seconds = [NSNumber numberWithDouble:[date timeIntervalSince1970]];
        //设置查询条件
        NSPredicate *predicate = [NSPredicate predicateWithFormat:@"year == %@ AND month == %@ AND day = %@ AND hour == %@ AND minute == %@",year, month, day, hour, minute];
        NSError *error;
        NSArray *dataArray = [self getDatasFromCoreDataWithPredicate:predicate entityName:@"FetalMovementModel" sortMainKey:nil sortViceKey:nil];
        
        if (dataArray.count == 1) {
            //已经有条目了
            return;
            
        }else if(dataArray.count == 0){
            
            //木有啊,就新建一条  进行coredata的插入数据操作
            FetalMovementModel *new = [NSEntityDescription insertNewObjectForEntityForName:@"FetalMovementModel" inManagedObjectContext:context];
            new.year = year;
            new.month = month;
            new.day = day;
            new.hour = hour;
            new.minute = minute;
            new.seconds1970 = seconds;
            
        }
        [context save:&error];
        // 及时保存
        if(![context save:&error]){
            NSLog(@"%@", [error localizedDescription]);
        }
        
    }
}


#pragma mark - private methods
- (NSArray *)getDatasFromCoreDataWithPredicate:(NSPredicate *)predicate entityName:(NSString *)entityName sortMainKey:(NSString *)mainKey sortViceKey:(NSString *)viceKey
{
    
    NSManagedObjectContext *context =[self getAppContex];
    NSEntityDescription *entity = [NSEntityDescription entityForName:entityName inManagedObjectContext:context];
    NSFetchRequest* request = [[NSFetchRequest alloc] init];
    [request setEntity:entity];
    
    //predicate
    if (predicate) {
        [request setPredicate:predicate];
        
    }
    
    //sortDescriptors
    if (mainKey) {
        NSLog(@"排序条件是%@ ",mainKey);
        NSMutableArray *sortDescriptors = [NSMutableArray arrayWithCapacity:1];
        [sortDescriptors addObject:[[NSSortDescriptor alloc] initWithKey:mainKey ascending:YES] ];
        if (viceKey) {
            [sortDescriptors addObject:[[NSSortDescriptor alloc] initWithKey:viceKey ascending:YES] ];
        }
        
        [request setSortDescriptors:sortDescriptors];
    }
    
    NSError* error;
    NSArray* resultArray = [context executeFetchRequest:request error:&error];
    return resultArray;
}

- (NSManagedObjectContext *)getAppContex
{
    NSManagedObjectContext *context =[(ADAppDelegate *) [UIApplication sharedApplication].delegate managedObjectContext];
    return context;
}

/**
 *  按格式排列 24小时
 *
 *  @return @["00:00,01:00......."]
 */
- (NSArray *)getTwentyfourHours
{
    NSMutableArray *resultArray = [NSMutableArray arrayWithCapacity:1];
    for (int i = 0; i <= 24; i++) {
        NSString *str = [NSString stringWithFormat:@"%d%d:%d%d",0,i,0,0];
        NSRange range = NSMakeRange (str.length - 5, 5);
        NSString *subStr = [str substringWithRange:range];
        [resultArray addObject:subStr];
    }
    return resultArray;
}
/**
 *  返回时间段之间的胎动数据
 *
 *  @param startTimestamp 开始日期(需要是当天00点00分得秒数)
 *  @param endTimestamp   结束日期
 *
 *  @return [{'date':(NSString *), 'count':(NSString *), 'gestationalWeeks':(NSString *),'medal':(NSString *),'tag':(NSString *),'isSection':(NSString *)}]
 */
- (NSArray *)getMilestonsDataWithStartDate:(double)startTimestamp endDate:(double)endTimestamp
{
    
    NSMutableArray *resultArray = [NSMutableArray arrayWithCapacity:1];
    
    int totalCount,gestationalWeeks,medal;
    int stepNumber = 0;
    NSString *tagString;
    double i = startTimestamp;
    
    static int threeMetal = 0;
    static int fourteenMetal = 0;
    
    while (i <= endTimestamp) {
        //totalCount = [self getTotalCountByDate:i];
        totalCount = arc4random()%70;
        gestationalWeeks = 0;//孕周根据日期进行计算出来
        
        //根据胎动次数，判断勋章类型
        if (totalCount != 0) {
            stepNumber = stepNumber + 1;
        }else{
            stepNumber = 0;
        }
        
        if (stepNumber == 0) {
            medal = 0;
        }
        else if (stepNumber == 3 && !threeMetal)
        {
            medal = 3;
            stepNumber = 0;
            threeMetal = 1;
            
        }
        else if (stepNumber == 14 && !fourteenMetal)
        {
            medal = 14;
            stepNumber = 0;
            fourteenMetal = 1;
          
        }
        
        NSLog(@"这个数字是%d",stepNumber);
        //第一次记录怎么判断？？？？？方案一：在userdefault里面存一条数据，用来记录第一次记录的时间
        if (i == [[[NSUserDefaults standardUserDefaults] objectForKey:kFirstRecordFetal] doubleValue]) {
      
            tagString = @"第一次记录";
        }else{
            if (totalCount > 60) {
                tagString = @"最活跃宝宝";
            }else{
                tagString = nil;
                
            }

        }
        
        
        //如果这一天居然是 一个月的第一天的话，那在他前面再插一条数据（空数据）
        NSDate *date = [NSDate dateWithTimeIntervalSince1970:i];
        NSNumber *day = [NSDate getDay:date];
        
        if (([day intValue] == 1) || (i == [[[NSUserDefaults standardUserDefaults] objectForKey:kFirstRecordFetal] doubleValue])) {
            NSDictionary *dic = [NSDictionary dictionaryWithObjectsAndKeys:[NSString stringWithFormat:@"%f",i],kMilestoneDate,@"",kMilestoneCount,@"",kMilestoneGestationalWeeks,@"",kMilestoneMedal,tagString,kMilestoneTag, [NSString stringWithFormat:@"%d",1],kMilestoneIsSection, nil];
            [resultArray addObject:dic];

        }
        NSDictionary *dic = [NSDictionary dictionaryWithObjectsAndKeys:[NSString stringWithFormat:@"%f",i],kMilestoneDate,[NSString stringWithFormat:@"%d",totalCount],kMilestoneCount,[NSString stringWithFormat:@"%d",gestationalWeeks],kMilestoneGestationalWeeks,[NSString stringWithFormat:@"%d",medal],kMilestoneMedal,tagString,kMilestoneTag, [NSString stringWithFormat:@"%d",0],kMilestoneIsSection, nil];
        [resultArray addObject:dic];
        
        i += ONEDAY_SECONDS;
        medal = 0;//一次循环之后，将medal置为0
    }
    
    NSLog(@"=========%@",resultArray);
    return  resultArray;
}


@end
