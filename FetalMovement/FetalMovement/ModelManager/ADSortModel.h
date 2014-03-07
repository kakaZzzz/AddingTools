//
//  ADSortModel.h
//  FetalMovement
//
//  Created by wangpeng on 14-3-6.
//  Copyright (c) 2014年 wang peng. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ADSortModel : NSObject
@property(nonatomic,strong)NSString *startTime;
@property(nonatomic,strong)NSString *endTime;
@property(nonatomic,assign)int count;

+(ADSortModel *)modelWithCount:(int)count withStartTime:(NSString *)startTime withEndTime:(NSString *)endTime;
@end
