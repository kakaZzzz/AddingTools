//
//  ADSetPrimaryVC.m
//  FetalMovement
//
//  Created by wangpeng on 14-3-2.
//  Copyright (c) 2014年 wang peng. All rights reserved.
//

#import "ADSetPrimaryVC.h"
#import "ADAccountCenter.h"
#import "ADSettingSectionCell.h"
#import "ADSettingCell.h"
#import "ADBannerView.h"
//
#import "ADDuedateVC.h"
#import "ADAccountVC.h"
#import "ADLoginVC.h"
#define CELL_SECTION (indexPath.row == 0 || indexPath.row == 3)

@interface ADSetPrimaryVC ()
@property(nonatomic,strong) UITableView *tableView;

//
@property(nonatomic,strong) NSString *acccount;
@property(nonatomic,strong) NSString *duedate;
@property(nonatomic,strong) NSString *version;
@end

@implementation ADSetPrimaryVC

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
 
        
        //data sourse
        NSString *path = [[NSBundle mainBundle] pathForResource:@"SettingTabelViewPropertyList" ofType:@"plist"];
        NSDictionary *resourseDic = [NSDictionary dictionaryWithContentsOfFile:path];
        self.titleArray = [resourseDic objectForKey:@"title"];
        self.iconArray = [resourseDic objectForKey:@"icon"];
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    [self configureNavigationView];
    
    UIButton *shareButton = [UIButton buttonWithType:UIButtonTypeCustom];
    shareButton.frame = CGRectMake(100, 200, 100, 100);
    [shareButton setTitle:@"分享" forState:UIControlStateNormal];
    shareButton.backgroundColor = [UIColor blueColor];
    [shareButton addTarget:self action:@selector(shareToSina) forControlEvents:UIControlEventTouchUpInside];
    //    [self.view addSubview:shareButton];
    

    int navigationHeight = [[ADUIParamManager sharedADUIParamManager] getNavigationBarHeight];
    
    //banner
    NSArray *imageArray = [NSArray arrayWithObjects:@"banner_1",@"banner_2", nil];
    ADBannerView *banner = [[ADBannerView alloc] initWithFrame:CGRectMake(0, navigationHeight, SCREEN_WIDTH, 260/2) delegate:self focusImageItems:imageArray];
    [self.view addSubview:banner];
    
    
    self.tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, navigationHeight + 260/2, SCREEN_WIDTH, self.view.frame.size.height - (navigationHeight + 260/2 + 50)) style:UITableViewStylePlain];
    
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    self.tableView.separatorColor = [UIColor clearColor];
    self.tableView.showsVerticalScrollIndicator = NO;
    [self.view addSubview:self.tableView];
    
	// Do any additional setup after loading the view.
}

- (void)configureNavigationView
{
    
    
    self.navigationView.backgroundColor = [UIColor whiteColor];
    self.navigationView.titleLabel.textColor = kOrangeFontColor;
    
}

#pragma tap banner event
- (void)tapImageFrame:(ADBannerView *)imageFrame didSelectItem:(int)item
{
    NSLog(@"点击的是哪副图%d",item);
}

