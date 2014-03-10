//
//  ADMilestoneVC.h
//  FetalMovement
//
//  Created by wangpeng on 14-3-7.
//  Copyright (c) 2014年 wang peng. All rights reserved.
//

#import "ADBaseViewController.h"

@interface ADMilestoneVC : ADBaseViewController<UITableViewDelegate,
UITableViewDataSource>
@property(nonatomic,strong) UITableView *tableView;


@end
