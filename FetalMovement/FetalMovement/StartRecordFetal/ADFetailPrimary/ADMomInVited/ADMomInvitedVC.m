//
//  ADMomInvitedVC.m
//  FetalMovement
//
//  Created by 大头滴血 on 14-3-20.
//  Copyright (c) 2014年 wang peng. All rights reserved.
//

#import "ADMomInvitedVC.h"
#import "ADShareView.h"
#define recommendButton_tag (20001)

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

- (void)loadView{
    [super loadView];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    [self configureNavigationView];
    
	CGRect rect = self.view.frame;
    rect.origin.y += (navItem_height + statusBar_height);
    rect.size.height -= (navItem_height + statusBar_height);
    
    UIScrollView * bg_view = [[UIScrollView alloc]initWithFrame:rect];
    
    [self.view addSubview:bg_view];
    
    UIImageView *headerImageView = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, 320, 240)];
    headerImageView.image = [UIImage imageNamed:@"AD人头@2x"];
    [bg_view addSubview:headerImageView];
    
    //邀请更多
    UIButton * recommendButton = [[UIButton alloc]init];
    [bg_view addSubview:recommendButton];
    recommendButton.tag = recommendButton_tag;
    recommendButton.frame = CGRectMake(50, 20 + headerImageView.frame.size.height, 220, 55);
    recommendButton.titleLabel.font = [UIFont systemFontOfSize:17];
    [recommendButton setTitle:@"告诉更多妈妈" forState:UIControlStateNormal];
    [recommendButton setBackgroundImage:[UIImage imageNamed:@"AD邀请妈妈按钮@2x"] forState:UIControlStateNormal];
    [recommendButton addTarget:self action:@selector(recommendAction:) forControlEvents:UIControlEventTouchUpInside];
    recommendButton.tintColor = [UIColor blackColor];//与544,224位妈妈一起记录胎动吧!
    
    UILabel * label = [[UILabel alloc]init];
    label.font = [UIFont systemFontOfSize:17];
    NSString *string =  [NSString stringWithFormat:@"与544,224位妈妈一起记录胎动吧!"];
    label.text = string;
    label.textColor = UIColorFromRGB(0xFF7685);
    float width = [string sizeWithFont:[UIFont systemFontOfSize:17] constrainedToSize:CGSizeMake(10000, 20)].width;
    label.frame = CGRectMake(30, recommendButton.frame.size.height + recommendButton.frame.origin.y + 10, width, 30);
    [bg_view addSubview:label];
    
    UIImageView * mapView = [[UIImageView alloc]initWithFrame:CGRectMake(0, label.frame.size.height + label.frame.origin.y + 5, 320, 150)];
    mapView.image = [UIImage imageNamed:@"AD地图@2x"];
    [bg_view addSubview:mapView];
    
    bg_view.contentSize = CGSizeMake(320, mapView.frame.size.height + mapView.frame.origin.y);
}

- (void)recommendAction:(UIButton *)button{
    [ADShareView createShareView:self.view];
}

#pragma mark - navigation button event
- (void)clickLeftButton
{
    [self.navigationController popToRootViewControllerAnimated:YES];
}

- (void)configureNavigationView
{
    self.navigationView.backgroundColor = UIColorFromRGB(0xFF536E);
    
    CGRect navRect = self.navigationView.titleLabel.frame;
    navRect.size.width += 30;
    navRect.origin.x -= 10;
    self.navigationView.titleLabel.frame = navRect;
    self.navigationView.titleLabel.font = [UIFont systemFontOfSize:18];
    self.navigationView.titleLabel.textColor = [UIColor whiteColor];
    
    [self.navigationView.backButton setBackgroundImage:[UIImage imageNamed:@"navigation_backbutton_bg@2x"] forState:UIControlStateNormal];
}





@end
