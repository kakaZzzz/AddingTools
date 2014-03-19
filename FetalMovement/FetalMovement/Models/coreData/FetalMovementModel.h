//
//  FetalMovementModel.h
//  FetalMovement
//
//  Created by wangpeng on 14-3-3.
//  Copyright (c) 2014年 wang peng. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>


@interface FetalMovementModel : NSManagedObject

@property (nonatomic, retain) NSNumber * year;
@property (nonatomic, retain) NSNumber * month;
@property (nonatomic, retain) NSNumber * day;
@property (nonatomic, retain) NSNumber * hour;
@property (nonatomic, retain) NSNumber * minute;
@property (nonatomic, retain) NSNumber * seconds1970;

@end
