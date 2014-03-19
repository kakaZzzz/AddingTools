//
//  ADCodeVC.m
//  FetalMovement
//
//  Created by wangpeng on 14-3-18.
//  Copyright (c) 2014年 wang peng. All rights reserved.
//

#import "ADCodeVC.h"
#import "ADAccountVC.h"
#import "ADSetPrimaryVC.h"

#import "ADAppDelegate.h"
#import "ADTabBarViewController.h"
#define acount_Number     (60)
@interface ADCodeVC ()
@property(nonatomic,strong)UITextField *codeNumberField;
@property(nonatomic,strong)UILabel *oneLabel;
@property(nonatomic,strong)UILabel *twoLabel;
@property(nonatomic,strong)UILabel *threeLabel;
@property(nonatomic,strong)UILabel *fourthLabel;
@property(nonatomic,strong) UIButton *btnEnter;
@property(nonatomic,strong) UIButton *refreshSendCodeButton;
@property(nonatomic,strong) NSString *codeid;
@end

@implementation ADCodeVC

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
        
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(getTextFieldText:) name:UITextFieldTextDidChangeNotification object:nil];
        
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    [self configureNavigationView];
    [self createSubviews];
    
    
    
    acounrNumber = acount_Number;
    similarTimer = [NSTimer scheduledTimerWithTimeInterval:1.0f target:self selector:@selector(countSecond) userInfo:nil repeats:100];
    

   //发送请求验证码
    NSString *string = @"%2b86";
    [[ADAccountCenter sharedADAccountCenter] getCodeWhenRegisterWithPhone:[string stringByAppendingString:_phoneNumber] withTarget:self success:@selector(getCodeSuccessful:) failure:nil];
    // Do any additional setup after loading the view.
}
- (void)configureNavigationView
{
    self.navigationView.backgroundColor = [UIColor whiteColor];
    self.navigationView.titleLabel.textColor = kOrangeFontColor;
    
    [self.navigationView.backButton setBackgroundImage:[UIImage imageNamed:@"navigation_backbutton_bg@2x"] forState:UIControlStateNormal];
    //    [self.navigationView.backButton setBackgroundImage:[UIImage imageNamed:@"historydata_button_selected@2x"] forState:UIControlStateHighlighted];
    //    [self.navigationView.backButton setBackgroundImage:[UIImage imageNamed:@"historydata_button_selected@2x"] forState:UIControlStateSelected];
}
#pragma mark - navigation button event
- (void)clickLeftButton
{
    
    [self.navigationController popViewControllerAnimated:YES];
    
}
- (void)createSubviews
{
    int yOffset = [[ADUIParamManager sharedADUIParamManager] getNavigationBarHeight] +  24/2;

    
    self.refreshSendCodeButton = [UIButton buttonWithType:UIButtonTypeCustom];
    _refreshSendCodeButton.frame = CGRectMake(320-250/2, yOffset, 250/2, 100/2);
    [_refreshSendCodeButton setBackgroundImage:[UIImage imageNamed:@"code_resend_bg@2x"] forState:UIControlStateNormal];
    [_refreshSendCodeButton setBackgroundImage:[UIImage imageNamed:@"code_resend_hilightbg@2x"] forState:UIControlStateHighlighted];
    acounrNumber = acount_Number;
    [_refreshSendCodeButton setTitle:[NSString stringWithFormat:@"重新发送(%d)",acounrNumber-1] forState:UIControlStateNormal];
    [_refreshSendCodeButton addTarget:self action:@selector(reGetMessage:) forControlEvents:UIControlEventTouchUpInside];
    _refreshSendCodeButton.userInteractionEnabled = NO;
    [self.view addSubview:_refreshSendCodeButton];
    
    UILabel *aLabel = [[UILabel alloc] initWithFrame:CGRectMake(48/2, yOffset + 5, 170, 20)];
    aLabel.backgroundColor = [UIColor clearColor];
    aLabel.textColor = [UIColor colorWithRed:255/255.0 green:118/255.0 blue:133/255.0 alpha:1.0];
    aLabel.font = kTitleFont;
    aLabel.text = @"请输入手机验证码";
    [self.view addSubview:aLabel];
    
    CGRect rect = aLabel.frame;
    rect.origin.y += rect.size.height;
    UILabel *bLabel = [[UILabel alloc] initWithFrame:rect];
    bLabel.backgroundColor = [UIColor clearColor];
    bLabel.textColor = kTitleFontColor;
    bLabel.font = [UIFont systemFontOfSize:28/2];
    bLabel.text = @"验证码已发送至你的手机";
    [self.view addSubview:bLabel];

    rect.origin.y += rect.size.height + 60/2;
    
    self.codeNumberField         = [[UITextField alloc] init];
    _codeNumberField.backgroundColor      = [UIColor clearColor];
    _codeNumberField.keyboardType         = UIKeyboardTypePhonePad;
    _codeNumberField.borderStyle          = UITextBorderStyleNone;
    _codeNumberField.clipsToBounds        = YES;
    _codeNumberField.autocapitalizationType = UITextAutocapitalizationTypeNone;
    _codeNumberField.autocorrectionType   = UITextAutocorrectionTypeNo;
    _codeNumberField.placeholder          = @" 手机号码";
    _codeNumberField.font                 = [UIFont systemFontOfSize:40/2];
    _codeNumberField.frame                = rect;
    _codeNumberField.delegate             = self;
    [_codeNumberField becomeFirstResponder];
    [self.view addSubview:_codeNumberField];

    UIView *aView = [[UIView alloc] initWithFrame:CGRectMake(_codeNumberField.frame.origin.x, _codeNumberField.frame.origin.y, 320, _codeNumberField.frame.size.height)];
    aView.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:aView];
    
    
    rect.size.width = 55;
    rect.size.height = 55;
    //四个圆圈
    
    
    for (int i =0; i < 4; i ++) {
        rect.origin.x =48/2 + 55*i+ i*12;
        UIImageView *aImageview = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"code_circle_hilightbg@2x"]];
        aImageview.frame = rect;
        [self.view addSubview:aImageview];
        
        UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 55, 55)];
        label.textAlignment = NSTextAlignmentCenter;
        label.backgroundColor = [UIColor clearColor];
        label.font = [UIFont systemFontOfSize:40];
        label.tag = 100+i;
        [aImageview addSubview:label];
    }
   
    
    rect.origin.y +=(rect.size.height + 60/2);
    rect = rect;
    rect.origin.x = (320 - 260/2)/2;
    rect.size.width = 260/2;
    rect.size.height= 110/2;

    self.btnEnter        = [UIButton buttonWithType:UIButtonTypeCustom];
    _btnEnter.frame  = rect;
    
    [_btnEnter.titleLabel setFont:[UIFont systemFontOfSize:18]];
    [_btnEnter setTitle:@"确定" forState:UIControlStateNormal];
    [_btnEnter setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [_btnEnter setBackgroundImage:[UIImage imageNamed:@"register_button_bg@2x"] forState:UIControlStateNormal];
    [_btnEnter setBackgroundImage:[UIImage imageNamed:@"register_button_selected_bg@2x"] forState:UIControlStateHighlighted];
    [self.view addSubview:_btnEnter];
    
    
    
    [_btnEnter addTarget:self action:@selector(completeRegister) forControlEvents:UIControlEventTouchUpInside];
}

