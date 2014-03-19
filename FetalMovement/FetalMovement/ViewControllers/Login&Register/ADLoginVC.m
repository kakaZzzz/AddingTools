//
//  ADLoginVC.m
//  FetalMovement
//
//  Created by wangpeng on 14-3-11.
//  Copyright (c) 2014年 wang peng. All rights reserved.
//

#import "ADLoginVC.h"
#import "ADRegisterVC.h"
#import "ADAccountCenter.h"
#import "RegexKitLite.h"
#import "ADAppDelegate.h"
@interface ADLoginVC ()
@property(nonatomic,strong)TencentOAuth *tencentOAuth;

@end

@implementation ADLoginVC

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
        
        //注册通知
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(loginOAuthSinaSuccessful:) name:LoginBySinaSuccessfulNotification object:nil];
        
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    

    [self configureNavigationView];
    self.view.backgroundColor = [UIColor whiteColor];
    [self createSubviews:self.view.frame];
    
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapBlankRegin:)];
    [self.view addGestureRecognizer:tap];
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
    
    [self.navigationController popToRootViewControllerAnimated:YES];
    
}

- (void)createSubviews:(CGRect)frame
{
//    int nLeftMargin = (320 - 580/2)/2;
    int yOffset = [[ADUIParamManager sharedADUIParamManager] getNavigationBarHeight] +  12/2;
   
    //tel
    CGRect rect = CGRectMake((320 - 580/2)/2,yOffset,580/2 ,110/2);
    
    UIImage* bgimg = [UIImage imageNamed:@"register_border_bg@2x"];
    //    if ([UIImage instancesRespondToSelector:@selector(resizableImageWithCapInsets:)]) {
    //        bgimg = [bgimg resizableImageWithCapInsets:UIEdgeInsetsMake(0,10,0,10)];
    //    }
    //    else{
    //        bgimg = [bgimg stretchableImageWithLeftCapWidth:10 topCapHeight:0];
    //    }
    
    UIImageView*  telbg = [[UIImageView alloc]initWithFrame:rect];
    telbg.image = bgimg;
    telbg.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:telbg];
    
    CGRect rectBut;
    rectBut = rect;
    rectBut.size.width  -=20 * 2;
    rectBut.size.height  = 22;
    rectBut.origin.x    += 20;
    rectBut.origin.y    += (int)( (rect.size.height - rectBut.size.height) /2);
    
    self.telNumberField                      = [[UITextField alloc] init];
    _telNumberField.backgroundColor      = [UIColor whiteColor];
    _telNumberField.keyboardType         = UIKeyboardTypePhonePad;
    _telNumberField.borderStyle          = UITextBorderStyleNone;
    _telNumberField.clipsToBounds        = YES;
    _telNumberField.clearButtonMode      = UITextFieldViewModeWhileEditing;
    _telNumberField.autocapitalizationType = UITextAutocapitalizationTypeNone;
    _telNumberField.autocorrectionType   = UITextAutocorrectionTypeNo;
    _telNumberField.placeholder          = @"手机号";
    _telNumberField.font                 = [UIFont systemFontOfSize:17];
    _telNumberField.frame                = rectBut;
    
    [self.view addSubview:_telNumberField];
    
    
    rect.origin.y +=(rect.size.height + 24/2);
    
    UIImageView*  pswbg = [[UIImageView alloc]initWithFrame:rect];
    pswbg.image  = bgimg;
    pswbg.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:pswbg];
    
    
    rectBut = rect;
    rectBut.size.width  -=20 * 2;
    rectBut.size.height  = 22;
    rectBut.origin.x    += 20;
    rectBut.origin.y    += (int)( ( rect.size.height - rectBut.size.height) /2);
    self.pswordField                      = [[UITextField alloc] init];
    _pswordField.backgroundColor      = [UIColor whiteColor];
    _pswordField.keyboardType         = UIKeyboardTypeASCIICapable;
    _pswordField.borderStyle          = UITextBorderStyleNone;
    _pswordField.clipsToBounds        = YES;
    _pswordField.font                 = [UIFont systemFontOfSize:17];
    
    _pswordField.clearButtonMode      = UITextFieldViewModeWhileEditing;
    _pswordField.autocapitalizationType = UITextAutocapitalizationTypeNone;
    _pswordField.autocorrectionType   = UITextAutocorrectionTypeNo;
    _pswordField.frame                = rectBut;
    _pswordField.placeholder          = @"密码";
    _pswordField.secureTextEntry      = YES;
    _pswordField.returnKeyType        = UIReturnKeyGo;
    _pswordField.delegate             = self;
    [self.view addSubview:_pswordField];
    
    
    
    
    //_btnLogin
    rect.origin.y +=(rect.size.height + 60/2);
    rectBut = rect;
    rectBut.origin.x = (SCREEN_WIDTH - 260/2)/2;
    rectBut.size.width = 260/2;
    rectBut.size.height= 100/2;
    
    UIButton* _btnLogin        = [UIButton buttonWithType:UIButtonTypeCustom];
    _btnLogin.frame  = rectBut;
    
    [_btnLogin.titleLabel setFont:[UIFont systemFontOfSize:18]];
    [_btnLogin setTitle:@"登录" forState:UIControlStateNormal];
    [_btnLogin setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [_btnLogin setBackgroundImage:[UIImage imageNamed:@"register_button_bg@2x"] forState:UIControlStateNormal];
    [_btnLogin setBackgroundImage:[UIImage imageNamed:@"register_button_selected_bg@2x"] forState:UIControlStateHighlighted];
    [self.view addSubview:_btnLogin];
    
    rectBut.origin.y +=(rectBut.size.height +0);
    
    
    UIButton* _btnRegister        = [UIButton buttonWithType:UIButtonTypeCustom];
    _btnRegister.frame  = rectBut;
    
    [_btnRegister.titleLabel setFont:[UIFont systemFontOfSize:15]];
    [_btnRegister setTitle:@"注册加丁账号" forState:UIControlStateNormal];
    [_btnRegister setTitleColor:[UIColor redColor] forState:UIControlStateNormal];
//    [_btnRegister setBackgroundImage:[UIImage imageNamed:@"register_button_bg@2x"]forState:UIControlStateNormal];
//    [_btnRegister setBackgroundImage:[UIImage imageNamed:@"register_button_selected_bg@2x"] forState:UIControlStateHighlighted];
    [self.view addSubview:_btnRegister];
    
    [_btnLogin addTarget:self action:@selector(LoginAuthTel) forControlEvents:UIControlEventTouchUpInside];
    [_btnRegister addTarget:self action:@selector(LoginRegister) forControlEvents:UIControlEventTouchUpInside];
    
    
    //others login
    rect.origin.y += (rect.size.height + 120/2);
    rect.origin.x   = 0;
    rect.size.width =frame.size.width;
    rect.size.height=frame.size.height-rect.origin.y;
    
    self.contentView = [[UIView alloc] initWithFrame:rect];
    _contentView.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:_contentView];
    
    
    
