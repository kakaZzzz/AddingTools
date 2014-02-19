//
//  ADContours.m
//  OpenCVTestWangPeng
//
//  Created by wangpeng on 14-2-18.
//  Copyright (c) 2014年 wangpeng. All rights reserved.
//

#import "ADContours.h"

@implementation ADContours

- (id)initWithPointX:(float)x pointY:(float)y
{
    self = [super init];
    if (self) {
        self.point_x = x;
        self.point_y = y;
    }
    return self;
}

@end