- (void)completeRegister
{
    
    NSMutableString *codeString = [[NSMutableString alloc] init];
    for (int i = 0; i < 4;i++ ) {
        
        UILabel *label = (UILabel *)[self.view viewWithTag:100+i];
        [codeString appendString:label.text];
    }

    //发送手机注册请求
    NSString *string = @"%2b86";
    [[ADAccountCenter sharedADAccountCenter] userRegisterWithPhone:[string stringByAppendingString:_phoneNumber] passWord:_password codeid:_codeid code:codeString withTarget:self success:@selector(registerSuccessful:) failure:@selector(registerFailure:)];
}

- (void)registerSuccessful:(id)object
{
    NSLog(@"注册成功，.......  %@",object);

    [[NSUserDefaults standardUserDefaults] setObject:object forKey:ACCOUNT_ADDING_UID];
    
    
    //直接登录
    
    //发送登录请求
    NSString *string = @"+86";
    [[ADAccountCenter sharedADAccountCenter] userLoginWithPhone:[string stringByAppendingString:_phoneNumber] passWord:_password withTarget:self success:@selector(loginAddingSuccessful:) failure:@selector(loginAddingFailure:)];
    
    
  }
//登录加丁账号成功
- (void)loginAddingSuccessful:(id)object
{
    NSLog(@"登录成功.....%@",object);
    NSString *token = object;
    [[NSUserDefaults standardUserDefaults] setObject:token forKey:ACCOUNT_ADDING_TOKEN];
    [[NSUserDefaults standardUserDefaults] synchronize];
    //拿token去后去用户信息
    //[[ADAccountCenter sharedADAccountCenter] getUserInfoWithToken:token withTarget:self success:@selector(getUserInfoSuccessful:) failure:@selector(getUserInfoFailure:)];
    
//    ADAppDelegate *appDelegate = (ADAppDelegate *)[[UIApplication sharedApplication] delegate];
//    ADTabBarViewController *tabbarController = (ADTabBarViewController *)appDelegate.window.rootViewController;
//    ADSetPrimaryVC *setPrimeVC = [tabbarController.viewControllers objectAtIndex:1];
    
    [self.navigationController popToRootViewControllerAnimated:YES];

}
- (void)loginAddingFailure:(id)object
{
    [[ADAccountCenter sharedADAccountCenter] showAlertWithMessage:@"登录失败"];
}

