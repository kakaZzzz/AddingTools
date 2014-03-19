//
//  ADTabBarViewController.m
//  FetalMovement
//
//  Created by wangpeng on 14-3-2.
//  Copyright (c) 2014年 wang peng. All rights reserved.
//

#import "ADTabBarViewController.h"
#import "ADFetalPrimaryVC.h"
#import "ADSetPrimaryVC.h"
#import "ADNavigationController.h"
static NSString * keyFetalVCTitle = @"胎动";
static NSString * keySetVCTitle = @"设置";


#define kTabbarWidth 240/2
#define kTabbarHeight 126/2
#define kButtonWidth 161/2
@interface ADTabBarViewController ()

@end

@implementation ADTabBarViewController

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
	// Do any additional setup after loading the view.
    self.tabBar.hidden = YES;
    self.tabBar.tintColor = [UIColor clearColor];
    self.tabBar.selectedImageTintColor = [UIColor clearColor];
    self.tabBar.backgroundImage = [UIImage imageNamed:@"tabbar_bg"];
    //    self.tabBar.alpha = 0.1;
#if __IPHONE_OS_VERSION_MAX_ALLOWED >= 70000
    if (IOS7_OR_LATER) {
        self.tabBar.barStyle = UIBarStyleBlack;
        self.tabBar.translucent = YES;
        self.tabBar.barTintColor = [UIColor clearColor];
        [self.tabBar removeFromSuperview];
    }
#endif
    //self.tabBar.hidden = YES;
    [self loadSystemTabBarView];
    [self loadCustomTabBarView];
}
#pragma mark

-(void)selectedButtonWithIndex:(NSInteger)index
{
    self.selectedIndex = index;
    
}

#pragma mark
-(void)loadSystemTabBarView
{
    //init view controller
    ADFetalPrimaryVC *fetalVC = [[ADFetalPrimaryVC alloc] initWithNavigationViewWithTitle:nil];
    ADSetPrimaryVC *setVC = [[ADSetPrimaryVC alloc] initWithNavigationViewWithTitle:@"更多"];
    
    
    //init navigation controller
    ADNavigationController *navFetalVC = [[ADNavigationController alloc] initWithRootViewController:fetalVC];
    ADNavigationController* navSetVC = [[ADNavigationController alloc] initWithRootViewController:setVC];
    
    navFetalVC.hidesBottomBarWhenPushed = YES;
    navSetVC.hidesBottomBarWhenPushed = YES;
    //set root Title
    navFetalVC.title = keyFetalVCTitle;
    navSetVC.title = keySetVCTitle;
    
    //load into tabbar controller
    self.viewControllers = @[navFetalVC,navSetVC];
    
    
    self.delegate = self;
}

-(void)loadCustomTabBarView
{
    
    CGRect customBarFram = self.tabBar.frame;
    //        customBarFram.origin = CGPointZero;
    NSLog(@"customBarFram = %@",NSStringFromCGRect(customBarFram));
    
    self.customTabBar = [[ADTabBarView alloc] initWithFrame:CGRectMake(0, customBarFram.origin.y  - (kTabbarHeight - customBarFram.size.height), customBarFram.size.width, kTabbarHeight)];
    
    UIImage * fetalIcon = [UIImage imageNamed:@"tab_fetalData"];
    UIImage *recordFetalIcon = [UIImage imageNamed:@"tab_record"];
    UIImage * setIcon = [UIImage imageNamed:@"tab_setting"];
    
    UIImage * fetalIconHighlighted = [UIImage imageNamed:@"tab_fetalData_selected"];
    UIImage *recordFetalIconHighlighted = [UIImage imageNamed:@"tab_record_selected"];
    UIImage * setIconHighlighted = [UIImage imageNamed:@"tab_setting_selected"];
    
//    UIImage *tabButtonBackground = [UIImage imageNamed:@"tabbar_bg"];
//    UIImage *tabButtonBackgroundHighlighted = [[UIImage imageNamed:@"tabBar_selected"]
//                                               stretchableImageWithLeftCapWidth:4
//                                               topCapHeight:4];
    
    self.customTabBar.normalItemImages = @[fetalIcon,recordFetalIcon,setIcon];
    self.customTabBar.highlightItemImages = @[fetalIconHighlighted,recordFetalIconHighlighted,setIconHighlighted];
   // self.customTabBar.normalItemBackgroundImages = @[tabButtonBackground];
   // self.customTabBar.highlightItemBackgroundImages = @[tabButtonBackgroundHighlighted];
    
    self.customTabBar.delegate = self;
    [self.view addSubview:_customTabBar];
}


- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
