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


@interface ADRegisterVC ()

@property(nonatomic,strong) UIImageView *passwordImage;
@property(nonatomic,strong) UIImageView *codeImageViewbg;
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
    
   
    self.view.backgroundColor = [UIColor colorWithRed:241/255.0 green:235/255.0 blue:223/255.0 alpha:1.0];
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
    
    int yOffset = [[ADUIParamManager sharedADUIParamManager] getNavigationBarHeight] +  24/2;
    
    //tel
    CGRect rect = CGRectMake((320 - 580/2)/2,yOffset,580/2 ,110/2);
    
    UIImage* bgimg = [UIImage imageNamed:@"register_border_bg@2x"];
    UIImageView*  telbg = [[UIImageView alloc]initWithFrame:rect];
    telbg.image = bgimg;
    telbg.backgroundColor = [UIColor colorWithRed:241/255.0 green:235/255.0 blue:223/255.0 alpha:1.0];
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
    _telNumberField.placeholder          = @"手机号码";
    _telNumberField.font                 = [UIFont systemFontOfSize:40/2];
    _telNumberField.textColor            = kContentFontColor;
    _telNumberField.frame                = rectBut;
    
    [self.view addSubview:_telNumberField];
    
    
    rect.origin.y +=(rect.size.height + 24/2);
    
    UIImageView*  pswbg = [[UIImageView alloc]initWithFrame:rect];
    pswbg.image  = bgimg;
    pswbg.backgroundColor = [UIColor colorWithRed:241/255.0 green:235/255.0 blue:223/255.0 alpha:1.0];
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
    _pswordField.font                 = [UIFont systemFontOfSize:40/2];
    _pswordField.textColor            = kContentFontColor;
    
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
    
    rect.origin.y +=(rect.size.height + 40/2);
    rectBut = rect;
    rectBut.origin.x = (SCREEN_WIDTH - 260/2)/2;
    rectBut.size.width = 260/2;
    rectBut.size.height= 100/2;
    
    UIButton* _btnRegister        = [UIButton buttonWithType:UIButtonTypeCustom];
    _btnRegister.frame  = rectBut;
    
    [_btnRegister.titleLabel setFont:[UIFont systemFontOfSize:18]];
    [_btnRegister setTitle:@"注册" forState:UIControlStateNormal];
    [_btnRegister setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [_btnRegister setBackgroundImage:[UIImage imageNamed:@"register_button_bg@2x"] forState:UIControlStateNormal];
    [_btnRegister setBackgroundImage:[UIImage imageNamed:@"register_button_selected_bg@2x"] forState:UIControlStateHighlighted];
    [_btnRegister addTarget:self action:@selector(completeRegister) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:_btnRegister];
    
    //小超人图片
    UIImageView *aImageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"superman_little_bg@2x"]];
    aImageView.frame = CGRectMake(0, frame.size.height - 400/4, 400/2, 400/2);
    
    //月球图片
    UIImageView *bImageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"moon_little_bg@2x"]];
    bImageView.frame = CGRectMake(0, frame.size.height - 240/4, 240/2, 240/2);
    
    if (RETINA_INCH4) {
        aImageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"superman_ba@2x"]];
        aImageView.frame = CGRectMake(0, frame.size.height - 600/4, 600/2, 600/2);
        
        bImageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"moon_bg@2x"]];
        bImageView.frame = CGRectMake(0, frame.size.height - 360/4, 360/2, 360/2);
    }
    
    
    CGPoint center = aImageView.center;
    aImageView.center = CGPointMake(320/2,center.y);
    [self.view addSubview:aImageView];
    
    center = bImageView.center;
    bImageView.center = CGPointMake(320/2,center.y);
    [self.view addSubview:bImageView];

    
    
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
}
#pragma mark - textField delegate
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
