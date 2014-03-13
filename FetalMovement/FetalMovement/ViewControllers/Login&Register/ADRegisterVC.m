//
//  ADRegisterVC.m
//  Register&&login
//
//  Created by wangpeng on 14-3-11.
//  Copyright (c) 2014年 wang peng. All rights reserved.
//

#import "ADRegisterVC.h"
#import "RegexKitLite.h"
#import "ADAccountCenter.h"
#define REGISTER_TEXFID_TAG 100

@interface ADRegisterVC ()

@property(nonatomic,strong) UIImageView *passwordImage;
@property(nonatomic,strong) UIImageView *codeImageViewbg;
@property(nonatomic,strong) UIScrollView *scrollView;
@property(nonatomic,strong) UIButton *btnEnter;
@end
@implementation ADRegisterVC

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
   
    self.view.backgroundColor = [UIColor blueColor];
    [self createSubviews:self.view.frame];
    [self configureNavigationView];
    
    
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
    
    [self.navigationController popViewControllerAnimated:YES];
    
}

- (void)createSubviews:(CGRect)frame
{
    
    int yStatusOffset = 0;
    if (IOS7_OR_LATER) {
        yStatusOffset = 20;
    }
    frame.origin.y -=yStatusOffset;
    self.scrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 0, 320, frame.size.height)];
    _scrollView.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:_scrollView];
    [self.view bringSubviewToFront:self.navigationView];
    
    int yOffset = [[ADUIParamManager sharedADUIParamManager] getNavigationBarHeight] +  12/2;

    
    //tel
    CGRect rect = CGRectMake((320 - 580/2)/2,yOffset,580/2 ,110/2);
    
    UIImage* bgimg = [UIImage imageNamed:@"register_border_bg@2x"];
    
    //电话 或者邮箱
    UIImageView*  telbg = [[UIImageView alloc]initWithFrame:rect];
    telbg.image = bgimg;
    telbg.backgroundColor = [UIColor whiteColor];
    [_scrollView addSubview:telbg];
    
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
    _telNumberField.placeholder          = @"邮箱地址 或 手机号码";
    _telNumberField.font                 = [UIFont systemFontOfSize:17];
    _telNumberField.frame                = rectBut;
    _telNumberField.delegate             = self;
    _telNumberField.tag = REGISTER_TEXFID_TAG + 0;
    [_scrollView addSubview:_telNumberField];
    
    
//    //昵称
//    rect.origin.y +=(rect.size.height + 10);
//    
//    UIImageView*  pswbg = [[UIImageView alloc]initWithFrame:rect];
//    pswbg.image  = bgimg;
//    pswbg.backgroundColor = [UIColor whiteColor];
//    [_scrollView addSubview:pswbg];
//    
//    rectBut = rect;
//    rectBut.size.width  -=20 * 2;
//    rectBut.size.height  = 22;
//    rectBut.origin.x    += 20;
//    rectBut.origin.y    += (int)( ( rect.size.height - rectBut.size.height) /2);
//    self.nickNameField                  = [[UITextField alloc] init];
//    _nickNameField.backgroundColor      = [UIColor whiteColor];
//    _nickNameField.keyboardType         = UIKeyboardTypeASCIICapable;
//    _nickNameField.borderStyle          = UITextBorderStyleNone;
//    _nickNameField.clipsToBounds        = YES;
//    _nickNameField.font                 = [UIFont systemFontOfSize:17];
//    
//    _nickNameField.clearButtonMode      = UITextFieldViewModeWhileEditing;
//    _nickNameField.autocapitalizationType = UITextAutocapitalizationTypeNone;
//    _nickNameField.autocorrectionType   = UITextAutocorrectionTypeNo;
//    _nickNameField.frame                = rectBut;
//    _nickNameField.placeholder          = @"昵称（选填）";
//    _nickNameField.secureTextEntry      = YES;
//    _nickNameField.returnKeyType        = UIReturnKeyGo;
//    _nickNameField.delegate             = self;
//     _nickNameField.tag                 = REGISTER_TEXFID_TAG + 1;
//    [_scrollView addSubview:_nickNameField];

    
    
    //密码
    rect.origin.y +=(rect.size.height + 24/2);
    
    self.passwordImage = [[UIImageView alloc]initWithFrame:rect];
    _passwordImage.image  = bgimg;
    _passwordImage.backgroundColor = [UIColor whiteColor];
    _passwordImage.userInteractionEnabled = YES;
    [_scrollView addSubview:_passwordImage];
    
