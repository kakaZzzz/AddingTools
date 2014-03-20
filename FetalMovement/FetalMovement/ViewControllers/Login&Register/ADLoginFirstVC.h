//
//  ADLoginFirstVC.h
//  FetalMovement
//
//  Created by wangpeng on 14-3-19.
//  Copyright (c) 2014年 wang peng. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ADLoginFirstVC : UIViewController<UITextFieldDelegate,TencentSessionDelegate>
@property(nonatomic,strong)UITextField *telNumberField;
@property(nonatomic,strong)UITextField *pswordField;
@property(nonatomic,strong)UIView *contentView;

@end
