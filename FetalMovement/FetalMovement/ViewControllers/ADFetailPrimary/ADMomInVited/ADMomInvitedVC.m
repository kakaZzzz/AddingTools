//
//  ADMomInvitedVC.m
//  FetalMovement
//
//  Created by 大头滴血 on 14-3-20.
//  Copyright (c) 2014年 wang peng. All rights reserved.
//

#import "ADMomInvitedVC.h"

@interface ADMomInvitedVC ()

@end

@implementation ADMomInvitedVC

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    [self configureNavigationView];
	
}

#pragma mark - navigation button event
- (void)clickLeftButton
{
    [self.navigationController popToRootViewControllerAnimated:YES];
}

- (void)configureNavigationView
{
    
    
    self.navigationView.backgroundColor = [UIColor redColor];
    
    CGRect navRect = self.navigationView.titleLabel.frame;
    navRect.size.width += 30;
    navRect.origin.x -= 10;
    self.navigationView.titleLabel.frame = navRect;
    
    self.navigationView.titleLabel.textColor = kOrangeFontColor;
    
    [self.navigationView.backButton setBackgroundImage:[UIImage imageNamed:@"navigation_backbutton_bg@2x"] forState:UIControlStateNormal];
    
}




@end
