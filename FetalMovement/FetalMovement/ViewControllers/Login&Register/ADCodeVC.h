//
//  ADCodeVC.h
//  FetalMovement
//
//  Created by wangpeng on 14-3-18.
//  Copyright (c) 2014年 wang peng. All rights reserved.
//

#import "ADBaseViewController.h"

@interface ADCodeVC : ADBaseViewController<UITextFieldDelegate>
{
    NSInteger acounrNumber;
    NSTimer *similarTimer;
}
@property(nonatomic,strong)NSString *phoneNumber;
@property(nonatomic,strong)NSString *password;
@end
