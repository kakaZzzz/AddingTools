//
//  ADUIParamManager.h
//  FetalMovement
//
//  Created by wangpeng on 14-3-12.
//  Copyright (c) 2014年 wang peng. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "ADSingleton.h"//单例宏模板
@interface ADUIParamManager : NSObject
//Singleton define
DEFINE_SINGLETON_FOR_CLASS(ADUIParamManager)

- (int)getNavigationBarHeight;
@end
