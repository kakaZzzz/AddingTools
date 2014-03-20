//
//  ADUIParamManager.m
//  FetalMovement
//
//  Created by wangpeng on 14-3-12.
//  Copyright (c) 2014年 wang peng. All rights reserved.
//

#import "ADUIParamManager.h"

@implementation ADUIParamManager
//singleton synthesize

SYNTHESIZE_SINGLETON_FOR_CLASS(ADUIParamManager)

- (int)getNavigationBarHeight
{
    
    if (IOS7_OR_LATER) {
        return 65;
    }else{
        return 45;
    }
}
@end
