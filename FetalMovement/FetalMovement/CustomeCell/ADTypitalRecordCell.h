//
//  ADTypitalRecordCell.h
//  FetalMovement
//
//  Created by wangpeng on 14-3-4.
//  Copyright (c) 2014年 wang peng. All rights reserved.
//

#import <UIKit/UIKit.h>
@class ADTypicalRecordModel;
@interface ADTypitalRecordCell : UITableViewCell

@property(nonatomic,strong)UILabel *orderLabel;//序列号
@property(nonatomic,strong)UILabel *timeLabel;//起始时间
@property(nonatomic,strong)UILabel *countLabel;//胎动次数
@property(nonatomic,strong)ADTypicalRecordModel *recordModel;//数据model
@end
