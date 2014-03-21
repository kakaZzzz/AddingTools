//
//  ADAccountVC.m
//  FetalMovement
//
//  Created by wangpeng on 14-3-14.
//  Copyright (c) 2014年 wang peng. All rights reserved.
//

#import "ADAccountVC.h"
#import "ADAccoundCell.h"
#import "ADSettingSectionCell.h"
#import "ADAccountCenter.h"
#import "ADSwitch.h"
#import "ADAppDelegate.h"
#import "ADLoginFirstVC.h"

#define CELL_SECTION (indexPath.row == 1)
@interface ADAccountVC ()
@property(nonatomic,strong) UITableView *tableView;
@property(nonatomic,strong) TencentOAuth *tencentOAuth;


@end

@implementation ADAccountVC

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
        
        //注册通知
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(oAuthSinaSuccessful:) name:SettingBySinaSuccessfulNotification object:nil];
        //注册通知
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(oAuthSinaFailure:) name:SettingBySinaFailureNotification object:nil];
        
        NSString *path = [[NSBundle mainBundle] pathForResource:@"AccoundSetProperty List" ofType:@"plist"];
        NSDictionary *resourseDic = [NSDictionary dictionaryWithContentsOfFile:path];
        self.titleArray = [NSMutableArray arrayWithCapacity:1];
        self.titleArray.array = [resourseDic objectForKey:@"title"];
        self.iconArray = [resourseDic objectForKey:@"icon"];
        
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    [self configureNavigationView];
    
    
    
    int navigationHeight = [[ADUIParamManager sharedADUIParamManager] getNavigationBarHeight];
    
    self.tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, navigationHeight, SCREEN_WIDTH, self.view.frame.size.height - (navigationHeight)) style:UITableViewStylePlain];
    
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    self.tableView.separatorColor = [UIColor clearColor];
    self.tableView.showsVerticalScrollIndicator = NO;
    [self.view addSubview:self.tableView];
    
    
    
    // Do any additional setup after loading the view.
    
    UIButton *shareButton = [UIButton buttonWithType:UIButtonTypeCustom];
    shareButton.frame = CGRectMake(100, 200, 100, 100);
    [shareButton setTitle:@"同步" forState:UIControlStateNormal];
    shareButton.backgroundColor = [UIColor blueColor];
    [shareButton addTarget:self action:@selector(shareToSina) forControlEvents:UIControlEventTouchUpInside];
//    [self.view addSubview:shareButton];
    
    UIButton *exitButton = [UIButton buttonWithType:UIButtonTypeCustom];
    exitButton.frame = CGRectMake((SCREEN_WIDTH - 170/2)/2, self.view.frame.size.height - 36/2 - 80/2, 170/2, 80/2);
    [exitButton setBackgroundImage:[UIImage imageNamed:@"exit_button_bg@2x"] forState:UIControlStateNormal];
    exitButton.backgroundColor = [UIColor clearColor];
    [exitButton addTarget:self action:@selector(exitAccount) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:exitButton];
    
}
- (void)viewWillAppear:(BOOL)animated
{
  
    if ([[NSUserDefaults standardUserDefaults] objectForKey:ACCOUNT_ADDING_ISADDING]) {
        [self.titleArray replaceObjectAtIndex:0 withObject:[NSString stringWithFormat:@"账号"]];
    }else{
        [self.titleArray replaceObjectAtIndex:0 withObject:[NSString stringWithFormat:@"昵称"]];
    }
    
    [self.tableView reloadData];
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

- (void)shareToSina
{
    [[ADAccountCenter sharedADAccountCenter] syncDataBySendData:nil];
}
#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    
    return 5;
}


