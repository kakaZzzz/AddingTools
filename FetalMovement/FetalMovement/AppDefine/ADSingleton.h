//
//  ADSingleton.h
//  FetalMovement
//
//  Created by wangpeng on 14-3-3.
//  Copyright (c) 2014年 wang peng. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ADSingleton : NSObject

#define DEFINE_SINGLETON_FOR_CLASS(className)\
\
+ (className *)shared##className;

#define SYNTHESIZE_SINGLETON_FOR_CLASS(className)\
\
+ (className *)shared##className { \
    static className *shared##className = nil; \
    static dispatch_once_t onceToken; \
    dispatch_once(&onceToken, ^{ \
        shared##className = [[self alloc] init]; \
    }); \
    return shared##className; \
}
@end
