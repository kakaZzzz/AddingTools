//
//  ADSortModel.m
//  FetalMovement
//
//  Created by wangpeng on 14-3-6.
//  Copyright (c) 2014年 wang peng. All rights reserved.
//

#import "ADSortModel.h"

@implementation ADSortModel
+(ADSortModel *)modelWithCount:(int)count withStartTime:(NSString *)startTime withEndTime:(NSString *)endTime
{
    ADSortModel *sortModel = [[ADSortModel alloc] init];
    
    sortModel.count = count;
    
    sortModel.startTime = startTime;
    
    sortModel.endTime = endTime;
    
    return sortModel;

}
@end