//    rectBut = rect;
//    rectBut.size.width  -=20;
//    rectBut.size.height  = 22;
//    rectBut.origin.x    += 10;
//    rectBut.origin.y    += (int)( ( rect.size.height - rectBut.size.height) /2);
    
    rectBut = rect;
    rectBut.size.width  -=20*2;
    rectBut.size.height  = 22;
    rectBut.origin.x     = 20;
    rectBut.origin.y    = (int)( ( rect.size.height - rectBut.size.height) /2);

    
    self.pswordField                  = [[UITextField alloc] init];
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
    _pswordField.tag                  = REGISTER_TEXFID_TAG + 2;
    [_passwordImage addSubview:_pswordField];
    
    
    //验证码
    rect.origin.y +=(rect.size.height + 24/2);
    
    self.codeImageViewbg = [[UIImageView alloc]initWithFrame:rect];
    _codeImageViewbg.image  = bgimg;
    _codeImageViewbg.backgroundColor = [UIColor whiteColor];
    _codeImageViewbg.userInteractionEnabled = YES;
    _codeImageViewbg.hidden = YES;
    [_scrollView addSubview:_codeImageViewbg];
    
    rectBut = rect;
    rectBut.size.width  -=20*2;
    rectBut.size.height  = 22;
    rectBut.origin.x     = 20;
    rectBut.origin.y     = (int)( ( rect.size.height - rectBut.size.height) /2);
    self.codeField                  = [[UITextField alloc] init];
    _codeField.backgroundColor      = [UIColor whiteColor];
    _codeField.keyboardType         = UIKeyboardTypeASCIICapable;
    _codeField.borderStyle          = UITextBorderStyleNone;
    _codeField.clipsToBounds        = YES;
    _codeField.font                 = [UIFont systemFontOfSize:17];
    
    _codeField.clearButtonMode      = UITextFieldViewModeWhileEditing;
    _codeField.autocapitalizationType = UITextAutocapitalizationTypeNone;
    _codeField.autocorrectionType   = UITextAutocorrectionTypeNo;
    _codeField.frame                = rectBut;
    _codeField.placeholder          = @"验证码";
    _codeField.secureTextEntry      = YES;
    _codeField.returnKeyType        = UIReturnKeyGo;
    _codeField.delegate             = self;
    _codeField.tag                  = REGISTER_TEXFID_TAG + 3;
    [_codeImageViewbg addSubview:_codeField];

    
    //_btnLogin
    rect = _passwordImage.frame;
    rect.origin.y +=(rect.size.height + 60/2);
    rectBut = rect;
    rectBut.origin.x = (320 - 260/2)/2;
    rectBut.size.width = 260/2;
    rectBut.size.height= 110/2;
    
    self.btnEnter        = [UIButton buttonWithType:UIButtonTypeCustom];
    _btnEnter.frame  = rectBut;
    
    [_btnEnter.titleLabel setFont:[UIFont systemFontOfSize:18]];
    [_btnEnter setTitle:@"确定" forState:UIControlStateNormal];
    [_btnEnter setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [_btnEnter setBackgroundImage:[UIImage imageNamed:@"register_button_bg@2x"] forState:UIControlStateNormal];
    [_btnEnter setBackgroundImage:[UIImage imageNamed:@"register_button_selected_bg@2x"] forState:UIControlStateHighlighted];
    [_scrollView addSubview:_btnEnter];
    
    
      
    [_btnEnter addTarget:self action:@selector(completeRegister) forControlEvents:UIControlEventTouchUpInside];
    
    
    
}
#pragma mark - button event
- (void)completeRegister
{
    [self hideKeyBoard];
    
    if ([self isMobileNumber:_telNumberField.text]) {
        if ([self isPassWord:_pswordField.text]) {
            if (![_codeField.text isEqualToString:@""]) {
                //发送手机注册请求
                NSString *string = @"%2b86";
                [[ADAccountCenter sharedADAccountCenter] userRegisterWithPhone:[string stringByAppendingString:_telNumberField.text] passWord:@"A123456789" withTarget:self success:@selector(registerSuccessful:) failure:@selector(registerFailure:)];
            }else{
                NSLog(@"验证码为空");
            }
        }else{
            NSLog(@"密码格式不正确");
            
        }
    }
    else if ([self isEmail:_telNumberField.text])
    {
        if ([self isPassWord:_pswordField.text]) {
            //发送邮箱注册请求
            [[ADAccountCenter sharedADAccountCenter] userRegisterWithEmail:_telNumberField.text passWord:@"A123456789" withTarget:self success:@selector(registerSuccessful:) failure:@selector(registerFailure:)];
            
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
- (void)registerSuccessful:(id)object
{
    NSLog(@"注册成功，.......  %@",object);
    
    [[NSUserDefaults standardUserDefaults] setObject:object forKey:ACCOUNT_ADDING_UID];
    [self.navigationController popViewControllerAnimated:YES];
}


- (void)registerFailure:(id)object
{
    NSLog(@"注册失败，.......");
    switch ([object intValue]) {
        case ADREGISTER_ERROR_INVALID_EMAIL:
            [self showAlertWithTitle:@"邮箱格式错误"];
            break;
        case ADREGISTER_ERROR_EXISTED_EMAIL:
            [self showAlertWithTitle:@"该邮箱已注册"];
            break;
        case ADREGISTER_ERROR_INVALID_PHONE:
            [self showAlertWithTitle:@"手机号错误"];
            break;
        case ADREGISTER_ERROR_EXISTED_PHONE:
            [self showAlertWithTitle:@"该手机号已注册"];
            break;
        case ADREGISTER_ERROR_INVALID_PASSWORD:
            [self showAlertWithTitle:@"密码格式错误"];
            break;
           default:
            break;
    }
}


- (void)showAlertWithTitle:(NSString *)message
{
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"亲" message:message delegate:self cancelButtonTitle:@"知道了" otherButtonTitles:nil, nil];
    [alert show];
    
}
#pragma mark - private methods
- (BOOL)sMatchedByRegex:(NSString *)regex
{
    return YES;
}

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

#pragma mark - private method
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
    if ([_nickNameField isFirstResponder]){
        [_nickNameField resignFirstResponder];
    }
    if ([_codeField isFirstResponder]){
        [_codeField resignFirstResponder];
    }

    self.scrollView.contentOffset = CGPointMake(0, 0);
}
#pragma mark - textField delegate
- (void)textFieldDidEndEditing:(UITextField *)textField
{
    static int telComplete = 1;
    if ((textField.tag == REGISTER_TEXFID_TAG + 0) && [self  isMobileNumber:_telNumberField.text]) {
        NSLog(@"丫的手机号输入完毕");
        
        _codeImageViewbg.hidden = NO;
        
        CGRect rect = _codeImageViewbg.frame;
        rect.origin.y +=(rect.size.height + 60/2);
        rect.origin.x = (320 - 260/2)/2;
        rect.size.width = 260/2;
        rect.size.height= 110/2;
        self.btnEnter.frame = rect;
        
        
        telComplete = 2;
    }else if ((textField.tag == REGISTER_TEXFID_TAG + 0) && ![self  isMobileNumber:_telNumberField.text])
    {
        _codeImageViewbg.hidden = YES;
        
        CGRect rect = _passwordImage.frame;
        rect.origin.y +=(rect.size.height + 60/2);
        rect.origin.x = (320 - 260/2)/2;
        rect.size.width = 260/2;
        rect.size.height= 110/2;
        self.btnEnter.frame = rect;
        

    }
}

- (void)textFieldDidBeginEditing:(UITextField *)textField
{
 
//    if (RETINA_INCH4) {
//        
//        NSLog(@"4寸的屏幕真蛋疼");
//        switch (textField.tag) {
//            case REGISTER_TEXFID_TAG + 0:
//                self.scrollView.contentOffset = CGPointMake(0, 0);
//                break;
//            case REGISTER_TEXFID_TAG + 1:
//                self.scrollView.contentOffset = CGPointMake(0, 20);
//                break;
//            case REGISTER_TEXFID_TAG + 2:
//                self.scrollView.contentOffset = CGPointMake(0, 40);
//                break;
//            case REGISTER_TEXFID_TAG + 3:
//                self.scrollView.contentOffset = CGPointMake(0, 80);
//                break;
//                
//            default:
//                break;
//        }
//
//    }
//    else{
//        switch (textField.tag) {
//            case REGISTER_TEXFID_TAG + 0:
//                self.scrollView.contentOffset = CGPointMake(0, 0);
//                break;
//            case REGISTER_TEXFID_TAG + 1:
//                self.scrollView.contentOffset = CGPointMake(0, 50);
//                break;
//            case REGISTER_TEXFID_TAG + 2:
//                self.scrollView.contentOffset = CGPointMake(0, 120);
//                break;
//            case REGISTER_TEXFID_TAG + 3:
//                self.scrollView.contentOffset = CGPointMake(0, 180);
//                break;
//                
//            default:
//                break;
//        }
//
//    }
}
- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [self hideKeyBoard];
    return YES;
}
- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
