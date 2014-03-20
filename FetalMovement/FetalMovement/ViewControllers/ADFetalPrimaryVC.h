//
//  ADFetalPrimaryVC.h
//  FetalMovement
//
//  Created by wangpeng on 14-3-2.
//  Copyright (c) 2014年 wang peng. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ADLineGraphView.h"
@interface ADFetalPrimaryVC : ADBaseViewController <ADLineGraphDelegate,
UITableViewDelegate,
UITableViewDataSource>

@property (nonatomic,strong) ADLineGraphView *lineGraph;
@property (nonatomic,strong) UIScrollView *graphBackgroundScrollView;

@property (nonatomic,strong) UIScrollView *fetalMovementScrollView;
@property (nonatomic,strong) UITableView *tableView;
@end
