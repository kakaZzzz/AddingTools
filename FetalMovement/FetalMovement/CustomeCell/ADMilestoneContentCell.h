//
//  ADMilestoneContentCell.h
//  Milestone
//
//  Created by wangpeng on 14-3-7.
//  Copyright (c) 2014年 wang peng. All rights reserved.
//

#import <UIKit/UIKit.h>
@class ADMilestoneModel;
@interface ADMilestoneContentCell : UITableViewCell

@property(nonatomic,strong)UILabel *dateLabel;//日期
@property(nonatomic,strong)UIImageView *scaleImageView;//刻度背景
@property(nonatomic,strong)UIImageView *medalImageView;//奖牌背景
@property(nonatomic,strong)UIImageView *countImageView;//胎动次数背景
@property(nonatomic,strong)UILabel *countLabel;//胎动次数Label
@property(nonatomic,strong)UIImageView *yellowLineImageView;//小黄线
@property(nonatomic,strong)UIImageView *markImageView;//mark Image
@property(nonatomic,strong)UILabel *markLabel;//mark Label
@property(nonatomic,strong)ADMilestoneModel *model;
@end