//    rect = CGRectMake(0, 0, frame.size.width, 30);
//    UILabel * othersTitle = [[UILabel alloc]init];
//    othersTitle.backgroundColor = [UIColor clearColor];
//    othersTitle.textAlignment = NSTextAlignmentCenter;
//    [othersTitle setFont:[UIFont systemFontOfSize:16]];
//    [othersTitle setText:@"第三方帐号登录"];
//    [othersTitle setTextColor:[UIColor blueColor]];
//    othersTitle.frame = rect;
//    [_contentView addSubview:othersTitle];
    
    
    
    //
    rect = CGRectMake(0, 0, frame.size.width, 0);
    int nbuttonMargin = 24/2;
    rect.size.height    = 100/2;
    rect.size.width     = 100/2;
    rect.origin.x       = 30/2;
    
    UIButton * _btnSina = [UIButton buttonWithType:UIButtonTypeCustom];
    _btnSina.frame = rect;
    [_btnSina setBackgroundImage:[UIImage imageNamed:@"sina_icon@2x"] forState:UIControlStateNormal];
    [_btnSina setBackgroundImage:[UIImage imageNamed:@"sina_icon_hilight@2x"] forState:UIControlStateNormal];
    [_contentView addSubview:_btnSina];
    
    
   
    
    rect.origin.x += (rect.size.width + nbuttonMargin);
    UIButton * _btnQQ = [UIButton buttonWithType:UIButtonTypeCustom];
    _btnQQ.frame = rect;
    [_btnQQ setBackgroundImage:[UIImage imageNamed:@"qq_icon@2x"] forState:UIControlStateNormal];
    [_btnQQ setBackgroundImage:[UIImage imageNamed:@"qq_icon_hilight@2x"] forState:UIControlStateHighlighted];
    [_contentView addSubview:_btnQQ];
    
    rect.origin.x += (rect.size.width + nbuttonMargin);
    UIButton * _tencent = [UIButton buttonWithType:UIButtonTypeCustom];
    [_tencent setBackgroundImage:[UIImage imageNamed:@"tencent_icon@2x"] forState:UIControlStateNormal];
    [_tencent setBackgroundImage:[UIImage imageNamed:@"tencent_icon_hilight@2x"] forState:UIControlStateHighlighted];
    _tencent.frame = rect;
    [_contentView addSubview:_tencent];
    
    rect.origin.x += (rect.size.width + 36/2);
    rect.size.width     = SCREEN_WIDTH - rect.origin.x;
    UIButton * _immeEnter = [UIButton buttonWithType:UIButtonTypeCustom];
    _immeEnter.frame = rect;
    [_immeEnter setBackgroundImage:[UIImage imageNamed:@"immet_enter_bg@2x"] forState:UIControlStateNormal];
    [_immeEnter setBackgroundImage:[UIImage imageNamed:@"immet_enter_bg_hilight@2x"] forState:UIControlStateHighlighted];
    [_contentView addSubview:_immeEnter];
    
    [_btnSina addTarget:self action:@selector(LoginAuthSina) forControlEvents:UIControlEventTouchUpInside];
    [_tencent addTarget:self action:@selector(LoginAauthTencentWeibo) forControlEvents:UIControlEventTouchUpInside];
    [_btnQQ addTarget:self action:@selector(LoginAuthQQ) forControlEvents:UIControlEventTouchUpInside];
    [_immeEnter addTarget:self action:@selector(immediateEnter) forControlEvents:UIControlEventTouchUpInside];

}

