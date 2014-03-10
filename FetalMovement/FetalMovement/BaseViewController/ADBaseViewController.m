//
//  ADBaseViewController.m
//  FetalMovement
//
//  Created by wangpeng on 14-3-2.
//  Copyright (c) 2014年 wang peng. All rights reserved.
//

#import "ADBaseViewController.h"


@interface ADBaseViewController ()

@end

@implementation ADBaseViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}
-(id)initWithNavigationViewWithTitle:(NSString *)title
{
    self = [super init];
    if (self) {
        if (IOS7_OR_LATER) {
            self.navigationView = [[ADNavigationView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 90/2 + 20)];

                    }
        else{
            self.navigationView = [[ADNavigationView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 90/2)];

        }
        _navigationView.backgroundColor = kNavigationViewColor;
        
        if (title) {
           _navigationView.titleLabel.text = title;

        }
        
    }
    
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    [self.navigationController setNavigationBarHidden:YES animated:NO];
    [self.view addSubview:_navigationView];
    
    //configure button image
    [self.navigationView.backButton addTarget:self action:@selector(clickLeftButton) forControlEvents:UIControlEventTouchUpInside];
    [self.navigationView.rightButton addTarget:self action:@selector(clickRightButton) forControlEvents:UIControlEventTouchUpInside];
    
	// Do any additional setup after loading the view.
}
//父类方法 ，由子类实现
- (void)clickLeftButton
{
    
}
- (void)clickRightButton
{
    
}
- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
