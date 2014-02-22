//
//  ADCameraViewController.h
//  ISTHideCameraShutterDemo
//
//  Created by  wangpeng on 14-2-15.
//  Copyright (c) 2014年 wangpeng. All rights reserved.
//

#import <UIKit/UIKit.h>
#define MAX_AREA 10000
typedef enum{
    ISTCameraFlashModeAuto = 1,
    ISTCameraFlashModeOn,
    ISTCameraFlashModeOff,
}ISTCameraFlashMode;

@class ADPreviewView;
@interface ADCameraViewController : UIViewController

@property(nonatomic,strong)ADPreviewView *drawView;

@end
