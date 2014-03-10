//
//  ADAppConfig.h
//  FetalMovement
//
//  Created by wangpeng on 14-3-2.
//  Copyright (c) 2014年 wang peng. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ADAppConfig : NSObject
#define kNavigationPopAnimationDuration 0.3f


//*根据日期获取当天典型的三次小时胎动记录 key值
#define kStartTimeStamp @"startTimeStamp"
#define kEndTimeStamp @"endTimeStamp"
#define kFetalCount @"fetalCount"

/**
 *  系统各种颜色 和字体大小
 */
#define kOrangeFontColor [UIColor colorWithRed:143/255.0 green:132/255.0 blue:123/255.0 alpha:1.0]
#define kMacroFontSize [UIFont systemFontOfSize:24/2]
#define kRedFontColor   [UIColor colorWithRed:255/255.0 green:49/255.0 blue:89/255.0 alpha:1.0]
#define kYellowColor   [UIColor colorWithRed:255/255.0 green:185/255.0 blue:2/255.0 alpha:1.0]
#define kXaxisColor    [UIColor colorWithRed:255/255.0 green:176/255.0 blue:170/255.0 alpha:1.0]
//自定义导航条颜色
#define kNavigationViewColor   [UIColor colorWithRed:255/255.0 green:83/255.0 blue:110/255.0 alpha:1.0]



/**
 *  里程碑 数据key
 */
#define kMilestoneDate @"milestoneDate"
#define kMilestoneGestationalWeeks @"milestoneGestationalWeeks"
#define kMilestoneMedal @"milestoneMedal"
#define kMilestoneTag @"milestoneTag"
#define kMilestoneCount @"milestoneCount"
#define kMilestoneIsSection @"milestoneIsSection"

/**
 *  存放用户基本信息的 userdefault key值
 */

#define kFirstRecordFetal @"firstRecordFetal"



@end