- (void)viewWillAppear:(BOOL)animated
{
    
    //获取第三方账号信息(是否绑定)
    [[ADAccountCenter sharedADAccountCenter] getThirdPartyBindInfomationWithOAuthtoken:nil];
    
<<<<<<< HEAD
    NSString *nickName=@"";
    
    NSLog(@"本地昵称是多少啊啊啊  %@",[[NSUserDefaults standardUserDefaults] objectForKey:ACCOUNT_ADDING_NICKNAME]);
    
    //前提看有没有登录，没有登录直接就显示未登录
    if ([[NSUserDefaults standardUserDefaults] objectForKey:ACCOUNT_ADDING_TOKEN] == nil) {//登录态
        NSLog(@"未登录状态");
         nickName = @"未登录";
    }else{
       
        if ([[NSUserDefaults standardUserDefaults] objectForKey:ACCOUNT_ADDING_NICKNAME] == nil) {
            //获取用户信息(昵称)
            NSLog(@"请求网络获取昵称");
            [[ADAccountCenter sharedADAccountCenter] getUserInfoWithToken:nil withTarget:self success:@selector(getAddingUserInfoSuccessful:) failure:@selector(getAddingUserInfoFailure:)];
        }else{
            nickName = [[NSUserDefaults standardUserDefaults] objectForKey:ACCOUNT_ADDING_NICKNAME];
            NSLog(@"直接取本地昵称是111。。。。。。%@",nickName);
        }
        
  
    }
    
    
    if (nickName == nil) {
=======
    
    NSString *nikeName=@"";
    if ([[NSUserDefaults standardUserDefaults] objectForKey:ACCOUNT_ADDING_NICKNAME] == nil) {
        //获取用户信息(昵称)
        [[ADAccountCenter sharedADAccountCenter] getUserInfoWithToken:nil withTarget:self success:@selector(getAddingUserInfoSuccessful:) failure:@selector(getAddingUserInfoFailure:)];
    }else{
        nikeName = [[NSUserDefaults standardUserDefaults] objectForKey:ACCOUNT_ADDING_NICKNAME];
        NSLog(@"昵称是。。。。。。%@",nikeName);
    }

    if (nikeName == nil) {
>>>>>>> FETCH_HEAD
        self.acccount = @"";
    }else{
        self.acccount =nickName;
    }

    self.duedate = @"2014-08-25";
    
    NSDate *date = [[ADAccountCenter sharedADAccountCenter] getDuedate];
    if (date) {
        NSString *dateAndTime = [NSDate stringFromDate:date withFormat:@"yyyy-MM-dd"];
        self.duedate = dateAndTime;
    }
    
    NSString *versionString =  [[[NSBundle mainBundle] infoDictionary] objectForKey:(NSString*)kCFBundleVersionKey];//获取版本号
    self.version = [NSString stringWithFormat:@"V%@",versionString];
    //从coredata中读取数据
    
    self.contentArray = [NSArray arrayWithObjects:@"",_acccount,_duedate,@"",@"",@"",_version,@"",nil];
    
    [self.tableView reloadData];
    
}

- (void)getAddingUserInfoSuccessful:(id)obj
{
    NSLog(@"返回的昵称是%@",obj);
    NSString *nickname = obj;
    if (nickname == nil) {
        self.acccount = @"";
    }else{
        self.acccount = nickname;
    }
    
     self.contentArray = [NSArray arrayWithObjects:@"",_acccount,_duedate,@"",@"",@"",_version,@"",nil];
    [self.tableView reloadData];
}
- (void)getAddingUserInfoFailure:(id)obj
{
    
}
#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    
    return 8;
}


//动态改变每一行的高度
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    if (CELL_SECTION) {
        return 60/2;
    }else{
        return 100/2;
    }
    
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    
    
    static NSString *CellIdentifierSection = @"CellSection";
    static NSString *CellIdentifierIndicate = @"CellIndicate";
    ADSettingSectionCell *cellSection = [tableView dequeueReusableCellWithIdentifier:CellIdentifierSection];
    ADSettingCell *cellIndicate = [tableView dequeueReusableCellWithIdentifier:CellIdentifierIndicate];
    
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
        if (cellIndicate == nil ) {
            cellIndicate = [[ADSettingCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifierIndicate];
        }
        
        cellIndicate.iconImage.image = [UIImage imageNamed:[self.iconArray objectAtIndex:indexPath.row]];
        cellIndicate.titleLabel.text = [_titleArray objectAtIndex:indexPath.row];
        cellIndicate.contentLabel.text = [_contentArray objectAtIndex:indexPath.row];
        cellIndicate.selectionStyle = UITableViewCellSelectionStyleNone;//选中无效果
        //        cellIndicate.indexRow = indexPath.row;
        //        //cellIndicate.indicateImage = UITableViewCellAccessoryDisclosureIndicator;
        
        //        cellIndicate.selectionStyle = UITableViewCellSelectionStyleGray;//选中灰色效果
        return cellIndicate;
        
    }
    return nil;
}

