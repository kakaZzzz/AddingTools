//
//  ADSetPrimaryVC.m
//  FetalMovement
//
//  Created by wangpeng on 14-3-2.
//  Copyright (c) 2014年 wang peng. All rights reserved.
//

#import "ADSetPrimaryVC.h"
#import "ADAccountCenter.h"
@interface ADSetPrimaryVC ()

@end

@implementation ADSetPrimaryVC

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
        //注册通知
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(oAuthSinaSuccessful:) name:SettingBySinaSuccessfulNotification object:nil];
        
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor yellowColor];
    
    UISwitch *aSwitch = [[UISwitch alloc] initWithFrame:CGRectMake(100, 100, 100, 100)];
    [aSwitch addTarget:self action:@selector(onAndOff:) forControlEvents:UIControlEventValueChanged];
    [self.view addSubview:aSwitch];
    
    UIButton *shareButton = [UIButton buttonWithType:UIButtonTypeCustom];
    shareButton.frame = CGRectMake(100, 200, 100, 100);
    [shareButton setTitle:@"分享" forState:UIControlStateNormal];
    shareButton.backgroundColor = [UIColor blueColor];
    [shareButton addTarget:self action:@selector(shareToSina) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:shareButton];
	// Do any additional setup after loading the view.
}
- (void)onAndOff:(UISwitch *)aSwitch
{
    if (aSwitch.on == NO) {
        NSLog(@"关闭了");
        //解除绑定
        [[ADAccountCenter sharedADAccountCenter] outOAuthSina];
        //删除本地存储token
        [[NSUserDefaults standardUserDefaults] removeObjectForKey:ACCOUNT_SINA_KEY];
        //调取本地解除绑定接口
        [[ADAccountCenter sharedADAccountCenter] removeBindingThirdpartyToken:nil thirdPartyType:ADACCOUNT_TYPE_SINA];
        
        
    }else{
        NSLog(@"打开了");
        //如果本地没有新浪的token
        if ([[NSUserDefaults standardUserDefaults] objectForKey:ACCOUNT_SINA_KEY] == nil) {
            
            [[ADAccountCenter sharedADAccountCenter] getOAuthSina];
        }else{
            NSLog(@"大爷。。。已经授权了");
        }
        
    }
}

-(void)oAuthSinaSuccessful:(NSNotification *)notification
{
    NSLog(@"仅仅拿个授权第三方新浪微博授权成功----%@",[notification userInfo]);//拿到了新浪微博的token
     NSDictionary *dic = notification.userInfo;
    //拿到新浪微博的token,再向本地服务器发送一个请求（前提使用户已经登录）
    NSString *token = [dic objectForKeyedSubscript:ACCOUNT_SINA_TOKEN];
    if ([[NSUserDefaults standardUserDefaults] objectForKey:ACCOUNT_ADDING_TOKEN]) {
        
        [[ADAccountCenter sharedADAccountCenter] bindingThirdpartyToken:token thirdPartyType:ADACCOUNT_TYPE_SINA];//绑定
    }else{
        NSLog(@"未登录，无法绑定...");
        //走第三方账户登录通道
    }
    
    
    
    
}

- (void)shareToSina
{
//    NSString *filePath = [[NSBundle mainBundle] pathForResource:@"sina_icon@2x" ofType:@"png"];
    UIImage *aimage = [UIImage imageNamed:@"sina_icon"];
    NSData *imageData = UIImageJPEGRepresentation(aimage,1);
//    NSData *picData = [NSData dataWithContentsOfFile:filePath];
    [[ADAccountCenter sharedADAccountCenter] shareToSinaWeiboWithText:@"12" picture:imageData];
}
- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