//动态改变每一行的高度
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    if (CELL_SECTION) {
        return 60/2;
    }else{
        return 110/2;
    }
    
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    
    
    static NSString *CellIdentifierSection = @"CellSection";
    //  static NSString *CellIdentifierIndicate = @"CellIndicate";
    ADSettingSectionCell *cellSection = [tableView dequeueReusableCellWithIdentifier:CellIdentifierSection];
    // ADAccoundCell *cellIndicate = [tableView dequeueReusableCellWithIdentifier:CellIdentifierIndicate];
    
    //类分区
    if (CELL_SECTION) {
        if (cellSection == nil ) {
            cellSection = [[ADSettingSectionCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifierSection];
        }
        cellSection.selectionStyle = UITableViewCellSelectionStyleNone;//选中无效果
        cellSection.titleLabel.text = [_titleArray objectAtIndex:indexPath.row];
        return cellSection;
    }
    //带箭头
    else {
        
        ADAccoundCell *cellIndicate = [[ADAccoundCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:nil];
        
        cellIndicate.cellType = (int)indexPath.row;
        cellIndicate.iconImage.image = [UIImage imageNamed:[self.iconArray objectAtIndex:indexPath.row]];
        cellIndicate.titleLabel.text = [_titleArray objectAtIndex:indexPath.row];
        cellIndicate.contentLabel.text = [_contentArray objectAtIndex:indexPath.row];
        cellIndicate.swichOnBlock = ^(NSInteger ADSwichIndex){
            
            switch (ADSwichIndex) {
                case CELL_TYPE_SINA:
                    NSLog(@"绑定新浪微博");
                    [[ADAccountCenter sharedADAccountCenter] getOAuthSina];
                    break;
                case CELL_TYPE_QQ:
                    NSLog(@"绑定QQ");
                    [self bindQQ];
                    break;
                case CELL_TYPE_BAIDU:
                    NSLog(@"绑定百度账号");
                    break;
                    
                default:
                    break;
            }
            
            
        };
        
        cellIndicate.swichOffBlock = ^(NSInteger ADSwichIndex){
            
            switch (ADSwichIndex) {
                case CELL_TYPE_SINA:
                    NSLog(@"取消绑定新浪微博");
                    [self cancelSinaBind];
                    break;
                case CELL_TYPE_QQ:
                    NSLog(@"取消绑定QQ");
                    [self cancelQQbind];
                    break;
                case CELL_TYPE_BAIDU:
                    NSLog(@"取消绑定百度账号");
                    break;
                    
                default:
                    break;
            }
            
            
        };
        
        
        cellIndicate.selectionStyle = UITableViewCellSelectionStyleNone;//选中灰色效果
        return cellIndicate;
        
    }
    
}

#pragma mark -新浪账号绑定和解除绑定
//绑定新浪账户
-(void)oAuthSinaSuccessful:(NSNotification *)notification
{
    
    NSLog(@"仅仅拿个授权第三方新浪微博授权成功----%@",[notification userInfo]);//拿到了新浪微博的token
    NSDictionary *dic = notification.userInfo;
    //拿到新浪微博的token,再向本地服务器发送一个请求（前提使用户已经登录）
    NSString *token = [dic objectForKeyedSubscript:ACCOUNT_SINA_TOKEN];
    if ([[NSUserDefaults standardUserDefaults] objectForKey:ACCOUNT_ADDING_TOKEN]) {
        
        [[ADAccountCenter sharedADAccountCenter] bindingThirdpartyToken:token thirdPartyType:ADACCOUNT_TYPE_SINA withTarget:self success:@selector(bindSinaSucessful:) failure:@selector(bindSinaFailure:)];//绑定
    }else{
        NSLog(@"未登录，无法绑定...");
        //走第三方账户登录通道
        [[ADAccountCenter sharedADAccountCenter] postThirdpartyTokenTolocalServer:token thirdPartyType:ADACCOUNT_TYPE_SINA withTarget:self success:@selector(bindSinaSucessful:) failure:@selector(bindSinaFailure:)];
    }
    
}
-(void)oAuthSinaFailure:(NSNotification *)notification
{
    //[[NSUserDefaults standardUserDefaults] setObject:@"0" forKey:WEIBO_ENABLED_KEY];
    [[ADAccountCenter sharedADAccountCenter] showAlertWithMessage:@"绑定失败"];
    
    [self.tableView reloadData];
}

//
- (void)bindSinaSucessful:(id)obj
{
    [[NSUserDefaults standardUserDefaults] setObject:@"1" forKey:WEIBO_ENABLED_KEY];
    [self.tableView reloadData];
}
- (void)bindSinaFailure:(id)obj
{
    [[ADAccountCenter sharedADAccountCenter] showAlertWithMessage:@"绑定失败"];
     [self.tableView reloadData];
}

//解除新浪账户绑定
- (void)cancelSinaBind
{
    //解除绑定
    [[ADAccountCenter sharedADAccountCenter] outOAuthSina];
 
    //调取本地解除绑定接口
    [[ADAccountCenter sharedADAccountCenter] removeBindingThirdpartyToken:nil thirdPartyType:ADACCOUNT_TYPE_SINA withTarget:self success:@selector(cancleSinaBindSuccessful:) failure:@selector(cancleSinaBindFailure:)];
}
- (void)cancleSinaBindSuccessful:(id)obj
{
    //删除本地存储token
    [[NSUserDefaults standardUserDefaults] removeObjectForKey:ACCOUNT_SINA_KEY];
    [[NSUserDefaults standardUserDefaults] setObject:@"0" forKey:WEIBO_ENABLED_KEY];
    [[NSUserDefaults standardUserDefaults] synchronize];
    [self.tableView reloadData];
    //在页面刷新之后取消昵称的存储。也就是说账号页面的昵称现在不改变，但是确保当进设置页面的时候，昵称重新请求网络
    [[NSUserDefaults standardUserDefaults] setObject:nil forKey:ACCOUNT_ADDING_NICKNAME];
    [[NSUserDefaults standardUserDefaults] synchronize];
    
    NSLog(@"取消本地存储的昵称%@",[[NSUserDefaults standardUserDefaults] objectForKey:ACCOUNT_ADDING_NICKNAME]);
}
- (void)cancleSinaBindFailure:(id)obj
{
    [[ADAccountCenter sharedADAccountCenter] showAlertWithMessage:@"解除绑定失败"];
    [self.tableView reloadData];
}

#pragma mark - QQ账号绑定和解除绑定
- (void)bindQQ
{
    [self changeUrlTypeOfAppdelegateWithType:ADACCOUNT_TYPE_TENCENT];
    
    
        NSLog(@"腾讯QQ登录授权");
        self.tencentOAuth = [[TencentOAuth alloc] initWithAppId:kQQAppKey andDelegate:self];
        _tencentOAuth.redirectURI = kQQRedirectURI;
        
        NSArray *permissions = [NSArray arrayWithObjects:@"get_user_info", @"add_t", nil];
        
        [_tencentOAuth authorize:permissions inSafari:NO];
    
    
    
}
- (void)cancelQQbind
{
    if (self.tencentOAuth == nil) {
        NSLog(@"腾讯QQ取消登录授权");
        self.tencentOAuth = [[TencentOAuth alloc] initWithAppId:kQQAppKey andDelegate:self];
        _tencentOAuth.redirectURI = kQQRedirectURI;
    }
    
    [_tencentOAuth logout:self];
    
    

    
    //调取本地解除绑定接口
     [[ADAccountCenter sharedADAccountCenter] removeBindingThirdpartyToken:nil thirdPartyType:ADACCOUNT_TYPE_TENCENT withTarget:self success:@selector(cancleQQBindSuccessful:) failure:@selector(cancleQQBindFailure:)];
    
    
}

#pragma mark - QQ授权代理方法
-(void)tencentDidNotLogin:(BOOL)cancelled
{
    if (cancelled)
    {
        NSLog(@"取消了登录");
        [self bindQQFailure:nil];
    }
    else
    {
        [self.tableView reloadData];//保持不变
    }
}

- (void)tencentDidLogin
{
    NSLog(@"登陆成功");
    if (_tencentOAuth.accessToken && 0 != [_tencentOAuth.accessToken length])
    {
        // 记录登录用户的OpenID、Token以及过期时间
        NSLog(@"获取的token是%@",_tencentOAuth.accessToken);
        
        NSString *token = _tencentOAuth.accessToken;
        
        [[NSUserDefaults standardUserDefaults] setObject:token forKey:ACCOUNT_QQ_TOKEN];
        [[NSUserDefaults standardUserDefaults] synchronize];
        
        if ([[NSUserDefaults standardUserDefaults] objectForKey:ACCOUNT_ADDING_TOKEN]) {
            
             [[ADAccountCenter sharedADAccountCenter] bindingThirdpartyToken:token thirdPartyType:ADACCOUNT_TYPE_TENCENT withTarget:self success:@selector(bindQQSuccessful:) failure:@selector(bindQQFailure:)];//绑定
        }else{
            NSLog(@"未登录，无法绑定...");
            //走第三方账户登录通道
            [[ADAccountCenter sharedADAccountCenter] postThirdpartyTokenTolocalServer:token thirdPartyType:ADACCOUNT_TYPE_TENCENT withTarget:self success:@selector(bindQQSuccessful:) failure:@selector(bindQQFailure:)];
        }
        
    }
    else
    {
        NSLog(@"登录不成功 没有获取accesstoken");
        //要做一些不成功的操作
        [self bindQQFailure:nil];
        
    }
}
- (void)bindQQSuccessful:(id)obj
{
    [[NSUserDefaults standardUserDefaults] setObject:@"1" forKey:QQ_ENABLED_KEY];
    [self.tableView reloadData];
}
- (void)bindQQFailure:(id)obj
{
    [[ADAccountCenter sharedADAccountCenter] showAlertWithMessage:@"绑定失败"];
    [self.tableView reloadData];
}
- (void)cancleQQBindSuccessful:(id)obj
{
    //删除本地存储token
    [[NSUserDefaults standardUserDefaults] removeObjectForKey:ACCOUNT_QQ_TOKEN];
    [[NSUserDefaults standardUserDefaults] setObject:@"0" forKey:QQ_ENABLED_KEY];
    [[NSUserDefaults standardUserDefaults] synchronize];
    [self.tableView reloadData];
    
    //在页面刷新之后取消昵称的存储。也就是说账号页面的昵称现在不改变，但是确保当进设置页面的时候，昵称重新请求网络
    [[NSUserDefaults standardUserDefaults] removeObjectForKey:ACCOUNT_ADDING_NICKNAME];
    [[NSUserDefaults standardUserDefaults] synchronize];

}
- (void)cancleQQBindFailure:(id)obj
{
    [[ADAccountCenter sharedADAccountCenter] showAlertWithMessage:@"解除绑定失败"];
    [self.tableView reloadData];

}
#pragma mark - 改变appdelegate的 urlType属性的值
- (void)changeUrlTypeOfAppdelegateWithType:(ADACCOUNT_TYPE)type
{
    ADAppDelegate *delegate = (ADAppDelegate *)[[UIApplication sharedApplication] delegate];
    delegate.urlType = type;
}


#pragma mark - button event
- (void)exitAccount
{

    [[ADAccountCenter sharedADAccountCenter] exit];
    
    [self.navigationController popToRootViewControllerAnimated:YES];
    
    ADAppDelegate * appDelegate =APP_DELEGATE;
    ADLoginFirstVC *loginFirstVC = [[ADLoginFirstVC alloc] initWithNavigationViewWithTitle:@""];
    ADNavigationController *loginFirstNav = [[ADNavigationController alloc] initWithRootViewController:loginFirstVC];
    
    //ADNavigationController *nav = appDelegate.loginFirstNav;
    appDelegate.window.rootViewController = loginFirstNav;
    
    
//    ADLoginFirstVC *loginFirstVC = [nav.viewControllers objectAtIndex:0];
//    loginFirstVC.view.frame = CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT);
//    [appDelegate.window bringSubviewToFront:loginFirstVC.view];
    //直接到注册登录界面
//    self.firstLoginVC =  [[ADLoginFirstVC alloc] init];
//    UIWindow *shareWindow =((ADAppDelegate *)[[UIApplication sharedApplication] delegate]).window;
//    [shareWindow addSubview:_firstLoginVC.view];
    
    
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
