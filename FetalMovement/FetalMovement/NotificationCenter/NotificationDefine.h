//
//  NotificationDefine.h
//  FetalMovement
//
//  Created by wangpeng on 14-3-5.
//  Copyright (c) 2014年 wang peng. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NotificationDefine : NSObject
#define StartRecordFetalMovementNotification @"startRecordFetalMovementNotification"
#define EndRecordFetalMovementNotification @"endRecordFetalMovementNotification"

//登录各种通知

#define OAthoBySinaSuccessfulNotification @"oAthoBySinaSuccessfulNotification"//也就是成功拿到token而已
#define LoginBySinaSuccessfulNotification @"loginBySinaSuccessfulNotification"//
#define ShareBySinaSuccessfulNotification @"shareBySinaSuccessfulNotification"//
#define SettingBySinaSuccessfulNotification @"settingBySinaSuccessfulNotification"//


#define OAthoBySinaFailureNotification @"oAthoBySinaFailureNotification"//也就是成功拿到token而已
#define LoginBySinaFailureNotification @"loginBySinaFailureNotification"//
#define ShareBySinaFailureNotification @"shareBySinaFailureNotification"//
#define SettingBySinaFailureNotification @"settingBySinaFailureNotification"//


@end
