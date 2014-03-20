//
//  ADMilestoneSectionCell.h
//  Milestone
//
//  Created by wangpeng on 14-3-7.
//  Copyright (c) 2014年 wang peng. All rights reserved.
//

#import <UIKit/UIKit.h>
@class ADMilestoneModel;
@interface ADMilestoneSectionCell : UITableViewCell
@property(nonatomic,strong)UILabel *dateLabel;//日期
@property(nonatomic,strong)UIImageView *scaleImageView;//刻度背景
@property(nonatomic,strong)ADMilestoneModel *model;
@end
