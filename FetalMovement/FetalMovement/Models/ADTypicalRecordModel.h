//
//  ADTypicalRecordModel.h
//  FetalMovement
//
//  Created by wangpeng on 14-3-3.
//  Copyright (c) 2014年 wang peng. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ADTypicalRecordModel : NSObject
@property(nonatomic,strong)NSString *startTime;
@property(nonatomic,strong)NSString *endTime;
@property(nonatomic,assign)int fetalcount;
@property(nonatomic,assign)int order;
- (id)initWithDictionary:(NSDictionary *)dic order:(int)order;
@end
