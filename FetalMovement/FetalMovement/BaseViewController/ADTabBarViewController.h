//
//  ADTabBarViewController.h
//  FetalMovement
//
//  Created by wangpeng on 14-3-2.
//  Copyright (c) 2014年 wang peng. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ADTabBarView.h"
@interface ADTabBarViewController : UITabBarController<ADTabBarViewDelegate,UITabBarControllerDelegate>

@property(nonatomic,strong)ADTabBarView *customTabBar;

@end