#pragma button event

#pragma mark - Click

//注册
-(void)LoginRegister
{
    //    FlurrylogEvent(@"1284", @"注册");
    //
    [self hideKeyBoard];
    
    ADRegisterVC *registerVC = [[ADRegisterVC alloc] initWithNavigationViewWithTitle:@"注册"];
    [self.navigationController pushViewController:registerVC animated:YES];
    //[self presentViewController:registerVC animated:YES completion:nil];
    //
    //    [self doAskUserRegister];
}

//登录
-(void)LoginAuthTel
{
      [self hideKeyBoard];
    if ([self isMobileNumber:_telNumberField.text]) {
        if ([self isPassWord:_pswordField.text]) {
            
                //发送登录请求
                NSString *string = @"+86";
                [[ADAccountCenter sharedADAccountCenter] userLoginWithPhone:[string stringByAppendingString:_telNumberField.text] passWord:_pswordField.text withTarget:self success:@selector(loginAddingSuccessful:) failure:@selector(loginAddingFailure:)];
        }else{
            NSLog(@"密码格式不正确");
            
        }
    }
    else if ([self isEmail:_telNumberField.text])
    {
        if ([self isPassWord:_pswordField.text]) {
            //发送注册请求
            [[ADAccountCenter sharedADAccountCenter] userLoginWithEmail:_telNumberField.text passWord:_pswordField.text withTarget:self success:@selector(loginAddingSuccessful:) failure:@selector(loginAddingFailure:)];
            
        }
        else{
            NSLog(@"密码格式不正确");
        }
    }
    
    else
    {
        NSLog(@"重新输入邮箱或者手机号");
    }


}
//登录加丁账号成功
- (void)loginAddingSuccessful:(id)object
{
    NSLog(@"登录成功.....%@",object);
    NSString *token = object;
    [[NSUserDefaults standardUserDefaults] setObject:token forKey:ACCOUNT_ADDING_TOKEN];
    [[NSUserDefaults standardUserDefaults] synchronize];
    //拿token去后去用户信息
    [[ADAccountCenter sharedADAccountCenter] getUserInfoWithToken:token withTarget:self success:@selector(getUserInfoSuccessful:) failure:@selector(getUserInfoFailure:)];
    
}

- (void)getUserInfoSuccessful:(id)object
{
    NSDictionary *dic = object;
    [[ADAccountCenter sharedADAccountCenter] writeUserInfoToUserdefalutWithUserInfo:dic];
    
    //表示登录成功  做登录成功之后的事情
    
    
    
}
- (void)getUserInfoFailure:(id)object
{
    
}
//登录加丁账号失败
- (void)loginAddingFailure:(id)object
{
    [[ADAccountCenter sharedADAccountCenter] showAlertWithMessage:@"登录失败"];
}

-(void)LoginAuthSina
{
    [self hideKeyBoard];
    [self changeUrlTypeOfAppdelegateWithType:ADACCOUNT_TYPE_SINA];
    [[ADAccountCenter sharedADAccountCenter] loginOAuthSina];

    //[self ensureUserLogin:GLACCOUNT_TYPE_SINA];
}
-(void)loginOAuthSinaSuccessful:(NSNotification *)notification
{
    NSDictionary *dic = notification.userInfo;
    NSLog(@"第三方新浪微博登录成功----%@",notification.userInfo);
    NSString *token = [dic objectForKey:ACCOUNT_SINA_TOKEN];
//    NSString *uid = [dic objectForKey:ACCOUNT_SINA_UID];
  
    //拿到新浪微博的token,再向本地服务器发送一个请求.生成一个加丁自己的token
    [[ADAccountCenter sharedADAccountCenter] postThirdpartyTokenTolocalServer:token thirdPartyType:ADACCOUNT_TYPE_SINA withTarget:self success:@selector(thirdPartySuccessful:) failure:@selector(thirdPartyFailure:)];
    
    //
    
   
}