- (void)registerFailure:(id)object
{
    NSLog(@"注册失败，.......");
    switch ([object intValue]) {
        case ADREGISTER_ERROR_INVALID_EMAIL:
            [[ADAccountCenter sharedADAccountCenter] showAlertWithMessage:@"邮箱格式错误"];
            break;
        case ADREGISTER_ERROR_EXISTED_EMAIL:
            [[ADAccountCenter sharedADAccountCenter] showAlertWithMessage:@"该邮箱已注册"];
            break;
        case ADREGISTER_ERROR_INVALID_PHONE:
            [[ADAccountCenter sharedADAccountCenter] showAlertWithMessage:@"手机号错误"];
            break;
        case ADREGISTER_ERROR_EXISTED_PHONE:
            [[ADAccountCenter sharedADAccountCenter] showAlertWithMessage:@"该手机号已注册"];
            break;
        case ADREGISTER_ERROR_INVALID_PASSWORD:
            [[ADAccountCenter sharedADAccountCenter] showAlertWithMessage:@"密码格式错误"];
            break;
        default:
            break;
    }
}

#pragma mark - 倒计时
- (void)reGetMessage:(UIButton *)button{
    //click reget message button
    //同事开始倒计时
    [similarTimer invalidate];
    similarTimer = nil;
    similarTimer = [NSTimer scheduledTimerWithTimeInterval:1.0f target:self selector:@selector(countSecond) userInfo:nil repeats:100];
    NSLog(@"button click!!!");
    
    acounrNumber = acount_Number;
    
}

- (void)countSecond{
    
    NSString *buttonTitle = [NSString stringWithFormat:@"重新发送(%d)",acounrNumber-1];
    if (acounrNumber > 0) {
        [_refreshSendCodeButton setTitle:buttonTitle forState:UIControlStateNormal];
    }
    
    acounrNumber--;
    
    if (acounrNumber == 0) {
        [_refreshSendCodeButton setTitle:@"重新发送" forState:UIControlStateNormal];
        [self performSelector:@selector(countEndAction) withObject:self afterDelay:0.0f];
        [similarTimer invalidate];
        similarTimer = nil;
    }
}

- (void)countEndAction{//结束的方法
    NSLog(@"计时结束");
    _refreshSendCodeButton.userInteractionEnabled = YES;
}


- (void)textViewDidChange:(UITextView *)textView
{
    
}

- (void)getTextFieldText:(NSNotification *)notification
{
    
    for (int i = 0; i < 4;i++ ) {
        
        UILabel *label = (UILabel *)[self.view viewWithTag:100+i];
        label.text = @"";
    }
    
    for (int i = 0; i < _codeNumberField.text.length; i++) {
        UILabel *label = (UILabel *)[self.view viewWithTag:100+i];
        label.text = [_codeNumberField.text substringWithRange:NSMakeRange(i,1)];
    }
    
     NSLog(@"哈哈哈输入的字符是%@",_codeNumberField.text);
}

#pragma mark - 网络请求回调
- (void)getCodeSuccessful:(id)obj
{
    NSString *codeid = obj;
    self.codeid = codeid;
}


- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
