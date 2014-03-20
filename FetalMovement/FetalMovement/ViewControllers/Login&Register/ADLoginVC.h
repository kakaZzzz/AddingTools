//
//  ADLoginVC.h
//  FetalMovement
//
//  Created by wangpeng on 14-3-11.
//  Copyright (c) 2014年 wang peng. All rights reserved.
//

#import "ADBaseViewController.h"



@interface ADLoginVC : ADBaseViewController<UITextFieldDelegate,TencentSessionDelegate>

@property(nonatomic,strong)UITextField *telNumberField;
@property(nonatomic,strong)UITextField *pswordField;
@property(nonatomic,strong)UIView *contentView;


@end
