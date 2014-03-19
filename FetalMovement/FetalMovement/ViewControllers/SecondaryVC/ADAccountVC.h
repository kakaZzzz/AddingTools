//
//  ADAccountVC.h
//  FetalMovement
//
//  Created by wangpeng on 14-3-14.
//  Copyright (c) 2014年 wang peng. All rights reserved.
//

#import "ADBaseViewController.h"

@interface ADAccountVC : ADBaseViewController<UITableViewDelegate,
UITableViewDataSource,
TencentSessionDelegate>
@property(nonatomic,strong)NSArray *titleArray;//标题数组
@property(nonatomic,strong)NSArray *iconArray;//标题数组
@property(nonatomic,strong)NSArray *contentArray;//标题数组
@end
