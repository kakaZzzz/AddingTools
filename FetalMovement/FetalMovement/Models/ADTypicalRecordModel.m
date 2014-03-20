//
//  ADTypicalRecordModel.m
//  FetalMovement
//
//  Created by wangpeng on 14-3-3.
//  Copyright (c) 2014年 wang peng. All rights reserved.
//

#import "ADTypicalRecordModel.h"

@implementation ADTypicalRecordModel

- (id)initWithDictionary:(NSDictionary *)dic order:(int)order
{
    self = [super init];
    if (self) {
        self.startTime = [dic objectForKey:kStartTimeStamp];
        self.endTime = [dic objectForKey:kEndTimeStamp];
        self.fetalcount = [[dic objectForKey:kFetalCount] intValue];
        self.order = order;
    }
    return self;
}
@end
