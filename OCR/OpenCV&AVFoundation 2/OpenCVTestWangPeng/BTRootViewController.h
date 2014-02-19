//
//  BTRootViewController.h
//  OpenCVTestWangPeng
//
//  Created by wangpeng on 14-2-11.
//  Copyright (c) 2014年 wangpeng. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface BTRootViewController : UIViewController<UIImagePickerControllerDelegate,
UINavigationControllerDelegate>
{
    cv::VideoCapture *_videoCapture;
    cv::Mat _lastFrame;
}

@property (nonatomic, strong)UIImageView *imageView;
@property (nonatomic, strong)UIImageView *alphaImageView;
@property (nonatomic,strong)UIButton *captureButton;

@end
