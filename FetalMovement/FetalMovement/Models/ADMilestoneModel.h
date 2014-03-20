//
//  ADMilestone.h
//  FetalMovement
//
//  Created by wangpeng on 14-3-7.
//  Copyright (c) 2014年 wang peng. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ADMilestoneModel : NSObject

    
@property(nonatomic,strong)NSString *date;
@property(nonatomic,strong)NSString *tag;
@property(nonatomic,assign)int gestationalWeeks;
@property(nonatomic,assign)int medal;
@property(nonatomic,assign)int fetalcount;
@property(nonatomic,assign)BOOL isSection ;

- (id)initWithDictionary:(NSDictionary *)dic;

@end
