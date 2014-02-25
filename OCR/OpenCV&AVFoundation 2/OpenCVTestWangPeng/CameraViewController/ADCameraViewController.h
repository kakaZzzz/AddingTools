//
//  ADCameraViewController.h
//  ISTHideCameraShutterDemo
//
//  Created by  wangpeng on 14-2-15.
//  Copyright (c) 2014年 wangpeng. All rights reserved.
//

#import <UIKit/UIKit.h>
#define MIN_DETECT_AREA         10000
#define MIN_PHOTO_AREA          50000

typedef enum{
    ISTCameraFlashModeAuto = 1,
    ISTCameraFlashModeOn,
    ISTCameraFlashModeOff,
}ISTCameraFlashMode;

#import "ADPreviewView.h"
@interface ADCameraViewController : UIViewController<ADPreviewViewDelegate>

@property(nonatomic,strong)ADPreviewView *drawView;
@property(nonatomic,strong)UILabel* centerLabel;
@property(nonatomic, strong)UIImage* currentImage;


@end
