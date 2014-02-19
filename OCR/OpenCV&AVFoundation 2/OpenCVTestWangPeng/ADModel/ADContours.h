//
//  ADContours.h
//  OpenCVTestWangPeng
//
//  Created by wangpeng on 14-2-18.
//  Copyright (c) 2014年 wangpeng. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ADContours : NSObject
//property
@property(nonatomic,assign)float point_x;
@property(nonatomic,assign)float point_y;

//method
- (id)initWithPointX:(float)x pointY:(float)y;
@end
