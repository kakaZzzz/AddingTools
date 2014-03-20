//
//  ADBaseViewController.h
//  FetalMovement
//
//  Created by wangpeng on 14-3-2.
//  Copyright (c) 2014年 wang peng. All rights reserved.
//

#import <UIKit/UIKit.h>
#import"ADNavigationView.h"
@interface ADBaseViewController : UIViewController
//custome navigationView
@property(nonatomic,strong)ADNavigationView *navigationView;

//custome init
- (id)initWithNavigationViewWithTitle:(NSString *)title;
@end