- (void)thirdPartySuccessful:(id)obj
{
    [self.navigationController popToRootViewControllerAnimated:YES];
}
- (void)thirdPartyFailure:(id)obj
{
    [[ADAccountCenter sharedADAccountCenter] showAlertWithMessage:@"登录失败"];
}
-(void)LoginAuthQQ
{
    [self hideKeyBoard];
    
    [self changeUrlTypeOfAppdelegateWithType:ADACCOUNT_TYPE_TENCENT];
    
    self.tencentOAuth = [[TencentOAuth alloc] initWithAppId:kQQAppKey andDelegate:self];
    _tencentOAuth.redirectURI = kQQRedirectURI;
    
    NSArray *permissions = [NSArray arrayWithObjects:@"get_user_info", @"add_t", nil];
                            
    [_tencentOAuth authorize:permissions inSafari:NO];
                            
                            
    //[self ensureUserLogin:GLACCOUNT_TYPE_TENCENT];
}
-(void)tencentDidNotLogin:(BOOL)cancelled
{
    if (cancelled)
    {
        NSLog(@"取消了登录");
    }
    else
    {
        
    }
}

- (void)tencentDidLogin
{
    NSLog(@"登陆成功");
    if (_tencentOAuth.accessToken && 0 != [_tencentOAuth.accessToken length])
    {
        // 记录登录用户的OpenID、Token以及过期时间
        NSLog(@"获取的token是%@",_tencentOAuth.accessToken);
        //拿到qq的token,再向本地服务器发送一个请求.生成一个加丁自己的token
        
        [[ADAccountCenter sharedADAccountCenter] postThirdpartyTokenTolocalServer:_tencentOAuth.accessToken thirdPartyType:ADACCOUNT_TYPE_SINA withTarget:self success:@selector(thirdPartySuccessful:) failure:@selector(thirdPartyFailure:)];
    }
    else
    {
         NSLog(@"登录不成功 没有获取accesstoken");
        [[ADAccountCenter sharedADAccountCenter] showAlertWithMessage:@"登录失败"];
        
    }
}

-(void)LoginAauthTencentWeibo
{
    [self hideKeyBoard];
     //百度云账号登录
    
}

- (void)immediateEnter
{
    
}
#pragma mark - Private Methods

- (BOOL)isMobileNumber:(NSString *)mobileNum
{
    return [mobileNum isMatchedByRegex:@"^(13[0-9]|15[0-9]|18[0-9])\\d{8}$"];
}
- (BOOL)isEmail:(NSString *)emailStr
{
    return [emailStr isMatchedByRegex:@"\\b([a-zA-Z0-9%_.+\\-]+)@([a-zA-Z0-9.\\-]+?\\.[a-zA-Z]{2,6})\\b"];
}
- (BOOL)isPassWord:(NSString *)password
{
    
    
    // return  [password isMatchedByRegex: @"^[A-Za-z0-9]{9,15}$"];
    
    BOOL hasChar = [password isMatchedByRegex: @"[A-Za-z]"];
    BOOL hasNum = [password isMatchedByRegex: @"[0-9]"];
    BOOL hasSymbol = [password isMatchedByRegex: @"[^0-9a-zA-Z]"];
    
    int result = (hasChar?1:0) + (hasNum?1:0) + (hasSymbol?1:0);
    NSLog(@"哈哈哈哈%d-----%d,%d,%d",result,(hasChar?1:0),(hasNum?1:0),(hasSymbol?1:0));
    
    if (result < 2) {
        return NO;
    }else{
        return YES;
    }
    
}

-(void)tapBlankRegin:(UITapGestureRecognizer *)tap
{
    [self hideKeyBoard];
}
-(void)hideKeyBoard
{
    if ([_pswordField isFirstResponder]){
        [_pswordField resignFirstResponder];
    }
    if ([_telNumberField isFirstResponder]){
        [_telNumberField resignFirstResponder];
    }
}

#pragma mark - 改变appdelegate的 urlType属性的值
- (void)changeUrlTypeOfAppdelegateWithType:(ADACCOUNT_TYPE)type
{
    ADAppDelegate *delegate = (ADAppDelegate *)[[UIApplication sharedApplication] delegate];
    delegate.urlType = type;
}
- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
