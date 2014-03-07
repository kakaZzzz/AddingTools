//
//  ADCameraViewController.h
//  ISTHideCameraShutterDemo
//
//  Created by  wangpeng on 14-2-15.
//  Copyright (c) 2014年 wangpeng. All rights reserved.
//

#import <UIKit/UIKit.h>
#define MIN_DETECT_AREA         10000
#define MIN_PHOTO_AREA          80000


#import "ADPreviewView.h"
#import "ADCameraViewController.h"
#import "ADCameraHelper.h"
#import "ADViewPhotoViewController.h"

#import "ADContours.h"


@interface ADCameraViewController : UIViewController<ADPreviewViewDelegate>

@property(nonatomic,strong)ADPreviewView *drawView;
@property(nonatomic,strong)UILabel* centerLabel;
@property(nonatomic, strong)UIImage* currentImage;
@property(nonatomic, strong)ADCameraHelper* helper;

@end
