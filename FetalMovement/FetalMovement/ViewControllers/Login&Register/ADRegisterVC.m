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
#import "ADCodeVC.h"

#define REGISTER_TEXFID_TAG 100
#define countButton_tag  (3001)


@interface ADRegisterVC ()

@property(nonatomic,strong) UIImageView *passwordImage;
@property(nonatomic,strong) UIImageView *codeImageViewbg;
@property(nonatomic,strong) UIScrollView *scrollView;
@property(nonatomic,strong) UIButton *btnEnter;
@property(nonatomic,strong) NSString *codeid;
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
    [similarTimer invalidate];
    similarTimer = nil;

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
    _telNumberField.placeholder          = @" 手机号码";
    _telNumberField.font                 = [UIFont systemFontOfSize:40/2];
    _telNumberField.frame                = rectBut;
    _telNumberField.delegate             = self;
    _telNumberField.tag = REGISTER_TEXFID_TAG + 0;
    [_scrollView addSubview:_telNumberField];
    
    
    
    //密码
    rect.origin.y +=(rect.size.height + 24/2);
    
    self.passwordImage = [[UIImageView alloc]initWithFrame:rect];
    _passwordImage.image  = bgimg;
    _passwordImage.backgroundColor = [UIColor whiteColor];
    _passwordImage.userInteractionEnabled = YES;
    [_scrollView addSubview:_passwordImage];
    
    
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
    
    rectBut.size.width -= 100;

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
    [_btnEnter setTitle:@"注册" forState:UIControlStateNormal];
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
            
            ADCodeVC *codeVC = [[ADCodeVC alloc] initWithNavigationViewWithTitle:@"手机验证"];
            codeVC.phoneNumber = _telNumberField.text;
            codeVC.password = _pswordField.text;
            [self.navigationController pushViewController:codeVC animated:YES];

        }
            
               }
    else
    {
        NSLog(@"重新输入邮箱或者手机号");
        [[ADAccountCenter sharedADAccountCenter] showAlertWithMessage:@"手机号格式不正确"];
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
- (void)getCodeSuccessful:(id)obj
{
    NSString *codeid = obj;
    self.codeid = codeid;
}
- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [self hideKeyBoard];
    return YES;
}


- (void)dealloc
{
    [similarTimer invalidate];
    similarTimer = nil;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
