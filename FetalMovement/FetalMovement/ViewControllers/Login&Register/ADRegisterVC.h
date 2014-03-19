//
//  ADRegisterVC.h
//  Register&&login
//
//  Created by wangpeng on 14-3-11.
//  Copyright (c) 2014年 wang peng. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ADRegisterVC : ADBaseViewController<UITextFieldDelegate>
{
    NSInteger acounrNumber;
    NSTimer *similarTimer;
}
@property(nonatomic,strong)UITextField *telNumberField;//电话或者邮箱
@property(nonatomic,strong)UITextField *pswordField;//密码
@property(nonatomic,strong)UITextField *nickNameField;//昵称
@property(nonatomic,strong)UITextField *codeField;//验证码
@end
