//
//  ADMainViewController.m
//  AVFoundationCamera
//
//  Created by  wangpeng on 14-2-15.
//  Copyright (c) 2014年 wangpeng. All rights reserved.
//

#import "ADMainViewController.h"
#import "ADCameraViewController.h"

@interface ADMainViewController ()
<UINavigationControllerDelegate,
UIImagePickerControllerDelegate>

@end

@implementation ADMainViewController

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
    UIButton *takePhotoBtn = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    takePhotoBtn.frame = CGRectMake(110, 100, 100, 40);
    [takePhotoBtn setTitle:@"拍照" forState:UIControlStateNormal];
    [takePhotoBtn addTarget:self action:@selector(customPhotoTake:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:takePhotoBtn];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
//自定义相机
- (void)customPhotoTake:(UIButton *)btn
{
    ADCameraViewController *cameraVc = [[ADCameraViewController alloc] init];
    UINavigationController *cameraNavigationController = [[UINavigationController alloc] initWithRootViewController:cameraVc];
    cameraNavigationController.navigationBarHidden = YES;
    [self presentViewController:cameraNavigationController animated:YES completion:^{
      }];
}
//系统相机
- (void)takePhoto:(UIButton *)btn
{
    UIImagePickerControllerSourceType sourceType = UIImagePickerControllerSourceTypeCamera;
    if (![UIImagePickerController isSourceTypeAvailable: UIImagePickerControllerSourceTypeCamera]) {
        sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
    }
    UIImagePickerController *picker = [[UIImagePickerController alloc] init];
    picker.delegate = self;
    picker.sourceType = sourceType;
    [self presentViewController:picker animated:YES completion:^{
        
    }];
}
@end
