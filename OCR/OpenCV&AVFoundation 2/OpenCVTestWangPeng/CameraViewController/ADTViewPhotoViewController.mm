//
//  ADViewPhotoViewController.m
//  AVFoundationCamera
//
//  Created by 陈 爱彬 on 13-10-8.
//  Copyright (c) 2013年 陈 爱彬. All rights reserved.
//

#import "ADViewPhotoViewController.h"
#import "UIImage+OpenCV.h"

#import "opencv2/opencv.hpp"
@interface ADViewPhotoViewController ()
@property(nonatomic,strong)UIImageView *photoImageView;
@end

@implementation ADViewPhotoViewController
@synthesize photoImage = _photoImage;

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
    //预览图片
    NSLog(@"图片宽高%f,%f",_photoImage.size.width,_photoImage.size.height);
    self.photoImageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 320, self.view.frame.size.height)];
    _photoImageView.image = _photoImage;
    [self.view addSubview:_photoImageView];
    
    // Do any additional setup after loading the view.
    UIButton *backBtn = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    backBtn.frame = CGRectMake(10, 10, 80, 30);
    [backBtn setTitle:@"返回" forState:UIControlStateNormal];
    [backBtn addTarget:self action:@selector(backToCamera) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:backBtn];
    
    UIButton *processBtn = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    processBtn.frame = CGRectMake(backBtn.frame.origin.x + backBtn.frame.size.width + 50, backBtn.frame.origin.y, 80, 30);
    [processBtn setTitle:@"矫正" forState:UIControlStateNormal];
    [processBtn addTarget:self action:@selector(processImage) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:processBtn];

  }

- (void)backToCamera
{
    [self.navigationController popViewControllerAnimated:YES];
}
- (void)processImage
{
    UIImage *processImage = [self getDesimageWithTransformFromSourceImage:_photoImage];
    _photoImageView.image = processImage;

}
- (UIImage *)getDesimageWithTransformFromSourceImage:(UIImage *)srcImage
{
        using namespace cv;
    
        int lowThreshold = 100;
        int ratio = 3;
        int kernel_size = 3;
    
        Mat lastFrame = [srcImage CVMat];
        Mat grayFrame,output;
    
        resize(lastFrame, lastFrame, cv::Size(568,320));
    
    //打印图像尺寸
    //  Convert captured frame to grayscale  灰度图
        cvtColor(lastFrame, grayFrame,COLOR_RGB2GRAY);
    
    //使用Canny算法进行边缘检测,返回图像即是二值单通道的图
        Canny(grayFrame, output,
            lowThreshold,
              lowThreshold * ratio,
              kernel_size);

       //使用 findContours 找轮廓
        vector<vector<cv::Point>> contours;
        findContours(output, contours, CV_RETR_EXTERNAL, CV_CHAIN_APPROX_NONE);
    
        double area, maxArea = 0;
        int maxIdx = 0;
    
        for( int i = 0; i< contours.size(); i++ )
        {
    
            //找到面积最大的
            area = fabs(contourArea(contours[i]));
            if(area > maxArea)
            {
                maxIdx = i;
                maxArea = area;
            }
        }
    
        vector<cv::Point> approxCurve;
        //将vector转换成Mat型，此时的Mat还是列向量，只不过是2个通道的列向量而已
        Mat contourMat = Mat(contours[maxIdx]);
        double eps = contours[maxIdx].size() * 0.05;
        approxPolyDP(contourMat, approxCurve, eps, YES);
    NSLog(@"多边形逼近后的顶点数是%ld",approxCurve.size());
        if (approxCurve.size() != 4)
        {
            return nil;
                }

//        vector<cv::Point> src;
//        vector<cv::Point> dst;
//    
//            for(int i=0; i<4; i++)
//            {
//                src[i] = approxCurve[i];
//            }
//    
//        cv::Size imgSize = contourMat.size();
//        //dst赋值，从零点开始顺时针
//        dst[0].x = 0;
//        dst[0].y = 0;
//        dst[1].x = imgSize.width-1;
//        dst[1].y = 0;
//        dst[2].x = imgSize.width-1;
//        dst[2].y = imgSize.height-1;
//        dst[3].x = 0;
//        dst[3].y = imgSize.height-1;
//    
    
        Mat dstImg;    //通过4个点得到变换矩阵,然后进行变换
//        Mat warpMat = getPerspectiveTransform(src, dst);
//    warpPerspective(contourMat, dstImg, warpMat, imgSize);
    
    UIImage *resultImage = [UIImage imageWithCVMat:grayFrame];
    
    
        lastFrame.release();
       grayFrame.release();
        output.release();
    
    contours.clear();
        
    return resultImage;
    
}
- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
