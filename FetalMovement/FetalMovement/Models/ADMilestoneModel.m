//
//  ADMilestone.m
//  FetalMovement
//
//  Created by wangpeng on 14-3-7.
//  Copyright (c) 2014年 wang peng. All rights reserved.
//

#import "ADMilestoneModel.h"

@implementation ADMilestoneModel


- (id)initWithDictionary:(NSDictionary *)dic
{
    self = [super init];
    if (self) {
        self.date = [dic objectForKey:kMilestoneDate];
        self.tag = [dic objectForKey:kMilestoneTag];
        self.gestationalWeeks = [[dic objectForKey:kMilestoneGestationalWeeks] intValue];
        self.medal = [[dic objectForKey:kMilestoneMedal] intValue];
        self.fetalcount = [[dic objectForKey:kMilestoneCount] intValue];
        self.isSection = [[dic objectForKey:kMilestoneIsSection] boolValue];

    }
    return self;

}
@end
