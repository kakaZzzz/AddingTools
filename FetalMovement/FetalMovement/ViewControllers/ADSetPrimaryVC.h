//
//  ADSetPrimaryVC.h
//  FetalMovement
//
//  Created by wangpeng on 14-3-2.
//  Copyright (c) 2014年 wang peng. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ADBannerView.h"
@interface ADSetPrimaryVC : ADBaseViewController<UITableViewDataSource,
UITableViewDelegate,
ADBannerDelegate>
@property(nonatomic,strong)NSArray *titleArray;//标题数组
@property(nonatomic,strong)NSArray *iconArray;//标题数组
@property(nonatomic,strong)NSArray *contentArray;//标题数组

@end
