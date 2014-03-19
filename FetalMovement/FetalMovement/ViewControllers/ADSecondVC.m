//
//  ADSecondVC.m
//  FetalMovement
//
//  Created by wangpeng on 14-3-2.
//  Copyright (c) 2014年 wang peng. All rights reserved.
//

#import "ADSecondVC.h"
#import "ADThirdVC.h"
@interface ADSecondVC ()

@end

@implementation ADSecondVC

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
    self.view.backgroundColor = [UIColor greenColor];
    
    [self.navigationView.backButton setBackgroundImage:[UIImage imageNamed:@"tab_fetalData@2x"] forState:UIControlStateNormal];
    // Do any additional setup after loading the view.
    UIButton *thirdButton = [UIButton buttonWithType:UIButtonTypeCustom];
    thirdButton.frame = CGRectMake(100, 100, 100, 100);
    thirdButton.backgroundColor = [UIColor redColor];
    [thirdButton setTitle:@"Enter" forState:UIControlStateNormal];
    [thirdButton addTarget:self action:@selector(pushNextView) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:thirdButton];
    
	// Do any additional setup after loading the view.
}
- (void)pushNextView
{
    ADThirdVC *secondVC = [[ADThirdVC alloc] initWithNavigationViewWithTitle:@"胎动三级详情"];
    [self.navigationController pushViewController:secondVC animated:YES];
}


- (void)clickLeftButton
{
    [self.navigationController popToRootViewControllerAnimated:YES];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