#pragma mark - tabelview delegate
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    switch (indexPath.row) {
        case 0:
            break;
        case 1:{
            
            if ([[NSUserDefaults standardUserDefaults] objectForKey:ACCOUNT_ADDING_TOKEN] == nil) {
                
                ADLoginVC *loginVC = [[ADLoginVC alloc]initWithNavigationViewWithTitle:@"登录"];
                [self.navigationController pushViewController:loginVC animated:YES];
            }else{
                ADAccountVC *accountVC = [[ADAccountVC alloc] initWithNavigationViewWithTitle:@"账号"];
                [self.navigationController pushViewController:accountVC animated:YES];

            }
            
        }
            
            break;
        case 2:{
            ADDuedateVC *dueDateVC = [[ADDuedateVC alloc] initWithNavigationViewWithTitle:@"设置预产期"];
            [self.navigationController pushViewController:dueDateVC animated:YES];
        }
            break;
        default:
            break;
    }
    
    //    switch (indexPath.row) {
    //        case 1://修改生日
    //        {
    //            BTModifyDateViewController *modifyVC = [[BTModifyDateViewController alloc] init];
    //            modifyVC.modifyType = MODIFY_BIRTHDAY_TYPE;
    //            modifyVC.hidesBottomBarWhenPushed = YES;
    //            [modifyVC.navigationItem setHidesBackButton:YES];//隐藏系统的返回按钮
    //
    //            [self.navigationController pushViewController:modifyVC animated:YES];
    //        }
    //            break;
    //        case 2://修改末次月经日期
    //        {
    //            BTModifyDateViewController *modifyVC = [[BTModifyDateViewController alloc] init];
    //            modifyVC.modifyType = MODIFY_MENSTRUATION_TYPE;
    //            [modifyVC.navigationItem setHidesBackButton:YES];
    //            modifyVC.hidesBottomBarWhenPushed = YES;
    //            [self.navigationController pushViewController:modifyVC animated:YES];
    //        }
    //            break;
    //        case 3://修改预产期
    //        {
    //            BTModifyDateViewController *modifyVC = [[BTModifyDateViewController alloc] init];
    //            modifyVC.modifyType = MODIFY_DUEDATE_TYPE;
    //            [modifyVC.navigationItem setHidesBackButton:YES];
    //            modifyVC.hidesBottomBarWhenPushed = YES;
    //            [self.navigationController pushViewController:modifyVC animated:YES];
    //        }
    //            break;
    //        case 5://检查更新
    //        {
    //            // 检查更新
    //            // [BTCheckVersion checkVersion];
    //
    //        }
    //            break;
    //        case 6:
    //        {
    //            //打开AppStore去评分
    //            //[[UIApplication sharedApplication] openURL:[NSURL URLWithString:@"https://itunes.apple.com/cn/app/bai-du-yin-le/id468623917?mt=8"]];
    //        }
    //            break;
    //        case 7://关于
    //        {
    //            BTAboutViewController *aboutVC = [[BTAboutViewController alloc] init];
    //            aboutVC.hidesBottomBarWhenPushed = YES;
    //            [self.navigationController pushViewController:aboutVC animated:YES];
    //        }
    //            break;
    //        case 8://意见反馈
    //        {
    //            BTFeedbackViewController *feedbackVc = [[BTFeedbackViewController alloc]init];
    //            [feedbackVc.navigationItem setHidesBackButton:YES];//隐藏系统的返回按钮
    //            feedbackVc.hidesBottomBarWhenPushed = YES;
    //            feedbackVc.toRecipients = [NSArray arrayWithObject:@"yituwangpeng@gmail.com"];
    //            feedbackVc.ccRecipients = nil;
    //            feedbackVc.bccRecipients = nil;
    //            [self.navigationController pushViewController:feedbackVc animated:YES];
    //
    //        }
    //            break;
    //
    //        default:
    //            break;
    //    }
    //
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
        //[[ADAccountCenter sharedADAccountCenter] removeBindingThirdpartyToken:nil thirdPartyType:ADACCOUNT_TYPE_SINA];
        
        
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


- (void)shareToSina
{

//    UIImage *aimage = [UIImage imageNamed:@"sina_icon"];
//    NSData *imageData = UIImageJPEGRepresentation(aimage,1);
//    [[ADAccountCenter sharedADAccountCenter] shareToSinaWeiboWithText:@"12" picture:imageData];
    [[ADAccountCenter sharedADAccountCenter]syncDataBySendData:[NSDate localdate]];
}
- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
